//
//  RealmDataStructures.swift
//  Contax
//
//  Created by Arpit Bansal on 9/13/20.
//

import Foundation
import RealmSwift

class DBContact: Object, Identifiable {
    @Persisted var hashId: String = ""
    @Persisted var identifier: String = ""
    @Persisted var givenName: String = ""
    @Persisted var middleName: String = ""
    @Persisted var familyName: String = ""
    @Persisted var nickname: String = ""
    @Persisted var jobTitle: String = ""
    @Persisted var department: String = ""
    @Persisted var organization: String = ""
    @Persisted var image: String? = nil
    @Persisted var thumbnailImage: String? = nil
    @Persisted var note: String = ""
    
    @Persisted var emailAddresses: List<DBContactEmail>
    @Persisted var phoneNumbers: List<DBContactPhoneNumber>
    @Persisted var postalAddresses: List<DBContactAddress>
    
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
    @Persisted var label: String = ""
    @Persisted var email: String = ""
    
    @Persisted(originProperty: "emailAddresses") var parentContact: LinkingObjects<DBContact>
    
    convenience init(label: String, email: String) {
        self.init()
        self.label = label
        self.email = email
    }
}

class DBContactPhoneNumber: Object {
    @Persisted var label: String = ""
    @Persisted var phone: String = ""

    @Persisted(originProperty: "phoneNumbers") var parentContact: LinkingObjects<DBContact>
    
    convenience init(label: String, phone: String) {
        self.init()
        self.label = label
        self.phone = phone
    }
}

class DBContactAddress: Object {
    @Persisted var label: String = ""
    @Persisted var street: String = ""
    @Persisted var city: String = ""
    @Persisted var state: String = ""
    @Persisted var postalCode: String = ""
    @Persisted var country: String = ""
    @Persisted var countryCode: String = ""
    
    @Persisted(originProperty: "postalAddresses") var parentContact: LinkingObjects<DBContact>
    
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

class DBUser: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var firstName: String
    @Persisted var lastName: String
    @Persisted var email: String?
    
    convenience init(id: String, firstName: String, lastName: String, email: String?) {
        self.init()
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
    }
}
