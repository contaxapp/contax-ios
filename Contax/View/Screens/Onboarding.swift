//
//  Onboarding.swift
//  Contax
//
//  Created by Arpit Bansal on 10/08/22.
//

import SwiftUI
import _AuthenticationServices_SwiftUI

struct Onboarding: View {
    
    var body: some View {
        
        GeometryReader { geometry in
            ScrollView {
                VStack (alignment: .center) {
                    Group {
                        HStack {
                            Text("We are")
                                .foregroundColor(Color.init("Accent Green"))
                        }
                        Text("Relationships matter to us.")
                    }
                        .multilineTextAlignment(.center)
                        .lineSpacing(21)
                        .font(.custom("Helvetica Neue", size: 20))
                    Spacer()
                    Image("Onboarding")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geometry.size.width * 0.6, alignment: .center)
                    Spacer()
                    Text("But how we manage our relationships on our phones has not evolved since the beginning of the smartphone revolution.")
                        .font(.custom("Helvetica Neue", size: 20))
                        .multilineTextAlignment(.center)
                        .lineSpacing(21)
                    Spacer()
                    Image("DownArrow")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 100)
                    Spacer()
                    Text("It's time to change that.")
                        .font(.custom("Helvetica Neue", size: 20))
                        .fontWeight(.medium)
                }
                .padding(.top, geometry.size.height * 0.05)
                .padding(.horizontal, geometry.size.width * 0.1)
                .frame(width: geometry.size.width, height: geometry.size.height)
                
                VStack (alignment: .center) {
                    VStack {
                        
                    }
                    Spacer()
                    VStack {
                        
                    }
                    Spacer()
                    VStack {
                        
                    }
                    Spacer()
                    Text("By clicking “Sign up with Apple” above, you acknowledge that you have read and understood, and agree to Contax’s Terms of Service and Privacy Policy")
                        .font(.custom("Helvetica Neue", size: 12))
                        .foregroundColor(Color("Mid Gray"))
                        .multilineTextAlignment(.center)
                        .lineSpacing(12)
                        .fontWeight(.medium)
                }
                .padding(.top, geometry.size.height * 0.05)
                .padding(.horizontal, geometry.size.width * 0.1)
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
        }
    }
}

struct Onboarding_Previews: PreviewProvider {
    static var previews: some View {
        Onboarding()
    }
}
