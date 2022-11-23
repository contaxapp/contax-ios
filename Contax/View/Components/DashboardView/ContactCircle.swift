//
//  ContactCircle.swift
//  Contax
//
//  Created by Arpit Bansal on 16/04/22.
//

import SwiftUI

struct ContactCircle: View {
    
    private var contact: String
    
    init(_ contact: String) {
        self.contact = contact
    }
    
    var body: some View {
        VStack (alignment:.center) {
            Image("Placeholder Contact Image")
                .resizable()
                .clipShape(Circle())
                .aspectRatio(1, contentMode: .fit)
                .frame(width: 50, height: 50, alignment: .center)
                .padding(.bottom, 5)
            Text(self.contact)
                .font(.custom("EuclidCircularA-Regular", size: 12))
                .foregroundColor(Color.init("Dark Gray"))
        }
        .frame(width: 70, height: 80)
    }
}
