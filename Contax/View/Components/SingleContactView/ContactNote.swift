//
//  ContactNote.swift
//  Contax
//
//  Created by Arpit Bansal on 7/26/20.
//

import SwiftUI

struct ContactNote: View {
    let noteDate: String
    let noteBody: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(noteDate)
                .fontWeight(.semibold)
                .padding(.bottom, 10)
            Text(noteBody)
        }
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
        .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/, 10)
        .background(Color.init("Dark Gray"))
        .cornerRadius(10)
        .padding(.bottom, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
    }
}
