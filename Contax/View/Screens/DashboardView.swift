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
    @State var shouldPresentSheet: Bool = false
    @State var quickAddContactTabSelection: Int = 1
    
    var groups = ["Boston", "Mumbai"]
    var recentlyAddedContacts = ["Princy", "Prachi", "Gabe", "Waseem"]
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack (alignment: .leading) {
                    
                    VStack(alignment: .center) {
                        HStack {
                            Button {
                                shouldPresentSheet = true
                            } label: {
                                DashboardWidget(icon: "plus", title: "Add Contact", parentSize: geometry, destination: nil)
                            }

                            DashboardWidget(icon: "camera.fill", title: "Scan Card", parentSize: geometry, destination: ScanCardView())
                            
                            DashboardWidget(icon: "books.vertical.fill", title: "Organize", parentSize: geometry, destination: nil)
                            
                            DashboardWidget(icon: "point.3.filled.connected.trianglepath.dotted", title: "Introduce", parentSize: geometry, destination: nil)
                        }
                        .frame(width: geometry.size.width)
                    }
                    .padding(.top, 30)
                    
                    // Groups
                    SectionHeader(leading: "Groups", paddingTop: 20, paddingBottom: 15, trailing: "See all")
                        .padding(.horizontal)
                    ScrollView (.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(groups, id: \.self) { group in
                                ContactGroupSquare(group, destination: Text(group))
                            }
                        }.padding(.horizontal)
                    }
                    
                    // Recently Added Contacts
                    SectionHeader(leading: "Recently Added", paddingTop: 20, paddingBottom: 15, trailing: "See all")
                        .padding(.horizontal)
                    ScrollView (.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(recentlyAddedContacts, id: \.self) { contact in
                                ContactCircle(contact)
                            }
                        }.padding(.horizontal)
                    }
                    
                    
                    // Upcoming Celebrations
                    SectionHeader(leading: "Upcoming Celebrations", paddingTop: 20, paddingBottom: 15)
                        .padding(.horizontal)
                    VStack {
                        HStack {
                            Image("cake")
                                .padding(.all, 15)
                                .border(width: 1, edges: [.trailing], color: Color.init("Light Gray"))
                            HStack {
                                Text("Satyam Goyal’s 21st Birthday")
                                    .font(.custom("EuclidCircularA-Light", size: 15))
                                Spacer()
                                Image("hand")
                            }
                            .padding(.all, 15)
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.init("Light Gray"), lineWidth: 1)
                        )
                    }
                    .padding(.horizontal)
                    
                    Spacer()
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
        .sheet(isPresented: $shouldPresentSheet) {
            print("Sheet dismissed!")
        } content: {
            QuickAddContactSheet(quickAddContactTabSelection: $quickAddContactTabSelection, shouldPresentSheet: $shouldPresentSheet)
        }
    }
}
