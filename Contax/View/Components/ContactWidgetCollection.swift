//
//  ContactWidgetCollection.swift
//  Dex
//
//  Created by Arpit Bansal on 7/26/20.
//

import SwiftUI

struct ContactWidgetCollection: View {
    var metrics: Any
    
    init(_ metrics: Any) {
        metrics = metrics
    }
    
    var body: some View {
        VStack {
            HStack {
                ContactWidget(icon: "phone.fill", text: "Call", detail: "12am SST")
                ContactWidget(icon: "envelope.fill", text: "Email", detail: "hi@arpitbansal.com")
            }
            HStack {
                ContactWidget(icon: "number", text: "Organize", detail: "Dex, Babson Alums")
                ContactWidget(icon: "hand.raised.fill", text: "Introduce", detail: "")
            }
        }
        .foregroundColor(.white)
        .frame(minWidth: 0, idealWidth: metrics.size.width, maxWidth: .infinity, minHeight: metrics.size.height * 0.65, maxHeight: .infinity, alignment: .center)
    }
}

struct ContactWidgetCollection_Previews: PreviewProvider {
    static var previews: some View {
        ContactWidgetCollection()
    }
}
