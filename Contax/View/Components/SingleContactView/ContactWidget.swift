//
//  ContactWidget.swift
//  Contax
//
//  Created by Arpit Bansal on 7/26/20.
//

import SwiftUI

struct ContactWidget: View {
    
    var actionIcon: String
    var actionText: String
    
    init(icon: String, text: String) {
        actionIcon = icon
        actionText = text
    }
    
    var body: some View {
        Button(action: {
            print("Button pressed")
        }) {
            VStack(alignment: .center) {
                Image(systemName: actionIcon)
                    .font(.system(size: 25.0))
                    .foregroundColor(.white)
                    .padding(.all, 20)
                    .background(
                        Circle()
                            .foregroundColor(Color.init("Lighter Gray"))
                    )
                
                Text(actionText)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .padding(.bottom, 10)
            }
        }
    }
}

struct ContactWidget_Previews: PreviewProvider {
    static var previews: some View {
        ContactWidget(icon: "phone.fill", text: "Call")
    }
}
