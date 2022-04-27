//
//  MainView.swift
//  Contax
//
//  Created by Arpit Bansal on 16/04/22.
//

import SwiftUI

struct MainView: View {
    
    @State private var selection = 1
    
    var body: some View {
        TabView (selection: $selection) {
            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "square.grid.2x2")
                }
                .tag(1)
            ContactListView()
                .tabItem {
                    Label("Contacts", systemImage: "person.2")
                }
                .tag(2)
            
            Text("groups")
                .tabItem {
                    Label("Groups", systemImage: "rectangle.3.group")
                }
                .tag(3)
            
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(4)
        }
        .accentColor(Color.purple)
        .onAppear() {
            let standardAppearance = UITabBarAppearance()
            standardAppearance.backgroundColor = UIColor(Color.init("Darker Gray"))
//            standardAppearance.shadowColor = UIColor(Color.white)
            
            let itemAppearance = UITabBarItemAppearance()
            itemAppearance.normal.iconColor = UIColor(Color.init("Lighter Gray"))
            itemAppearance.selected.iconColor = UIColor(Color.purple)
            standardAppearance.inlineLayoutAppearance = itemAppearance
            standardAppearance.stackedLayoutAppearance = itemAppearance
            standardAppearance.compactInlineLayoutAppearance = itemAppearance
            
            UITabBar.appearance().standardAppearance = standardAppearance
            UITabBar.appearance().scrollEdgeAppearance = standardAppearance
        }
    }
}
