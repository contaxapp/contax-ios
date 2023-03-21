//
//  SectionHeader.swift
//  Contax
//
//  Created by Arpit Bansal on 16/04/22.
//

import SwiftUI

struct SectionHeader: View {
    
    var leading: String? = ""
    var paddingTop: CGFloat = 0
    var paddingBottom: CGFloat = 0
    var trailing: String? = ""
//    var trailingAction: () -> Void
    
    var body: some View {
        HStack {
            Text(leading ?? "")
                .foregroundColor(Color.init("Dark Gray"))
                .font(.custom("EuclidCircularA-Medium", size: 20))
                .fontWeight(.medium)
                .padding(.top, paddingTop)
                .padding(.bottom, paddingBottom)
            Spacer()
            Button {
//                trailingAction()
                return
            } label: {
                Text(trailing ?? "")
                    .font(.custom("EuclidCircularA-Regular", size: 14))
                    .foregroundColor(Color.init("Dark Gray"))
                    .underline(true)
            }
        }
    }
}
