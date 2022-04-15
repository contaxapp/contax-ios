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
    
    var addressBookContacts: AddressBookContacts = AddressBookContacts(hashes: [], contacts: [])
    var storedContacts: StoredContacts = StoredContacts(hashes: [], contacts: [])
    
    let contactStore = CNContactStore()
    
    func requestAuthorization() async -> Bool {
        var auth: Bool = false
        do {
            auth = try await contactStore.requestAccess(for: CNEntityType.contacts)
        } catch {
            print("Error")
        }
        return auth
    }
    
    func checkAuthorizationStatus() -> Int {
        return CNContactStore.authorizationStatus(for: .contacts).rawValue
    }
    
    func fetchContactsFromAddressBook(from: FetchContactsStyle, sortedBy: CNContactSortOrder = .givenName) -> AddressBookContacts {
        
        var addressBookContacts: AddressBookContacts = AddressBookContacts(hashes: [], contacts: [])
        
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
                        addressBookContacts.hashes.append(hashedContact!.hashedContactId)
                        addressBookContacts.contacts.append(convertCNContactToContact(contact))
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
                    addressBookContacts.hashes.append(hashedContact!.hashedContactId)
                    addressBookContacts.contacts.append(self.convertCNContactToContact(contact))
                })
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        
        return addressBookContacts
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
    
    func checkForUpdatedContacts() -> UpdatedContacts {
        var updatedContactsFetched: UpdatedContacts = UpdatedContacts(newContacts: [], updatedContacts: [])
        
        // Fetch stored contact hashes
        addressBookContacts = fetchContactsFromAddressBook(from: .all)
        storedContacts = fetchStoredContacts()
        
        for (index, contactHash) in addressBookContacts.hashes.enumerated() {
            let addressBookContact = addressBookContacts.contacts[index]
            
            if (!storedContacts.hashes.contains(contactHash)) {
                if (!storedContacts.contacts.contains(where: { storedContact in return storedContact.id == addressBookContact.id })) {
//                    print("New Contact Added in Address Book")
                    updatedContactsFetched.newContacts.append(addressBookContact)
                } else {
//                    print("Existing Contact Updated in Address Book", addressBookContacts.contacts[index].id, addressBookContact.givenName)
                    updatedContactsFetched.updatedContacts.append(addressBookContact)
                }
            }
        }
        
        return updatedContactsFetched
    }
    
    func fetchContactsForDisplay() {
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        let updatedContacts = checkForUpdatedContacts()
        
        if (updatedContacts.newContacts.count > 0) {
            for contact in updatedContacts.newContacts {
                storeContact(contact)
            }
            
            contacts = addressBookContacts.contacts
            print("Showing new contacts\n------------")
        } else if (updatedContacts.updatedContacts.count > 0) {
            // Add handling of updated Contacts
            
            for (_, contact) in updatedContacts.updatedContacts.enumerated() {
                let contactToUpdate = storedContacts.contacts.first(where: {$0.id == contact.id})
                print(contactToUpdate!.familyName)
            }
            
            contacts = storedContacts.contacts
            print("Showing updated contacts\n------------")
        } else {
            contacts = storedContacts.contacts
            print("Showing stored contacts\n------------")
        }
    }
}

//MARK: - Utility Functions
extension ContactsModel {
    
    func convertCNContactToContact(_ contact: CNContact) -> Contact {
        
        var emailAddresses: [ContactEmail] = []
        for email in contact.emailAddresses {
            emailAddresses.append(ContactEmail(label: email.label ?? "Work", email: email.value as String))
        }
        
        var phoneNumbers: [ContactPhoneNumber] = []
        for phoneNumber in contact.phoneNumbers {
            phoneNumbers.append(ContactPhoneNumber(label: phoneNumber.label ?? "Mobile", phone: phoneNumber.value.stringValue))
        }
        
        var postalAddresses: [ContactAddress] = []
        for postalAddress in contact.postalAddresses {
            postalAddresses.append(ContactAddress(label: postalAddress.label ?? "Home", street: postalAddress.value.street, city: postalAddress.value.city, state: postalAddress.value.state, postalCode: postalAddress.value.postalCode, country: postalAddress.value.country, countryCode: postalAddress.value.isoCountryCode))
        }
        
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
            thumbnailImage: contact.thumbnailImageData?.base64EncodedString(),
            emailAddresses: emailAddresses,
            phoneNumbers: phoneNumbers,
            postalAddresses: postalAddresses
        )
    }
    
    func convertDBContactToContact(_ contact: DBContact) -> Contact {
        var emailAddresses: [ContactEmail] = []
        for email in contact.emailAddresses {
            emailAddresses.append(ContactEmail(label: email.label, email: email.email))
        }
        
        var phoneNumbers: [ContactPhoneNumber] = []
        for phoneNumber in contact.phoneNumbers {
            phoneNumbers.append(ContactPhoneNumber(label: phoneNumber.label, phone: phoneNumber.phone))
        }
        
        var postalAddresses: [ContactAddress] = []
        for postalAddress in contact.postalAddresses {
            postalAddresses.append(ContactAddress(label: postalAddress.label, street: postalAddress.street, city: postalAddress.city, state: postalAddress.state, postalCode: postalAddress.postalCode, country: postalAddress.country, countryCode: postalAddress.countryCode))
        }
        
        return Contact(
            id: contact.identifier,
            givenName: contact.givenName,
            middleName: contact.middleName,
            familyName: contact.familyName,
            nickname: contact.nickname,
            jobTitle: contact.jobTitle,
            department: contact.department,
            organization: contact.organization,
            image: contact.image,
            thumbnailImage: contact.thumbnailImage,
            emailAddresses: emailAddresses,
            phoneNumbers: phoneNumbers,
            postalAddresses: postalAddresses
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
            identifier: contact.id,
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
    
    func updateContact(_ contact: Contact) {
        
    }
}
