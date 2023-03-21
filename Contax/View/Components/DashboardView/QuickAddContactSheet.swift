//
//  QuickAddContactSheet.swift
//  Contax
//
//  Created by Arpit Bansal on 22/03/23.
//

import SwiftUI

struct QuickAddContactSheet: View {
    
    @Binding var quickAddContactTabSelection: Int
    @Binding var shouldPresentSheet: Bool
    
    var body: some View {
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
                        shouldPresentSheet = false
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
