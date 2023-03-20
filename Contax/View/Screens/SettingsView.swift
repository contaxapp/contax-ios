//
//  SettingsView.swift
//  Contax
//
//  Created by Arpit Bansal on 27/04/22.
//

import SwiftUI

struct SettingsView: View {
    
    @State var yay: Bool = true {
        didSet {
            DispatchQueue.main.async {
                print("toggle turned")
            }
        }
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    Color.init("Base Color").edgesIgnoringSafeArea(.all)
                    VStack {
                        Form {
                            Section(
                                header:
                                    Text("Account")
                                    .foregroundColor(Color.init("Light Gray"))
                                    .padding(.bottom, 5)
                                    .padding(.leading, -20)
                            ) {
                                NavigationLink {
                                    Text("LOL")
                                } label: {
                                    Text("Check Profile")
                                }
                                
                                Toggle("Hello", isOn: $yay)
                            }
                        }
                        .foregroundColor(Color.init("Dark Gray"))
                        .background(Color.init("Base Color"))
                    }
                    .scrollContentBackground(.hidden)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Text("Settings").font(.title).foregroundColor(.white).fontWeight(.bold)
            )
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
