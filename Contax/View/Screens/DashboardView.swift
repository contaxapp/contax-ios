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

struct EdgeBorder: Shape {
    var width: CGFloat
    var edges: [Edge]

    func path(in rect: CGRect) -> Path {
        var path = Path()
        for edge in edges {
            var x: CGFloat {
                switch edge {
                case .top, .bottom, .leading: return rect.minX
                case .trailing: return rect.maxX - width
                }
            }

            var y: CGFloat {
                switch edge {
                case .top, .leading, .trailing: return rect.minY
                case .bottom: return rect.maxY - width
                }
            }

            var w: CGFloat {
                switch edge {
                case .top, .bottom: return rect.width
                case .leading, .trailing: return width
                }
            }

            var h: CGFloat {
                switch edge {
                case .top, .bottom: return width
                case .leading, .trailing: return rect.height
                }
            }
            path.addRect(CGRect(x: x, y: y, width: w, height: h))
        }
        return path
    }
}

extension View {
    func border(width: CGFloat, edges: [Edge], color: Color) -> some View {
        overlay(EdgeBorder(width: width, edges: edges).foregroundColor(color))
    }
}

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

                            DashboardWidget(icon: "camera.fill", title: "Scan Card", parentSize: geometry, destination: ContactCardScanning())
                            
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
                                ContactGroupSquare(group)
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
            VStack {
                
                Spacer()
                
                Text("New Contact")
                    .font(.custom("EuclidCircularA-Medium", size: 20))
                    .foregroundColor(Color.init("Dark Gray"))
                    .padding(.top, 20)
                
                TabView (selection: $quickAddContactTabSelection ){
                    // 1
                    
                    VStack {
                        
                        Text("How much time do you have?")
                            .font(.custom("EuclidCircularA-Regular", size: 14))
                            .foregroundColor(Color.init("Mid Gray"))
                        
                        Spacer()
                        
                        Button {
                            print("Quick")
                            quickAddContactTabSelection = 2
                        } label: {
                            Text("Quick Add (10 sec)")
                                .font(.custom("EuclidCircularA-Light", size: 18))
                                .foregroundColor(Color.init("Dark Gray"))
                                .frame(width: 300)
                                .padding(.all, 20)
                                .background(Color.init("Light Gray"))
                                .cornerRadius(10, corners: .allCorners)
                        }
                        .padding(.bottom, 10)
                        
                        Button {
                            print("Complete")
                        } label: {
                            Text("Complete Contact (30 sec)")
                                .font(.custom("EuclidCircularA-Light", size: 18))
                                .foregroundColor(Color.init("Dark Gray"))
                                .frame(width: 300)
                                .padding(.all, 20)
                                .background(Color.init("Light Gray"))
                                .cornerRadius(10, corners: .allCorners)
                        }
                        
                        Spacer()
                        
                        Text("The contact creation experience\nwill depend on your choice above")
                            .font(.custom("EuclidCircularA-Regular", size: 14))
                            .foregroundColor(Color.init("Mid Gray"))
                            .multilineTextAlignment(.center)
                    }
                    .tag(1)
                    
                    // 2
                    
                    VStack {
                        Text("What's their name?")
                            .font(.custom("EuclidCircularA-Regular", size: 14))
                            .foregroundColor(Color.init("Mid Gray"))
                        
                        Spacer()
                        
                        VStack(alignment: .leading) {
                            Text("First Name")
                                .font(.custom("EuclidCircularA-Regular", size: 14))
                                .foregroundColor(Color.init("Mid Gray"))
                                .padding(.bottom, 2)
                            Text("Princy")
                                .font(.custom("EuclidCircularA-Light", size: 18))
                                .foregroundColor(Color.init("Dark Gray"))
                        }
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/, 10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.init("Light Gray"), lineWidth: 1)
                        )
                        .background(Color.white)
                        .padding(.bottom, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                        
                        VStack(alignment: .leading) {
                            Text("Last Name")
                                .font(.custom("EuclidCircularA-Regular", size: 14))
                                .foregroundColor(Color.init("Mid Gray"))
                                .padding(.bottom, 2)
                            Text("Goyal")
                                .font(.custom("EuclidCircularA-Light", size: 18))
                                .foregroundColor(Color.init("Dark Gray"))
                        }
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/, 10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.init("Light Gray"), lineWidth: 1)
                        )
                        .background(Color.white)
                        .padding(.bottom, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                        
                        Spacer()
                        
                        Button {
                            print("Next")
                            quickAddContactTabSelection = 3
                        } label: {
                            Text("Next")
                                .font(.custom("EuclidCircularA-Light", size: 18))
                                .foregroundColor(Color.white)
                                .frame(width: 300)
                                .padding(.all, 20)
                                .background(Color.init("Accent Green"))
                                .cornerRadius(10, corners: .allCorners)
                        }
                    }
                    .tag(2)
                    
                    // 3
                    
                    VStack {
                        Text("What's Princy's number?")
                            .font(.custom("EuclidCircularA-Regular", size: 14))
                            .foregroundColor(Color.init("Mid Gray"))
                        
                        Spacer()
                        
                        VStack(alignment: .leading) {
                            Text("Label")
                                .font(.custom("EuclidCircularA-Regular", size: 14))
                                .foregroundColor(Color.init("Mid Gray"))
                                .padding(.bottom, 2)
                            Text("Home")
                                .font(.custom("EuclidCircularA-Light", size: 18))
                                .foregroundColor(Color.init("Dark Gray"))
                        }
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/, 10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.init("Light Gray"), lineWidth: 1)
                        )
                        .background(Color.white)
                        .padding(.bottom, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                        
                        VStack(alignment: .leading) {
                            Text("Number")
                                .font(.custom("EuclidCircularA-Regular", size: 14))
                                .foregroundColor(Color.init("Mid Gray"))
                                .padding(.bottom, 2)
                            Text("+91 9769601057")
                                .font(.custom("EuclidCircularA-Light", size: 18))
                                .foregroundColor(Color.init("Dark Gray"))
                        }
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/, 10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.init("Light Gray"), lineWidth: 1)
                        )
                        .background(Color.white)
                        .padding(.bottom, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                        
                        Spacer()
                        
                        Button {
                            print("Next")
                            quickAddContactTabSelection = 4
                        } label: {
                            Text("Next")
                                .font(.custom("EuclidCircularA-Light", size: 18))
                                .foregroundColor(Color.white)
                                .frame(width: 300)
                                .padding(.all, 20)
                                .background(Color.init("Accent Green"))
                                .cornerRadius(10, corners: .allCorners)
                        }
                    }
                    .tag(3)
                    
                    // 4
                    
                    VStack {
                        Text("Add a photo of Princy")
                            .font(.custom("EuclidCircularA-Regular", size: 14))
                            .foregroundColor(Color.init("Mid Gray"))
                        
                        Spacer()
                        
                        HStack {
                            VStack(alignment: .center) {
                                VStack {
                                    Image(systemName: "camera.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 30, height: 30)
                                        .padding(.all, 40)
                                        .foregroundColor(Color.init("Accent Green"))
                                }
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.init("Light Gray"), lineWidth: 1)
                                )
                                .padding(.bottom, 5)
                                
                                Text("Take Selfie")
                                    .font(.system(size: 12))
                            }
                            .foregroundColor(Color.init("Dark Gray"))
                            .padding(.trailing, 20)
                            
                            VStack(alignment: .center) {
                                VStack {
                                    Image(systemName: "photo")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 30, height: 30)
                                        .padding(.all, 40)
                                        .foregroundColor(Color.init("Accent Green"))
                                }
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.init("Light Gray"), lineWidth: 1)
                                )
                                .padding(.bottom, 5)
                                
                                Text("Pick Photo")
                                    .font(.system(size: 12))
                            }
                            .foregroundColor(Color.init("Dark Gray"))
                        }
                        
                        Spacer()
                        
                        Button {
                            print("Complete")
                        } label: {
                            Text("Complete")
                                .font(.custom("EuclidCircularA-Light", size: 18))
                                .foregroundColor(Color.white)
                                .frame(width: 300)
                                .padding(.all, 20)
                                .background(Color.init("Accent Green"))
                                .cornerRadius(10, corners: .allCorners)
                        }
                    }
                    .tag(4)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never))
                
                Spacer()
            }
            .padding(.horizontal)
            .presentationDetents([.fraction(0.5)])
            .presentationDragIndicator(.visible)
        }
    }
}
