//
//  Contact.swift
//  Contax
//
//  Created by Arpit Bansal on 7/18/20.
//

import Foundation
import Contacts

struct Contact: Identifiable, Equatable {
    
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
    var note: String
    
    static func == (lhs: Contact, rhs: Contact) -> Bool {
    
        if (lhs.id != rhs.id) { return false; }
        if (lhs.givenName != rhs.givenName) { return false; }
        if (lhs.middleName != rhs.middleName) { return false; }
        if (lhs.familyName != rhs.familyName) { return false; }
        if (lhs.nickname != rhs.nickname) { return false; }
        if (lhs.jobTitle != rhs.jobTitle) { return false; }
        if (lhs.department != rhs.department) { return false; }
        if (lhs.organization != rhs.organization) { return false; }
        if (lhs.image != rhs.image) { return false; }
        if (lhs.thumbnailImage != rhs.thumbnailImage) { return false; }
        if (lhs.note != rhs.note) { return false; }
        
        return true;
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
    var note: String
    
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
        self.note = contact.note
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
    var id: String
    var name: String
    var contacts: [Contact]
}

struct AddressBookContacts {
    var hashes: [String]
    var contacts: [Contact]
}

struct StoredContacts {
    var hashes: [String]
    var contacts: [Contact]
}

struct UpdatedContacts {
    var newContacts: [Contact]
    var updatedContacts: [Contact]
}
