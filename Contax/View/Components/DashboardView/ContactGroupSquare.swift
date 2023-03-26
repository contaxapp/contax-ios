//
//  ContactGroupSquare.swift
//  Contax
//
//  Created by Arpit Bansal on 16/04/22.
//

import SwiftUI

struct ContactGroupSquare: View {
    
    private var group: String
    private var destination: any View
    
    init(_ group: String, destination: any View) {
        self.group = group
        self.destination = destination
    }
    
    var body: some View {
        NavigationLink(destination: AnyView(destination)) {
            ZStack (alignment: .center) {
                Color.init(.sRGB, red: 0, green: 0, blue: 0, opacity: 0.5)
                VStack (alignment: .center) {
                    Text("\(self.group)")
                        .font(.custom("EuclidCircularA-Medium", size: 15))
                        .foregroundColor(.white)
                }
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
}
