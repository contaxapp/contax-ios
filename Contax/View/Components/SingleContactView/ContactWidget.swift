//
//  ContactWidget.swift
//  Contax
//
//  Created by Arpit Bansal on 7/26/20.
//

import SwiftUI

struct ContactWidget: View {
    
    let actionIcon: String
    let actionText: String
    let disabled: Bool
    let actionFn: () -> Void
    
    @State var showAlert = false
    
    var body: some View {
        Button(action: {
            if (disabled) {
                print("Functionality disabled")
            }
            
            actionFn()
        }) {
            VStack(alignment: .center) {
                HStack (alignment: .center) {
                    Image(systemName: actionIcon)
                        .font(.system(size: 25.0))
                        .foregroundColor(Color.init("Accent Green"))
                }
                .frame(maxWidth: 60, maxHeight: 60)
                .aspectRatio(contentMode: .fit)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.init("Light Gray"), lineWidth: 1)
                )
                .padding(.bottom, 5)
                
                Text(actionText)
                    .font(.custom("EuclidCircularA-Light", size: 12))
                    .foregroundColor(Color.init("Dark Gray"))
            }
            .if(disabled) { view in
                view.opacity(0.2)
            }
        }
        .disabled(disabled)
    }
}
