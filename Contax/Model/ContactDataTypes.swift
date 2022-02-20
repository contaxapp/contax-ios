//
//  Contact.swift
//  Contax
//
//  Created by Arpit Bansal on 7/18/20.
//

import Foundation
import Contacts

struct Contact: Identifiable {
    
    var id: String
    var givenName: String
    var middleName: String
    var familyName: String
    var nickname: String
    var jobTitle: String
    var department: String
    var organization: String
    var emailAddresses: [ContactEmail] = []
    var phoneNumbers: [ContactPhoneNumber] = []
    var image: String?
    var thumbnailImage: String?
    var postalAddresses: [ContactAddress] = []
    
    init(id: String, givenName: String, middleName: String, familyName: String, nickname: String, jobTitle: String, department: String, organization: String, image: String?, thumbnailImage: String?, emailAddresses: [ContactEmail], phoneNumbers: [ContactPhoneNumber], postalAddresses: [ContactAddress]) {
        self.id = id
        self.givenName = givenName
        self.middleName = middleName
        self.familyName = familyName
        self.nickname = nickname
        self.jobTitle = jobTitle
        self.department = department
        self.organization = organization
        self.image = image
        self.thumbnailImage = thumbnailImage
        self.emailAddresses = emailAddresses
        self.phoneNumbers = phoneNumbers
        self.postalAddresses = postalAddresses
    }
}

struct ContactAddress: Encodable {
    var label: String
    var street: String
    var city: String
    var state: String
    var postalCode: String
    var country: String
    var countryCode: String
}

struct ContactEmail: Encodable {
    var label: String
    var email: String
}

struct ContactPhoneNumber: Encodable {
    var label: String
    var phone: String
}

struct HashableContact: Encodable {
    
    var givenName: String
    var middleName: String
    var familyName: String
    var nickname: String
    var jobTitle: String
    var department: String
    var organization: String
    var emailAddresses: [ContactEmail] = []
    var phoneNumbers: [ContactPhoneNumber] = []
    var image: String?
    var thumbnailImage: String?
    var postalAddresses: [ContactAddress] = []
    
    init(_ contact: Contact) {
        self.givenName = contact.givenName
        self.middleName = contact.middleName
        self.familyName = contact.familyName
        self.nickname = contact.nickname
        self.jobTitle = contact.jobTitle
        self.department = contact.department
        self.organization = contact.organization
        self.emailAddresses = contact.emailAddresses
        self.phoneNumbers = contact.phoneNumbers
        self.image = contact.image
        self.thumbnailImage = contact.thumbnailImage
        self.postalAddresses = contact.postalAddresses
    }
}

struct HashedContact {
    var hashedContactId: String
}

// Others

enum FetchContactsStyle {
    case all
    case containers
}

struct ContactGroup: Identifiable {
    var id: Character
    var contacts: [Contact]
}

struct AddressBookContacts {
    var hashes: [String]
    var contacts: [Contact]
}

struct UpdatedContacts {
    var newContacts: [Contact]
    var updatedContacts: [Contact]
}
