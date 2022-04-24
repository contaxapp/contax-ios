//
//  MainView.swift
//  Contax
//
//  Created by Arpit Bansal on 16/04/22.
//

import SwiftUI

struct MainView: View {
    
    @State private var selection = 1
    
    init() {
//        UITabBar.appearance().isTranslucent = false
        UITabBar.appearance().unselectedItemTintColor = UIColor(Color.init("Darker Gray"))
        UITabBar.appearance().barTintColor = UIColor.init(Color.init("Base Color"))
    }
    
    var body: some View {
        TabView (selection:$selection) {
            ContactListView()
                .tabItem {
                    Label("Contact List", systemImage: "list.dash")
                }
                .tag(1)
            ContactListView()
                .tabItem {
                    Label("Contact List", systemImage: "pencil")
                }
                .tag(2)
            
            ContactListView()
                .tabItem {
                    Label("Contact List", systemImage: "pencil")
                }
                .tag(2)
            
            ContactListView()
                .tabItem {
                    Label("Contact List", systemImage: "pencil")
                }
                .tag(2)
        }
        .accentColor(Color.init("Lighter Gray"))
    }
}
