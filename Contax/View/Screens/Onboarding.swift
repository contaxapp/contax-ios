//
//  Onboarding.swift
//  Contax
//
//  Created by Arpit Bansal on 20/08/22.
//

import SwiftUI

class OnboardingStage: ObservableObject {
    @Published var stage: Int = 1
}

struct OnboardingWrapper: View {
    
    @StateObject var onboardingStage = OnboardingStage()
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                VStack (alignment: .center) {
                    Image("Logo")
                }
                .frame(width: geometry.size.width, height: geometry.size.height * 0.2)
                
                switch (onboardingStage.stage) {
                    case 1:
                        Onboarding1(geometry)
                    case 2:
                        Onboarding2(geometry)
                    default: Text("LOL")
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .environmentObject(onboardingStage)
        }
    }
}

struct Onboarding1: View {
    
    var geometry: GeometryProxy
    @EnvironmentObject var onboardingStage: OnboardingStage
    
    init(_ geometry: GeometryProxy) {
        self.geometry = geometry
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Hey Arpit!")
                .font(.custom("EuclidCircularA-Regular", size: 30))
                .padding(.bottom, 30)
            Text("Let’s start by understanding your existing relationships.\n\nTap the button below to permit Contact access to your contacts.\n\nTap “OK” on the popup.")
                .font(.custom("EuclidCircularA-Light", size: 20))
                .lineSpacing(20)
        }
        .padding(.horizontal)
        .frame(width: geometry.size.width, height: geometry.size.height * 0.6)
        
        HStack(alignment: .center) {
            Button("Grant Access") {
                print("Granting access . . .")
                onboardingStage.stage = 2
            }
            .frame(width: geometry.size.width * 0.6, height: 60)
            .background((Color.init("Accent Green")))
            .foregroundColor(Color.white)
            .font(.custom("EuclidCircularA-Regular", size: 20))
            .cornerRadius(5.0, corners: .allCorners)
        }
        .frame(width: geometry.size.width, height: geometry.size.height * 0.2)
    }
}

struct Onboarding2: View {
    
    var geometry: GeometryProxy
    @EnvironmentObject var onboardingStage: OnboardingStage
    
    init(_ geometry: GeometryProxy) {
        self.geometry = geometry
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Hey LOL!")
                .font(.custom("EuclidCircularA-Regular", size: 30))
                .padding(.bottom, 30)
            Text("Let’s start by understanding your existing relationships.\n\nTap the button below to permit Contact access to your contacts.\n\nTap “OK” on the popup.")
                .font(.custom("EuclidCircularA-Light", size: 20))
                .lineSpacing(20)
        }
        .padding(.horizontal)
        .frame(width: geometry.size.width, height: geometry.size.height * 0.6)
        
        HStack(alignment: .center) {
            Button("Grant Access") {
                print("Granting access . . .")
                onboardingStage.stage = 3
            }
            .frame(width: geometry.size.width * 0.6, height: 60)
            .background((Color.init("Accent Green")))
            .foregroundColor(Color.white)
            .font(.custom("EuclidCircularA-Regular", size: 20))
            .cornerRadius(5.0, corners: .allCorners)
        }
        .frame(width: geometry.size.width, height: geometry.size.height * 0.2)
    }
}

struct Onboarding_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingWrapper()
    }
}
