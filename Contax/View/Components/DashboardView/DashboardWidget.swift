//
//  DashboardWidger.swift
//  Contax
//
//  Created by Arpit Bansal on 27/04/22.
//

import SwiftUI

struct DashboardWidget: View {
    
    var title: Int
    var subtitle: String
    var geometry: GeometryProxy
    
    @State var number: Int = 0
    
    init(title: Int, subtitle: String, parentSize geometry: GeometryProxy) {
        self.title = title;
        self.subtitle = subtitle;
        self.geometry = geometry
    }
    
    var body: some View {
        VStack(alignment: .center) {
            Text("")
                .modifier(AnimatingNumber(number: number))
                .font(.largeTitle)
                .foregroundColor(Color.purple)
                .padding(.bottom, 1)
            Text(subtitle)
                .font(.system(size: 15))
        }
        .frame(width: geometry.size.width * 0.4, height: geometry.size.width * 0.25, alignment: .center)
        .foregroundColor(Color.init("Lighter Gray"))
        .onAppear(perform: {
            withAnimation(Animation.easeInOut(duration: 0.5)) {
                number = title
            }
        })
    }
}

struct AnimatingNumber: AnimatableModifier {
    var number: Int

    var animatableData: CGFloat {
        get { CGFloat(number) }
        set { number = Int(newValue) }
    }

    func body(content: Content) -> some View {
        Text(String(number))
    }
}
