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
                .font(.title3)
                .fontWeight(.semibold)
                .padding(.bottom, 10)
            Text(noteBody)
        }
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
        .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/, 10)
        .background(Color.init("Lighter Gray"))
        .cornerRadius(10)
        .padding(.bottom, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
    }
}

struct ContactNote_Previews: PreviewProvider {
    static var previews: some View {
        ContactNote(noteDate: "June 1, 2020", noteBody: "Arpit and I chatted and I learned more about his new hackathon project...")
    }
}
