//
//  DashboardView.swift
//  Contax
//
//  Created by Arpit Bansal on 24/04/22.
//

import SwiftUI
import RealmSwift
import Contacts
import UnsplashSwiftUI

struct DashboardView: View {
    @ObservedObject var Contacts = ContactsModel()
    
    @State private var authorizationChange: Bool = false {
        didSet {
            DispatchQueue.main.async {
                print("Auth updated. Fetching contacts.")
                Contacts.fetchContactsForDisplay()
            }
        }
    }
    
    @State private var showContactErrorAlert = false
    
    var groups = ["Hackathon", "Boston", "Dex"]
    var recentlyViewedContacts = ["Maria", "Waseem", "Nate", "Vivek"]
    var recentlyAddedContacts = ["Princy", "Prachi"]
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    Color.init("Base Color").edgesIgnoringSafeArea(.all)
                    VStack (alignment: .leading) {
                        
                        VStack(alignment: .center) {
                            HStack {
                                DashboardWidget(title: Contacts.contacts.count, subtitle: "Contacts", parentSize: geometry)
                                DashboardWidget(title: 16, subtitle: "Groups", parentSize: geometry)
                            }
                            .frame(width: geometry.size.width)
                            
                            HStack {
                                DashboardWidget(title: recentlyAddedContacts.count, subtitle: "Recently Added", parentSize: geometry)
                                DashboardWidget(title: recentlyViewedContacts.count, subtitle: "Recently Viewed", parentSize: geometry)
                            }
                            .frame(width: geometry.size.width)
                        }
                        
                        // Groups
                        SectionHeader(heading: "Groups")
                            .padding(.horizontal)
                        ScrollView (.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(groups, id: \.self) { group in
                                    ContactGroupSquare(group)
                                }
                            }.padding(.horizontal)
                        }
                        
                        // Recently Viewed Contacts
                        SectionHeader(heading: "Recently Viewed", paddingTop: 10)
                            .padding(.horizontal)
                        ScrollView (.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(recentlyViewedContacts, id: \.self) { contact in
                                    ContactCircle(contact)
                                }
                            }.padding(.horizontal)
                        }
                        
                        // Recently Added Contacts
                        SectionHeader(heading: "Recently Added", paddingTop: 10)
                            .padding(.horizontal)
                        ScrollView (.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(recentlyAddedContacts, id: \.self) { contact in
                                    ContactCircle(contact)
                                }
                            }.padding(.horizontal)
                        }
                        
                        Spacer()
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Text("Dashboard").font(.title).foregroundColor(.white).fontWeight(.bold),
                trailing: Button(action: {
                    print("Create Contact")
                }, label: {
                    Image(systemName: "plus").font(.title).foregroundColor(.white)
                })
            )
        }
        .alert(isPresented: $showContactErrorAlert, content: {
            Alert(
                title: Text("Contact Access"),
                message: Text("Access was denied. Kindly restart the app"),
                dismissButton: .default(
                    Text("Ok")
                )
            )
        })
        .onAppear(perform: {
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
        })
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            Contacts.fetchContactsForDisplay()
        }
    }
}
