//
//  ContactWidgetGrid.swift
//  Dex
//
//  Created by Arpit Bansal on 7/26/20.
//

import SwiftUI

struct ContactWidgetGrid: View {
    var body: some View {
        VStack(spacing: 10) {
            HStack(spacing: 10) {
                ContactWidget(icon: "phone.fill", text: "Call", detail: "12am SST")
                ContactWidget(icon: "envelope.fill", text: "Email", detail: "hi@arpitbansal.com")
            }
            HStack(spacing: 10) {
                ContactWidget(icon: "number", text: "Organize", detail: "Dex, Babson Alums")
                ContactWidget(icon: "hand.raised.fill", text: "Introduce", detail: "")
            }
        }
    }
}

struct ContactWidgetGrid_Previews: PreviewProvider {
    static var previews: some View {
        ContactWidgetGrid()
    }
}
