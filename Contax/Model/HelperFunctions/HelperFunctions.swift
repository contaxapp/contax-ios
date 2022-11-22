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
        #if !DEBUG
        if contact.phoneNumbers.count > 0 {
            let phone = "tel://\(contact.phoneNumbers[0].phone)"
            guard let url = URL(string: phone) else { return }
            UIApplication.shared.open(url)
        }
        #endif
        
        #if DEBUG
        print("Calling . . .")
        #endif
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
    
    static func composeText(_ contact: Contact) {
        #if !DEBUG
        
        if !MFMessageComposeViewController.canSendText() {
            print("SMS services are not available")
            return;
        }
        
        #endif
        
        var selectedPhoneNumber: String = ""
        
        if (contact.phoneNumbers.count > 1) {
            
        } else {
            
        }
        
        selectedPhoneNumber = selectedPhoneNumber.replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "-", with: "")
        
        let message = "sms://\(selectedPhoneNumber)"
        guard let url = URL(string: message) else { return }
        UIApplication.shared.open(url)
    }
    
    static func composeEmail(_ contact: Contact) {
        #if !DEBUG
        
        if !MFMessageComposeViewController.canSendText() {
            print("SMS services are not available")
            return;
        }
        
        #endif
        
        if contact.phoneNumbers.count > 0 {
            let message = "sms://\(contact.phoneNumbers[0].phone)"
            guard let url = URL(string: message) else { return }
            debugPrint(contact.phoneNumbers[0].phone)
            UIApplication.shared.open(url)
        }
    }
}
