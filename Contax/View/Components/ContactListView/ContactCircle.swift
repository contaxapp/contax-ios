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
//            Circle()
//                .fill(Color.gray)
//                .frame(width: 50, height: 50, alignment: .center)
            Image("Placeholder Contact Image")
                .resizable()
                .clipShape(Circle())
                .aspectRatio(1, contentMode: .fit)
                .frame(width: 50, height: 50, alignment: .center)
            Text(self.contact)
                .foregroundColor(.white)
        }
        .frame(width: 70, height: 80)
    }
}
