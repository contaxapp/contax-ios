//
//  MainView.swift
//  Contax
//
//  Created by Arpit Bansal on 16/04/22.
//

import SwiftUI

struct MainView: View {
    
    @ObservedObject private var Contacts = ContactsModel()
    
    @State private var authorizationChange: Bool = false {
        didSet {
            DispatchQueue.main.async {
                print("Auth updated. Fetching contacts.")
                Contacts.fetchContactsForDisplay()
            }
        }
    }
    
    @State private var showContactErrorAlert = false
    
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
            
            ContactGroupView()
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
        .accentColor(Color.init("Accent Green"))
        .environmentObject(Contacts)
        .onAppear() {
            
            // Appearance
            
            let standardAppearance = UITabBarAppearance()
            standardAppearance.backgroundColor = UIColor(Color.white)
            standardAppearance.shadowColor = UIColor(Color.init("Mid Gray").opacity(0.3))
            
            let itemAppearance = UITabBarItemAppearance()
            itemAppearance.normal.iconColor = UIColor(Color.init("Mid Gray"))
            itemAppearance.selected.iconColor = UIColor(Color.init("Accent Green"))
            standardAppearance.inlineLayoutAppearance = itemAppearance
            standardAppearance.stackedLayoutAppearance = itemAppearance
            standardAppearance.compactInlineLayoutAppearance = itemAppearance
            
            UITabBar.appearance().standardAppearance = standardAppearance
            UITabBar.appearance().scrollEdgeAppearance = standardAppearance
            
            // Contacts
            
            let authorizationStatus = Contacts.checkAuthorizationStatus()
            
            switch(authorizationStatus) {
                case 0: // notDetermined - User has not chosen yet
                    print("Not set. Requesting authorization and updating state.")
                    Task {
                        let auth = await Contacts.requestAuthorization()
                        if (auth) {
                            authorizationChange.toggle()
                        } else {
                            showContactErrorAlert.toggle()
                        }
                    }
                case 1: // restricted - User cannot changet the setting due to parental restriction
                    // Show error
                    print("Restricted. Error")
                case 2: // denied - User has denied access to contacts
                    // Show error
                    print("Denied. Error")
                case 3:
                    print("Authorized. Fetching contacts.")
                    Contacts.fetchContactsForDisplay()
                default:
                    print("Will never reach here")
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            Contacts.fetchContactsForDisplay()
        }
    }
}

extension View {
    /// Applies the given transform if the given condition evaluates to `true`.
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - transform: The transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
