//
//  Contact.swift
//  Contax
//
//  Created by Arpit Bansal on 7/18/20.
//

import Foundation
import Contacts

enum FetchContactsStyle {
    case all
    case containers
}

struct Contact: Identifiable, Encodable, Equatable {
    static func == (lhs: Contact, rhs: Contact) -> Bool {
        <#code#>
    }
    
    var id: String?
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
//    var postalAddresses = [ContactAddress]()
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
    }
}

struct HashedContact {
    var hashedContactId: String
}

struct ContactGroup: Identifiable {
    var id: Character
    var contacts: [Contact]
}
