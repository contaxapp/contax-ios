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

struct SearchTokenDetail {
    var on: Bool = false
    var character: String
}

struct SearchTokens: Equatable {
    var locations = SearchTokenDetail(character: "#")
    var groups = SearchTokenDetail(character: "!")
    var notes = SearchTokenDetail(character: "@")
    var company = SearchTokenDetail(character: "$")
    
    static func == (lhs: SearchTokens, rhs: SearchTokens) -> Bool {
        if (lhs.locations.on != rhs.locations.on) { return false }
        if (lhs.groups.on != rhs.groups.on) { return false }
        if (lhs.notes.on != rhs.notes.on) { return false }
        if (lhs.company.on != rhs.company.on) { return false }
        
        return true
    }
    
    static func compare (lhs: SearchTokens, rhs: SearchTokens) -> String? {
        if (lhs.locations.on != rhs.locations.on) { return rhs.locations.character }
        if (lhs.groups.on != rhs.groups.on) { return rhs.groups.character }
        if (lhs.notes.on != rhs.notes.on) { return rhs.notes.character }
        if (lhs.company.on != rhs.company.on) { return rhs.company.character }
        
        return nil
    }
}

struct SearchToken: View {
    
    var tokenName: String
    @Binding var selected: Bool
    
    var body: some View {
        HStack {
            Button("\(tokenName)") {
                selected.toggle()
            }
                .font(.custom("EuclidCircularA-Light", size: 15))
                .foregroundColor(selected ? Color.white : Color.init("Dark Gray"))
                .frame(width: 100, height: 40)
        }
        .background(selected ? Color.init("Accent Green") : Color.white)
        .cornerRadius(8, corners: .allCorners)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.init("Light Gray"), lineWidth: 1)
        )
    }
}

struct SearchDetailPane: View {
    @Binding var showSearchDetailPane: Bool
    
    let maxHeight: CGFloat
    let minHeight: CGFloat
    
    @Binding var selected: SearchTokens

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

    init(showSearchDetailPane: Binding<Bool>, selected: Binding<SearchTokens>, maxHeight: CGFloat) {
        self.minHeight = maxHeight * Constants.minHeightRatio
        self.maxHeight = maxHeight
        self._showSearchDetailPane = showSearchDetailPane
        self._selected = selected
    }

    var body: some View {
        GeometryReader { geometry in
            withAnimation(.interactiveSpring()) {
                VStack(alignment: .center, spacing: 30) {
                    self.indicator
                        .padding(.top)
                    Text("Filter Panel")
                        .font(.custom("EuclidCircularA-Light", size: 20))
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color.init("Dark Gray"))
                    Text("Finding the right people in your life is no trivial task. Use the filter tags below to narrow down on the right people.")
                        .font(.custom("EuclidCircularA-Regular", size: 15))
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color.init("Mid Gray"))
                        .padding(.horizontal)
                        .lineSpacing(5)
                    Grid {
                        GridRow {
                            SearchToken(tokenName: "Location", selected: $selected.locations.on)
                            SearchToken(tokenName: "Group", selected: $selected.groups.on)
                            SearchToken(tokenName: "Notes", selected: $selected.notes.on)
                        }
                        GridRow {
                            SearchToken(tokenName: "Company", selected: $selected.company.on)
                        }
                    }
                }
                .padding(.horizontal)
                .frame(width: geometry.size.width, height: self.maxHeight, alignment: .top)
                .overlay(
                    Divider()
                       .frame(maxWidth: .infinity, maxHeight:2)
                       .background(Color.init("Accent Green")), alignment: .top
                )
                .background(Color.white)
                .frame(height: geometry.size.height, alignment: .bottom)
                .offset(y: max(self.offset + self.translation, 0))
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
}
