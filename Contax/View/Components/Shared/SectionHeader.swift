//
//  SectionHeader.swift
//  Contax
//
//  Created by Arpit Bansal on 16/04/22.
//

import SwiftUI

struct SectionHeader: View {
    
    let heading: String
    var paddingTop: CGFloat = 0
    var paddingBottom: CGFloat = 0
    
    var body: some View {
        Text(heading)
            .foregroundColor(Color.init("Lighter Gray"))
            .padding(.top, paddingTop)
            .padding(.bottom, paddingBottom)
    }
}
