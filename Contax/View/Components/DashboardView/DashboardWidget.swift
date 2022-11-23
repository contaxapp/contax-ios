//
//  DashboardWidger.swift
//  Contax
//
//  Created by Arpit Bansal on 27/04/22.
//

import SwiftUI

struct DashboardWidget: View {
    
    var icon: String
    var title: String
    var geometry: GeometryProxy
    
    @State var number: Int = 0
    
    init(icon: String, title: String, parentSize geometry: GeometryProxy) {
        self.icon = icon
        self.title = title
        self.geometry = geometry
    }
    
    var body: some View {
        VStack(alignment: .center) {
            VStack {
                Image(systemName: icon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 25)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 20)
                    .foregroundColor(Color.init("Accent Green"))
            }
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.init("Light Gray"), lineWidth: 1)
            )
            .padding(.bottom, 5)
            
            Text(title)
                .font(.system(size: 12))
        }
        .frame(width: geometry.size.width * 0.2, height: geometry.size.width * 0.25, alignment: .top)
        .foregroundColor(Color.init("Dark Gray"))
    }
}
