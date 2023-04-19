//
//  SearchBar.swift
//  Contax
//
//  Created by Arpit Bansal on 15/04/22.
//

import SwiftUI
import KeyboardToolbar

struct SearchBar : View {
    
    let placeholder: Text
    @Binding var searchTerm : String
    @Binding var showSearchDetailPane: Bool
    @Binding var searchTokens: SearchTokens

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
                        showSearchDetailPane = false
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
        .onChange(of: searchTokens) { [searchTokens] newValue in
            var updatedToken = SearchTokens.compare(lhs: searchTokens, rhs: newValue)!
            
            searchTerm += " " + updatedToken
        }
    }
}


extension UIApplication {
    func endEditing(_ force: Bool) {
        let connectedScenes = UIApplication.shared.connectedScenes
                    .filter({$0.activationState == .foregroundActive})
                    .compactMap({$0 as? UIWindowScene})
                
        let _ = connectedScenes.first?
            .windows
            .first {$0.isKeyWindow }?
            .endEditing(force)
    }
}
