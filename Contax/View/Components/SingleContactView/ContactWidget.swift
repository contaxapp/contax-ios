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
                Image(systemName: actionIcon)
                    .font(.system(size: 25.0))
                    .foregroundColor(.white)
                    .padding(.all, 20)
                    .background(
                        Circle()
                            .foregroundColor(Color.init("Darker Gray"))
                    )
                
                Text(actionText)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .padding(.bottom, 10)
            }
            .if(disabled) { view in
                view.opacity(0.3)
            }
        }
        .disabled(disabled)
    }
}
