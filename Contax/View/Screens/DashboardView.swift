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
    
    @EnvironmentObject var Contacts: ContactsModel
    
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
    }
}
