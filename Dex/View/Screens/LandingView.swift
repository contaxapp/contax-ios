//
//  LandingView.swift
//  Dex
//
//  Created by Arpit Bansal on 7/18/20.
//

import SwiftUI

struct LandingView: View {
//    @State var show = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.init("Base Color").edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                GeometryReader { metrics in
                    VStack {
                        VStack {
                            Image("Logo")
                                .frame(width: 109, height: 45, alignment: .center)
                            Text("Build better\nrelationships.")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .lineLimit(2)
                        }
                        .frame(width: metrics.size.width, height: metrics.size.height * 0.5, alignment: .center)
                        
                        VStack {
                            NavigationLink(destination: ContactListView()) {
                                ZStack {
                                    Color.init("Lighter Gray")
                                    Text("Sign Up")
                                        .foregroundColor(.white)
                                }
                                .frame(width: 300, height: 50, alignment: .center)
                                .cornerRadius(10.0)
                            }
                            
                            NavigationLink(destination: ContactListView()) {
                                ZStack {
                                    Color.init(.white)
                                    Text("Sign In")
                                        .foregroundColor(Color.init("Base Color"))
                                }
                                .frame(width: 300, height: 50, alignment: .center)
                                .cornerRadius(10.0)
                            }
                            .padding(.bottom, 30)
                            
                            /*
                            Modal Example
                             
                            Button(action: { self.show.toggle() }) {
                                ZStack {
                                    Color.init(.white)
                                    Text("Sign In")
                                        .foregroundColor(Color.init("Base Color"))
                                }
                            }
                            .frame(width: 300, height: 50, alignment: .center)
                            .cornerRadius(10.0)
                            .sheet(isPresented: $show, onDismiss: {print("dismiss")}) {
                                Text("Modal")
                            }
                            .padding(.bottom, 30)
                            */
                        }
                        .frame(width: metrics.size.width, height: metrics.size.height * 0.5, alignment: .bottom)
                    }
                }
                
                .navigationBarHidden(true)
            }
        }
    }
}

struct LandingView_Previews: PreviewProvider {
    static var previews: some View {
        LandingView()
    }
}
