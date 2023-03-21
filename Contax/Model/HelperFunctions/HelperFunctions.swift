//
//  SingleContactView.swift
//  Contax
//
//  Created by Arpit Bansal on 20/02/22.
//

import Foundation
import UIKit
import SwiftUI
import MessageUI

struct EdgeBorder: Shape {
    var width: CGFloat
    var edges: [Edge]

    func path(in rect: CGRect) -> Path {
        var path = Path()
        for edge in edges {
            var x: CGFloat {
                switch edge {
                case .top, .bottom, .leading: return rect.minX
                case .trailing: return rect.maxX - width
                }
            }

            var y: CGFloat {
                switch edge {
                case .top, .leading, .trailing: return rect.minY
                case .bottom: return rect.maxY - width
                }
            }

            var w: CGFloat {
                switch edge {
                case .top, .bottom: return rect.width
                case .leading, .trailing: return width
                }
            }

            var h: CGFloat {
                switch edge {
                case .top, .bottom: return width
                case .leading, .trailing: return rect.height
                }
            }
            path.addRect(CGRect(x: x, y: y, width: w, height: h))
        }
        return path
    }
}

extension View {
    func border(width: CGFloat, edges: [Edge], color: Color) -> some View {
        overlay(EdgeBorder(width: width, edges: edges).foregroundColor(color))
    }
}

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
    
    static func returnGroupInitials(_ name: String) -> String {
        var initials = ""
        
        if (name.count > 0) {
            let nameInitialIndex = name.startIndex
            let nameInitial = String(name[nameInitialIndex])
            initials += nameInitial
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
