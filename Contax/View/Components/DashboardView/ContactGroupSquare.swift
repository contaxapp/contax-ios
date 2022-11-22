//
//  ContactGroupSquare.swift
//  Contax
//
//  Created by Arpit Bansal on 16/04/22.
//

import SwiftUI

struct ContactGroupSquare: View {
    
    private var group: String
    
    init(_ group: String) {
        self.group = group
    }
    
    var body: some View {
        ZStack (alignment: .bottom) {
//            Color.init("Darker Gray")
            Color.init(.sRGB, red: 0, green: 0, blue: 0, opacity: 0.4)
            VStack (alignment: .center) {
                Text("\(self.group)")
                    .font(.system(size: 15))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.bottom, 1)
                Text("12 People")
                    .font(.system(size: 10))
                    .foregroundColor(.white)
            }
            .padding(.bottom, 10)
        }
        .frame(width: 100, height: 100, alignment: .bottom)
        .background(
            Image("Group Image")
                .resizable()
                .aspectRatio(1, contentMode: .fill)
        )
        .cornerRadius(10)
        
    }
}
