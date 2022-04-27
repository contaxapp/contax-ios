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
    let actionFn: () -> Void
    
    var body: some View {
        Button(action: actionFn) {
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
        }
    }
}
