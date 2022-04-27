//
//  ContactWidgetGrid.swift
//  Contax
//
//  Created by Arpit Bansal on 7/26/20.
//

import SwiftUI

struct ContactWidgetGrid: View {
    
    let contact: Contact?
    
    var body: some View {
        HStack(alignment: .center) {
            ContactWidget(actionIcon: "phone.fill", actionText: "Call", actionFn: {
                if contact != nil { HelperFunctions.makeCall(contact!) }
            }).frame(maxWidth: .infinity)
            
            ContactWidget(actionIcon: "message.fill", actionText: "Text", actionFn: {
                print("Texting")
            }).frame(maxWidth: .infinity)
            
            ContactWidget(actionIcon: "envelope.fill", actionText: "Email", actionFn: {
                print("Emailing")
            }).frame(maxWidth: .infinity)
            
            ContactWidget(actionIcon: "hand.raised.fill", actionText: "Introduce", actionFn: {
                print("Introducing")
            }).frame(maxWidth: .infinity)
        }
    }
}
