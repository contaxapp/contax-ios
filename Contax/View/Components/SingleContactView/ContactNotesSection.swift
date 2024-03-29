//
//  ContactNotesSection.swift
//  Contax
//
//  Created by Arpit Bansal on 7/26/20.
//

import SwiftUI

struct ContactNotesSection: View {
    
    var body: some View {
        VStack(alignment: .leading) {
            SectionHeader(heading: "Notes")

            ContactNote(noteDate: "June 1, 2020", noteBody: "Arpit and I chatted and I learned more about his new hackathon project...")
            
            ContactNote(noteDate: "May 15, 2020", noteBody: "Arpit just started working at Blue Ashva Capital.")
        }
    }
}
