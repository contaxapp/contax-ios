//
//  ContactModel.swift
//  Dex
//
//  Created by Arpit Bansal on 7/18/20.
//

import Foundation
import UIKit
import Contacts
import CryptoKit

class ContactsModel: ObservableObject {
    
    @Published var contacts: [Contact] = []
    
    private var internalContactList: [Contact] = []
    
    let contactStore = CNContactStore()
    
    func requestAuthorization() {
        contactStore.requestAccess(for: CNEntityType.contacts) { (access, error) in
            print(access)
        }
    }
    
    func checkAuthorizationStatus() -> Int {
        return CNContactStore.authorizationStatus(for: .contacts).rawValue
    }
    
    func fetchContacts(from: FetchContactsStyle, sortedBy: CNContactSortOrder = .givenName) {
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
//            CNContactPostalAddressesKey,
            CNContactEmailAddressesKey,
//            CNContactUrlAddressesKey,
//            CNContactInstantMessageAddressesKey,
            
            // Phone
            CNContactPhoneNumbersKey,
            
            // Social Profiles
            // CNContactSocialProfilesKey,
            
            // Important Dates
//            CNContactBirthdayKey,
//            CNContactDatesKey,
            
            // Notes
//            CNContactNoteKey,
            
            // Image Data
            CNContactImageDataAvailableKey,
            CNContactImageDataKey,
            CNContactThumbnailImageDataKey,
            
            // Relationships
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
                        storeFetchedContact(contact)
                    }
                } catch {
                    print("Error fetching results for container")
                }
            }
            
            contacts = internalContactList
        }
        
        // Fetch All Contacts
        else if from == .all {
            let fetchRequest = CNContactFetchRequest(keysToFetch: keysToFetch)
            fetchRequest.sortOrder = sortedBy
            
            do {
                try contactStore.enumerateContacts(with: fetchRequest, usingBlock: { (contact, stop) in
                    self.storeFetchedContact(contact)
                })
                
                contacts = internalContactList
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
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
}

//MARK: - Utility Functions
extension ContactsModel {
    func storeFetchedContact(_ contact: CNContact) {
        var emailAddressList: [ContactEmail] = []
        for email in contact.emailAddresses {
            if let emailLabel = email.label {
                emailAddressList.append(ContactEmail(label: emailLabel, email: email.value as String))
            }
        }
        
        var phoneNumberList: [ContactPhoneNumber] = []
        for phone in contact.phoneNumbers {
            if let phoneLabel = phone.label {
                phoneNumberList.append(ContactPhoneNumber(label: phoneLabel, phone: phone.value.stringValue))
            }
        }
        
        let contactToBeAppended = Contact(
            id: contact.identifier,
            givenName: contact.givenName,
            middleName: contact.middleName,
            familyName: contact.familyName,
            nickname: contact.nickname,
            jobTitle: contact.jobTitle,
            department: contact.departmentName ,
            organization: contact.organizationName,
            emailAddresses: emailAddressList,
            phoneNumbers: phoneNumberList,
            image: contact.imageData?.base64EncodedString(),
            thumbnailImage: contact.thumbnailImageData?.base64EncodedString()
        )
        
        self.internalContactList.append(contactToBeAppended)
    }
}
