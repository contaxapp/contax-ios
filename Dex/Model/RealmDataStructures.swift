//
//  RealmDataStructures.swift
//  Dex
//
//  Created by Arpit Bansal on 9/13/20.
//

import Foundation
import RealmSwift

class DBContact: Object, Identifiable {
//    @objc dynamic var id: String = ""
    @objc dynamic var givenName: String = ""
    @objc dynamic var middleName: String = ""
    @objc dynamic var familyName: String = ""
    @objc dynamic var nickname: String = ""
    @objc dynamic var jobTitle: String = ""
    @objc dynamic var department: String = ""
    @objc dynamic var organization: String = ""
    @objc dynamic var image: String? = nil
    @objc dynamic var thumbnailImage: String? = nil
    
    var emailAddresses = List<DBContactEmail>()
    var phoneNumbers = List<DBContactPhoneNumber>()
    
    convenience init(givenName: String, middleName: String, familyName: String, nickname: String, jobTitle: String, department: String, organization: String, image: String?, thumbnailImage: String?) {
        self.init()
        self.givenName = givenName
        self.middleName = middleName
        self.familyName = familyName
        self.nickname = nickname
        self.jobTitle = jobTitle
        self.department = department
        self.organization = organization
        self.image = image
        self.thumbnailImage = thumbnailImage
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

