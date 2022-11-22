//
//  RealmDataStructures.swift
//  Contax
//
//  Created by Arpit Bansal on 9/13/20.
//

import Foundation
import RealmSwift

class DBContact: Object, Identifiable {
    @objc dynamic var hashId: String = ""
    @objc dynamic var identifier: String = ""
    @objc dynamic var givenName: String = ""
    @objc dynamic var middleName: String = ""
    @objc dynamic var familyName: String = ""
    @objc dynamic var nickname: String = ""
    @objc dynamic var jobTitle: String = ""
    @objc dynamic var department: String = ""
    @objc dynamic var organization: String = ""
    @objc dynamic var image: String? = nil
    @objc dynamic var thumbnailImage: String? = nil
    @objc dynamic var note: String = ""
    
    var emailAddresses = List<DBContactEmail>()
    var phoneNumbers = List<DBContactPhoneNumber>()
    var postalAddresses = List<DBContactAddress>()
    
    convenience init(hashId: String, identifier: String, givenName: String, middleName: String, familyName: String, nickname: String, jobTitle: String, department: String, organization: String, image: String?, thumbnailImage: String?, note: String) {
        self.init()
        self.hashId = hashId
        self.identifier = identifier
        self.givenName = givenName
        self.middleName = middleName
        self.familyName = familyName
        self.nickname = nickname
        self.jobTitle = jobTitle
        self.department = department
        self.organization = organization
        self.image = image
        self.thumbnailImage = thumbnailImage
        self.note = note
    }
}

class DBContactEmail: Object {
    @objc dynamic var label: String = ""
    @objc dynamic var email: String = ""

    var parentContact = LinkingObjects(fromType: DBContact.self, property: "emailAddresses")
    
    convenience init(label: String, email: String) {
        self.init()
        self.label = label
        self.email = email
    }
}

class DBContactPhoneNumber: Object {
    @objc dynamic var label: String = ""
    @objc dynamic var phone: String = ""

    var parentContact = LinkingObjects(fromType: DBContact.self, property: "phoneNumbers")
    
    convenience init(label: String, phone: String) {
        self.init()
        self.label = label
        self.phone = phone
    }
}

class DBContactAddress: Object {
    @objc dynamic var label: String = ""
    @objc dynamic var street: String = ""
    @objc dynamic var city: String = ""
    @objc dynamic var state: String = ""
    @objc dynamic var postalCode: String = ""
    @objc dynamic var country: String = ""
    @objc dynamic var countryCode: String = ""
    
    var parentContact = LinkingObjects(fromType: DBContact.self, property: "postalAddresses")
    
    convenience init(label: String, street: String, city: String, state: String, postalCode: String, country: String, countryCode: String) {
        self.init()
        self.label = label
        self.street = street
        self.city = city
        self.state = state
        self.postalCode = postalCode
        self.country = country
        self.countryCode = countryCode
    }
}
