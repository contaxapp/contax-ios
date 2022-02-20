//
//  SingleContactView.swift
//  Contax
//
//  Created by Arpit Bansal on 20/02/22.
//

import Foundation
import UIKit
import MessageUI

struct HelperFunctions {
    static func makeCall(_ contact: Contact) {
        let phone = "tel://\(contact.phoneNumbers[0].phone)"
        guard let url = URL(string: phone) else { return }
        UIApplication.shared.open(url)
    }
    
    static func returnInitials(_ contact: Contact) -> String {
        let givenName = contact.givenName
        let familyName = contact.familyName
        
        var initials = ""
        
        if (givenName.count > 0) {
            let givenNameInitialIndex = givenName.startIndex
            let givenNameInitial = String(givenName[givenNameInitialIndex])
            initials += givenNameInitial
        }
        
        if (familyName.count > 0) {
            let familyNameInitialIndex = familyName.startIndex
            let familyNameInitial = String(familyName[familyNameInitialIndex])
            initials += familyNameInitial
        }
        
        return initials
    }
}
