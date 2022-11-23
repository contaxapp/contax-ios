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
    @State var showCancelButton = false

    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass").foregroundColor(.white)
                
                ZStack (alignment: .leading) {
                    if searchTerm.isEmpty { placeholder.foregroundColor(Color.init("Light Gray")) }
                    TextField("", text: self.$searchTerm, onEditingChanged: { isEditing in
                        self.showCancelButton = true
                        showSearchDetailPane = isEditing
                    }, onCommit: {
                        
                    })
                    .foregroundColor(.white)
                    .keyboardType(.alphabet)
                    .disableAutocorrection(true)
                }
                
                Button(action: {
                    self.searchTerm = ""
                }) {
                    Image(systemName: "xmark.circle.fill").opacity(self.searchTerm == "" ? 0 : 1)
                }
            }
            .padding(EdgeInsets(top: 15, leading: 15, bottom: 15, trailing: 15))
            .foregroundColor(.white)
            .background(Color.init("Dark Gray"))
            .cornerRadius(30.0)
            
            if self.showCancelButton {
                Button("Cancel") {
                    UIApplication.shared.endEditing(true)
                    self.searchTerm = ""
                    self.showCancelButton = false
                }
                .foregroundColor(Color(.systemBlue))
            }
        }
        .padding(.horizontal)
        .padding(.top, 15)
        .padding(.bottom, 15)
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
