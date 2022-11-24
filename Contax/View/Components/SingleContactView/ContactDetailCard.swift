//
//  ContactDetailCard.swift
//  Contax
//
//  Created by Arpit Bansal on 7/26/20.
//

import SwiftUI

struct ContactDetailCard: View {
    let title: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.custom("EuclidCircularA-Regular", size: 15))
                .foregroundColor(Color.init("Mid Gray"))
                .padding(.bottom, 2)
            Text(content)
                .font(.custom("EuclidCircularA-Light", size: 20))
                .foregroundColor(Color.init("Dark Gray"))
        }
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
        .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/, 10)
        .background(Color.init("Light Gray"))
        .cornerRadius(10)
        .padding(.bottom, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
    }
}
