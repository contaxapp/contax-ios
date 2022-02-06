//
//  ContactModel.swift
//  Contax
//
//  Created by Arpit Bansal on 7/18/20.
//

import Foundation
import UIKit
import Contacts
import RealmSwift
import CryptoKit

class ContactsModel: ObservableObject {
    
    let realm = try! Realm()
    
    @Published var contacts: Results<DBContact>?
    var storedContacts: [Contact] = []
    var updatedContacts: [Contact] = []
    
    let contactStore = CNContactStore()
    
    func requestAuthorization() {
        contactStore.requestAccess(for: CNEntityType.contacts) { (access, error) in
            print(access)
        }
    }
    
    func checkAuthorizationStatus() -> Int {
        return CNContactStore.authorizationStatus(for: .contacts).rawValue
    }
    
    func fetchUpdatedContacts(from: FetchContactsStyle, sortedBy: CNContactSortOrder = .givenName) {
        let keysToFetch = [
            // Identification
            CNContactIdentifierKey,
            
            // Name
            CNContactGivenNameKey,
            CNContactMiddleNameKey,
            CNContactFamilyNameKey,
            CNContactNicknameKey,
//
//            // Work
            CNContactJobTitleKey,
            CNContactDepartmentNameKey,
            CNContactOrganizationNameKey,
//
//            // Address
//            CNContactPostalAddressesKey,
            CNContactEmailAddressesKey,
//            CNContactUrlAddressesKey,
//            CNContactInstantMessageAddressesKey,
//
//            // Phone
            CNContactPhoneNumbersKey,
//
//            // Social Profiles
//             CNContactSocialProfilesKey,
//
//            // Important Dates
//            CNContactBirthdayKey,
//            CNContactDatesKey,
//
//            // Notes
//            CNContactNoteKey,
//
//            // Image Data
//            CNContactImageDataAvailableKey,
            CNContactImageDataKey,
            CNContactThumbnailImageDataKey,
//
//            // Relationships
//            CNContactRelationsKey
        ] as [CNKeyDescriptor]

        // Fetch Contacts from Containers
        if from == .containers {
            // Get all the containers
            var allContainers: [CNContainer] = []
            do {
                allContainers = try contactStore.containers(matching: nil)
            } catch {
                print("Error fetching containers")
            }

            // Iterate all containers and append their contacts to our results array
            for container in allContainers {
                let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)

                do {
                    let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch)
                    for contact in containerResults {
                        updatedContacts.append(convertCNContactToContact(contact))
//                        storeFetchedContact(contact)
                    }
                
                    self.fetchStoredContacts()
                } catch {
                    print("Error fetching results for container")
                }
            }
        }
        
        // Fetch All Contacts
        else if from == .all {
            let fetchRequest = CNContactFetchRequest(keysToFetch: keysToFetch)
            fetchRequest.sortOrder = sortedBy

            do {
                try contactStore.enumerateContacts(with: fetchRequest, usingBlock: { (contact, stop) in
                    self.updatedContacts.append(self.convertCNContactToContact(contact))
//                    self.storeFetchedContact(contact)
                })
                
                self.fetchStoredContacts()
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchStoredContacts() {
//        print(Realm.Configuration.defaultConfiguration.fileURL!)
        let storedContactsFetched = realm.objects(DBContact.self).sorted(byKeyPath: "givenName", ascending: true)
        for contact in storedContactsFetched {
            storedContacts.append(convertDBContactToContact(contact))
        }
        if (contactsUpdated(updatedContacts: updatedContacts, storedContacts: storedContacts)) {
            print("Same")
        } else {
            print("Different")
        }
    }
    
    func contactsUpdated(updatedContacts: [Contact], storedContacts: [Contact]) -> Bool {
        return updatedContacts != storedContacts
    }
}

//MARK: - Utility Functions
extension ContactsModel {
    func convertCNContactToContact(_ contact: CNContact) -> Contact {
        return Contact(
            givenName: contact.givenName,
            middleName: contact.middleName,
            familyName: contact.familyName,
            nickname: contact.nickname,
            jobTitle: contact.jobTitle,
            department: contact.departmentName,
            organization: contact.organizationName
        )
    }
    
    func convertDBContactToContact(_ contact: DBContact) -> Contact {
        return Contact(
            givenName: contact.givenName,
            middleName: contact.middleName,
            familyName: contact.familyName,
            nickname: contact.nickname,
            jobTitle: contact.jobTitle,
            department: contact.department,
            organization: contact.organization
        )
    }
    
    func hashContact(_ contact: Contact) -> HashedContact? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        do {
            let data = try encoder.encode(HashableContact(contact))
            let hashedContactDigest = SHA256.hash(data: data)
            let hashedContact = hashedContactDigest.map { String(format: "%02hhx", $0) }.joined()
            return HashedContact(hashedContactId: hashedContact)
        } catch {
            print("Contact could not be converted to JSON. \(error)")
            return nil
        }
    }
    
    func storeFetchedContact(_ contact: CNContact) {
//        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        let contactHash = hashContact(convertCNContactToContact(contact))
        
        let contactForStorage = DBContact(
            givenName: contact.givenName,
            middleName: contact.middleName,
            familyName: contact.familyName,
            nickname: contact.nickname,
            jobTitle: contact.jobTitle,
            department: contact.departmentName ,
            organization: contact.organizationName,
            image: contact.imageData?.base64EncodedString(),
            thumbnailImage: contact.thumbnailImageData?.base64EncodedString()
        )
        
        let emailAddressList = List<DBContactEmail>()
        for email in contact.emailAddresses {
            if let emailLabel = email.label {
                emailAddressList.append(DBContactEmail(label: emailLabel, email: email.value as String))
            }
        }
        
        let phoneNumberList = List<DBContactPhoneNumber>()
        for phone in contact.phoneNumbers {
            if let phoneLabel = phone.label {
                phoneNumberList.append(DBContactPhoneNumber(label: phoneLabel, phone: phone.value.stringValue))
            }
        }
        
        contactForStorage.emailAddresses = emailAddressList
        contactForStorage.phoneNumbers = phoneNumberList
        
        try! realm.write {
            realm.add(contactForStorage)
        }
    }
}
