//
//  GroupSearchBar.swift
//  Contax
//
//  Created by Arpit Bansal on 26/03/23.
//

import SwiftUI

struct GroupSearchBar : View {
    
    let placeholder: Text
    @Binding var searchTerm : String
    @Binding var showSearchDetailPane: Bool

    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass").foregroundColor(Color.init("Mid Gray"))
                
                ZStack (alignment: .leading) {
                    if searchTerm.isEmpty {
                        placeholder
                            .font(.custom("EuclidCircularA-Light", fixedSize: 20))
                            .foregroundColor(Color.init("Mid Gray"))
                    }
                    TextField("", text: self.$searchTerm, onEditingChanged: { isEditing in
                        showSearchDetailPane = isEditing
                    }, onCommit: {
                        
                    })
                    .font(.custom("EuclidCircularA-Light", fixedSize: 20))
                    .foregroundColor(Color.init("Mid Gray"))
                    .keyboardType(.alphabet)
                    .disableAutocorrection(true)
                }
                
                Button(action: {
                    self.searchTerm = ""
                    UIApplication.shared.endEditing(true)
                }) {
                    Image(systemName: "xmark.circle.fill").opacity(self.searchTerm == "" ? 0 : 1)
                }
            }
            .padding(EdgeInsets(top: 15, leading: 15, bottom: 15, trailing: 15))
            .foregroundColor(Color.init("Mid Gray"))
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.init("Light Gray"), lineWidth: 1)
            )
        }
        .padding(.horizontal)
    }
}
