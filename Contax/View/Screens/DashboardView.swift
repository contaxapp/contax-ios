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
    var recentlyAddedContacts = ["Princy", "Prachi", "Gabe", "Waseem"]
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    Color.init("Base Color").edgesIgnoringSafeArea(.all)
                    VStack (alignment: .leading) {
                        
                        VStack(alignment: .center) {
                            HStack {
                                DashboardWidget(icon: "plus", title: "Add Contact", parentSize: geometry)
                                DashboardWidget(icon: "camera.fill", title: "Scan Card", parentSize: geometry)
                                DashboardWidget(icon: "books.vertical.fill", title: "Organize", parentSize: geometry)
                                DashboardWidget(icon: "point.3.filled.connected.trianglepath.dotted", title: "Introduce", parentSize: geometry)
                            }
                            .frame(width: geometry.size.width)
                        }
                        .padding(.top, 20)
                        
                        // Groups
                        SectionHeader(heading: "Groups", paddingTop: 20, paddingBottom: 15)
                            .padding(.horizontal)
                        ScrollView (.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(groups, id: \.self) { group in
                                    ContactGroupSquare(group)
                                }
                            }.padding(.horizontal)
                        }
                        
                        // Recently Added Contacts
                        SectionHeader(heading: "Recently Added", paddingTop: 20, paddingBottom: 15)
                            .padding(.horizontal)
                        ScrollView (.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(recentlyAddedContacts, id: \.self) { contact in
                                    ContactCircle(contact)
                                }
                            }.padding(.horizontal)
                        }
                        
                        
                        // Upcoming Celebrations
                        SectionHeader(heading: "Upcoming Celebrations", paddingTop: 20, paddingBottom: 15)
                            .padding(.horizontal)
                        
                        Spacer()
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Text("Dashboard").font(.custom("EuclidCircularA-Medium", size: 25)).foregroundColor(Color.init("Dark Gray")).fontWeight(.medium),
                trailing: NavigationLink(destination: {
                    SettingsView()
                }, label: {
                    Image("Placeholder Contact Image")
                        .resizable()
                        .frame(width: 35, height: 35, alignment: .center)
                        .clipShape(Circle())
                        .aspectRatio(1, contentMode: .fit)
                })
                .padding(.horizontal)
            )
        }
    }
}
