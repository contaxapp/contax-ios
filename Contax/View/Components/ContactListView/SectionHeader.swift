//
//  SectionHeader.swift
//  Contax
//
//  Created by Arpit Bansal on 16/04/22.
//

import SwiftUI

struct SectionHeader: View {
    
    private var heading: String
    private var paddingTop: CGFloat
    private var paddingBottom: CGFloat
    
    init(heading: String, paddingTop: CGFloat = 0, paddingBottom: CGFloat = 0) {
        self.heading = heading
        self.paddingTop = paddingTop
        self.paddingBottom = paddingBottom
    }
    
    var body: some View {
        Text(heading)
            .foregroundColor(Color.init("Lighter Gray"))
            .padding(.horizontal)
            .padding(.top, paddingTop)
            .padding(.bottom, paddingBottom)
    }
}
