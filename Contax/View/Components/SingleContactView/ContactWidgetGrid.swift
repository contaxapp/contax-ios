//
//  ContactWidgetGrid.swift
//  Contax
//
//  Created by Arpit Bansal on 7/26/20.
//

import SwiftUI

struct ContactWidgetGrid: View {
    
    private var contact: Contact?
    
    init(_ contactSelected: Contact?) {
        contact = contactSelected
    }
    
    var body: some View {
        HStack(alignment: .center) {
            ContactWidget(icon: "phone.fill", text: "Call", buttonFn: {
                if contact != nil { HelperFunctions.makeCall(contact!) }
            }).frame(maxWidth: .infinity)
            
            ContactWidget(icon: "message.fill", text: "Text", buttonFn: {
                print("Texting")
            }).frame(maxWidth: .infinity)
            
            ContactWidget(icon: "envelope.fill", text: "Email", buttonFn: {
                print("Emailing")
            }).frame(maxWidth: .infinity)
            
            ContactWidget(icon: "hand.raised.fill", text: "Introduce", buttonFn: {
                print("Introducing")
            }).frame(maxWidth: .infinity)
        }
    }
}
