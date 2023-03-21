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
                            Section {
                                HStack {
                                    Image("Placeholder Contact Image")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 80, height: 80, alignment: .center)
                                        .clipShape(Circle())
                                        .overlay(Circle().stroke(Color.white, lineWidth: 1))
                                        .padding(.trailing, 10)
                                    VStack (alignment: .leading, content: {
                                        Text("Arpit Bansal")
                                            .font(.custom("EuclidCircularA-Medium", size: 20))
                                            .padding(.bottom, 5)
                                        Text("Show Profile")
                                            .underline(true)
                                    })
                                }
                            }
                            .listRowInsets(EdgeInsets())
                            
                            Section {
                                SectionHeader(leading: "Account")
                                List {
                                    HStack {
                                        Image(systemName: "person.text.rectangle.fill")
                                        Text("Profile")
                                    }
                                    HStack {
                                        Image(systemName: "hand.raised.fill")
                                        Text("Privacy & Sharing")
                                    }
                                }
                            }
                            .listRowInsets(EdgeInsets())
                            
                            Section {
                                SectionHeader(leading: "Data Sync")
                                List {
                                    HStack {
                                        Image(systemName: "person.crop.circle")
                                        Text("Contacts")
                                    }
                                    HStack {
                                        Image(systemName: "envelope.fill")
                                        Text("Emails")
                                    }
                                }
                            }
                            .listRowInsets(EdgeInsets())
                            
                            Section {
                                SectionHeader(leading: "General")
                                List {
                                    HStack {
                                        Image(systemName: "bell.fill")
                                        Text("Notifications")
                                    }
                                    HStack {
                                        Image(systemName: "gear.circle")
                                        Text("Smart Groups")
                                    }
                                    HStack {
                                        Image(systemName: "rectangle.portrait.and.arrow.right")
                                        Text("Logout")
                                    }
                                }
                            }
                            .listRowInsets(EdgeInsets())
                        }
                        .font(.custom("EuclidCircularA-Regular", size: 18))
                        .foregroundColor(Color.init("Dark Gray"))
                    }
                    .scrollContentBackground(.hidden)
                    .scrollIndicators(.hidden)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Text("Settings").font(.custom("EuclidCircularA-Medium", size: 25)).foregroundColor(Color.init("Dark Gray")).fontWeight(.medium)
            )
            .padding(.horizontal)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
