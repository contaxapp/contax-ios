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
    
    @Published var contacts: [Contact] = []
    
    var updatedContacts: UpdatedContacts = UpdatedContacts(hashes: [], contacts: [])
    var storedContacts: StoredContacts = StoredContacts(hashes: [], contacts: [])
    
    let contactStore = CNContactStore()
    
    func requestAuthorization() {
        contactStore.requestAccess(for: CNEntityType.contacts) { (access, error) in
            print(access)
        }
    }
    
    func checkAuthorizationStatus() -> Int {
        return CNContactStore.authorizationStatus(for: .contacts).rawValue
    }
    
    func fetchContactsFromContactBook(from: FetchContactsStyle, sortedBy: CNContactSortOrder = .givenName) -> UpdatedContacts {
        
        var updatedContacts: UpdatedContacts = UpdatedContacts(hashes: [], contacts: [])
        
        let keysToFetch = [
            // Identification
            CNContactIdentifierKey,
            
            // Name
            CNContactGivenNameKey,
            CNContactMiddleNameKey,
            CNContactFamilyNameKey,
            CNContactNicknameKey,

            // Work
            CNContactJobTitleKey,
            CNContactDepartmentNameKey,
            CNContactOrganizationNameKey,

            // Address
            CNContactPostalAddressesKey,
            CNContactEmailAddressesKey,
            CNContactUrlAddressesKey,
            CNContactInstantMessageAddressesKey,

            // Phone
            CNContactPhoneNumbersKey,

            // Social Profiles
             CNContactSocialProfilesKey,

            // Important Dates
            CNContactBirthdayKey,
            CNContactDatesKey,

            // Notes
//            CNContactNoteKey,

            // Image Data
            CNContactImageDataAvailableKey,
            CNContactImageDataKey,
            CNContactThumbnailImageDataKey,

            // Relationships
            CNContactRelationsKey
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
                        let hashedContact = hashContact(convertCNContactToContact(contact))
                        updatedContacts.hashes.append(hashedContact!.hashedContactId)
                        updatedContacts.contacts.append(convertCNContactToContact(contact))
                    }
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
                    let hashedContact = self.hashContact(self.convertCNContactToContact(contact))
                    updatedContacts.hashes.append(hashedContact!.hashedContactId)
                    updatedContacts.contacts.append(self.convertCNContactToContact(contact))
                })
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        
        return updatedContacts
    }
    
    func fetchStoredContacts() -> StoredContacts {
        let storedContactsFetched = realm.objects(DBContact.self).sorted(byKeyPath: "givenName", ascending: true)
        var storedContacts: StoredContacts = StoredContacts(hashes: [], contacts: [])
        for contact in storedContactsFetched {
            storedContacts.hashes.append(contact.hashId)
            storedContacts.contacts.append(convertDBContactToContact(contact))
        }
        return storedContacts
    }
    
    func checkForUpdatedContacts() -> Bool {
        // Fetch stored contact hashes
        updatedContacts = fetchContactsFromContactBook(from: .all)
        storedContacts = fetchStoredContacts()
        
        return updatedContacts.hashes != storedContacts.hashes
    }
    
    func fetchContactsForDisplay(firstTime: Bool) {
        let contactsUpdated = checkForUpdatedContacts()
        if contactsUpdated {
            for contact in updatedContacts.contacts {
                storeContact(contact)
            }
            contacts = updatedContacts.contacts
        } else {
            contacts = storedContacts.contacts
        }
    }
}

//MARK: - Utility Functions
extension ContactsModel {
    func convertCNContactToContact(_ contact: CNContact) -> Contact {
        return Contact(
            id: contact.identifier,
            givenName: contact.givenName,
            middleName: contact.middleName,
            familyName: contact.familyName,
            nickname: contact.nickname,
            jobTitle: contact.jobTitle,
            department: contact.departmentName,
            organization: contact.organizationName,
            image: contact.imageData?.base64EncodedString(),
            thumbnailImage: contact.thumbnailImageData?.base64EncodedString()
        )
    }
    
    func convertDBContactToContact(_ contact: DBContact) -> Contact {
        return Contact(
            id: contact.hashId,
            givenName: contact.givenName,
            middleName: contact.middleName,
            familyName: contact.familyName,
            nickname: contact.nickname,
            jobTitle: contact.jobTitle,
            department: contact.department,
            organization: contact.organization,
            image: contact.image,
            thumbnailImage: contact.thumbnailImage
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
    
    func storeContact(_ contact: Contact) {
//        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        let contactHash = hashContact(contact)
        
        let contactForStorage = DBContact(
            hashId: contactHash!.hashedContactId,
            givenName: contact.givenName,
            middleName: contact.middleName,
            familyName: contact.familyName,
            nickname: contact.nickname,
            jobTitle: contact.jobTitle,
            department: contact.department,
            organization: contact.organization,
            image: contact.image,
            thumbnailImage: contact.thumbnailImage
        )
        
        let emailAddressList = List<DBContactEmail>()
        for email in contact.emailAddresses {
            emailAddressList.append(DBContactEmail(label: email.label, email: email.email as String))
        }
        
        let phoneNumberList = List<DBContactPhoneNumber>()
        for phone in contact.phoneNumbers {
            phoneNumberList.append(DBContactPhoneNumber(label: phone.label, phone: phone.phone))
        }
        
        let postalAddressList = List<DBContactAddress>()
        for address in contact.postalAddresses {
            postalAddressList.append(DBContactAddress(label: address.label, street: address.street, city: address.city, state: address.state, postalCode: address.postalCode, country: address.country, countryCode: address.countryCode))
        }
        
        contactForStorage.emailAddresses = emailAddressList
        contactForStorage.phoneNumbers = phoneNumberList
        contactForStorage.postalAddresses = postalAddressList
        
        try! realm.write {
            realm.add(contactForStorage)
        }
    }
}
