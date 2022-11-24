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
        VStack {
            Divider()
            
            HStack (alignment: .center) {
                ContactWidget(actionIcon: "message.fill", actionText: "Message", disabled: contact?.phoneNumbers.count == 0, actionFn: {
                    if contact != nil { HelperFunctions.composeText(contact!) }
                }).frame(maxWidth: .infinity)
                
                ContactWidget(actionIcon: "phone.fill", actionText: "Call", disabled: contact?.phoneNumbers.count == 0, actionFn: {
                    if contact != nil { HelperFunctions.makeCall(contact!) }
                }).frame(maxWidth: .infinity)
                
                ContactWidget(actionIcon: "envelope.fill", actionText: "WhatsApp", disabled: contact?.emailAddresses.count == 0, actionFn: {
                    print("Whatsapping")
                }).frame(maxWidth: .infinity)
                
                ContactWidget(actionIcon: "video.fill", actionText: "Facetime", disabled: true, actionFn: {
                    print("Facetiming")
                }).frame(maxWidth: .infinity)
            }
            .padding(.top, 10)
            .padding(.bottom, 5)
            
            Divider()
        }
        .padding(.vertical, 20)
        .padding(.horizontal)
    }
}
