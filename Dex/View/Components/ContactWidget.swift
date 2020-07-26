//
//  ContactWidget.swift
//  Dex
//
//  Created by Arpit Bansal on 7/26/20.
//

import SwiftUI

struct ContactWidget: View {
    
    var actionIcon: String
    var actionText: String
    var actionDetailText: String
    
    init(icon: String, text: String, detail: String) {
        actionIcon = icon
        actionText = text
        actionDetailText = detail
    }
    
    var body: some View {
        Button(action: {
            print("Button pressed")
        }) {
            VStack(alignment: .leading) {
                Image(systemName: actionIcon)
                    .font(.system(size: 35.0))
                    .foregroundColor(.white)
    //                .rotation3DEffect(.degrees(-90), axis: (x: 0, y: 0, z: 1))
                    .padding(.bottom, 20)
                Text(actionText)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.bottom, 10)
                /*
                HStack {
                    Text(actionDetailText)
                        .font(.caption)
                        .fontWeight(.regular)
                        .foregroundColor(Color.init(red: 255, green: 255, blue: 255, opacity: 0.5))
                    Image(systemName: "moon.fill")
                        .foregroundColor(.yellow)
                }
                */
                Text(actionDetailText)
                    .foregroundColor(Color.init(red: 255, green: 255, blue: 255, opacity: 0.5))
                    .font(.caption)
                    .fontWeight(.regular)
            }
            .frame(minWidth: 120, idealWidth: 120, maxWidth: 120, minHeight: 120, idealHeight: 120, maxHeight: 120, alignment: .leading)
            .padding(.all, 20)
            .background(Color.init("Lighter Gray"))
            .cornerRadius(20)
        }
    }
}

struct ContactWidget_Previews: PreviewProvider {
    static var previews: some View {
        ContactWidget(icon: "phone.fill", text: "Call", detail: "12am SST")
    }
}
