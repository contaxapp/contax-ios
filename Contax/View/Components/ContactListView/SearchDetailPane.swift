//
//  SearchDetailPane.swift
//  Contax
//
//  Created by Arpit Bansal on 27/04/22.
//

import SwiftUI

fileprivate enum Constants {
    static let radius: CGFloat = 16
    static let indicatorHeight: CGFloat = 6
    static let indicatorWidth: CGFloat = 60
    static let snapRatio: CGFloat = 0.25
    static let minHeightRatio: CGFloat = 0
}

struct SearchExplanationRow: View {
    var label: String
    var explanation: String
    var geometry: GeometryProxy
    
    var body: some View {
        HStack(alignment: .center, spacing: 5) {
            Text(label)
                .font(.subheadline)
                .fontWeight(.medium)
                .frame(minWidth: 20, maxWidth: geometry.size.width * 0.2, alignment: .center)
                .padding(5)
                .background(Color.init("Darker Gray"))
                .cornerRadius(10)
                .foregroundColor(Color.init("Lighter Gray"))
            Text(" - ")
            Text(explanation)
                .font(.subheadline)
        }
        .foregroundColor(Color.init("Darker Gray"))
    }
}

struct SearchDetailPane: View {
    @Binding var showSearchDetailPane: Bool
    
    let maxHeight: CGFloat
    let minHeight: CGFloat

    @GestureState private var translation: CGFloat = 0

    private var offset: CGFloat {
        showSearchDetailPane ? 0 : maxHeight - minHeight
    }

    private var indicator: some View {
        RoundedRectangle(cornerRadius: Constants.radius)
            .fill(Color.secondary)
            .frame(
                width: Constants.indicatorWidth,
                height: Constants.indicatorHeight
        ).onTapGesture {
            self.showSearchDetailPane.toggle()
        }
    }

    init(showSearchDetailPane: Binding<Bool>, maxHeight: CGFloat) {
        self.minHeight = maxHeight * Constants.minHeightRatio
        self.maxHeight = maxHeight
        self._showSearchDetailPane = showSearchDetailPane
    }

    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center, spacing: 30) {
                self.indicator
                    .padding(.top)
                Text("You can use the following symbols to search:")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color.init("Darker Gray"))
                VStack (alignment: .leading) {
                    SearchExplanationRow(label: "#group", explanation: "Search in a specific group", geometry: geometry)
                    SearchExplanationRow(label: "#location", explanation: "Search in a specific location", geometry: geometry)
                    SearchExplanationRow(label: "!recent", explanation: "Search recently added", geometry: geometry)
                }
                Text("Try typing in the search bar above")
                    .font(.subheadline)
                    .fontWeight(.regular)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color.init("Darker Gray"))
            }
            .padding(.horizontal)
            .frame(width: geometry.size.width, height: self.maxHeight, alignment: .top)
            .background(Color.init("Lighter Gray"))
            .cornerRadius(20, corners: [.topLeft, .topRight])
            .frame(height: geometry.size.height, alignment: .bottom)
            .offset(y: max(self.offset + self.translation, 0))
            .animation(.interactiveSpring())
            .gesture(
                DragGesture().updating(self.$translation) { value, state, _ in
                    state = value.translation.height
                }.onEnded { value in
                    let snapDistance = self.maxHeight * Constants.snapRatio
                    guard abs(value.translation.height) > snapDistance else {
                        return
                    }
                    self.showSearchDetailPane = value.translation.height < 0
                }
            )
        }
    }
}
