//
//  ContactWidgetGrid.swift
//  Contax
//
//  Created by Arpit Bansal on 7/26/20.
//

import SwiftUI

struct ContactWidgetGrid: View {
    var body: some View {
        HStack(alignment: .center) {
            ContactWidget(icon: "phone.fill", text: "Call")
                .frame(maxWidth: .infinity)
            
            ContactWidget(icon: "envelope.fill", text: "Email")
                .frame(maxWidth: .infinity)
            
            ContactWidget(icon: "number", text: "Organize")
                .frame(maxWidth: .infinity)
            
            ContactWidget(icon: "hand.raised.fill", text: "Introduce")
                .frame(maxWidth: .infinity)
        }
    }
}

struct ContactWidgetGrid_Previews: PreviewProvider {
    static var previews: some View {
        ContactWidgetGrid()
    }
}
