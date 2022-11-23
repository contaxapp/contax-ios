//
//  Splash.swift
//  Contax
//
//  Created by Arpit Bansal on 10/08/22.
//

import SwiftUI
import _AuthenticationServices_SwiftUI
import RealmSwift

struct Splash: View {
    
    let realm = try! Realm()
    
    @State private var userAuthenticated = false
    @State private var user: ASAuthorizationAppleIDCredential? = nil
    
    var body: some View {
        
        GeometryReader { geometry in
            TabView {
                
                // Tab View 1
                
                VStack (alignment: .center) {
                    VStack (spacing: 10) {
                        HStack (spacing: 5) {
                            Text("We are")
                            Text("social creatures.")
                                .foregroundColor(Color.init("Accent Green"))
                        }
                        Text("Relationships matter to us.")
                    }
                        .font(.custom("EuclidCircularA-Regular", size: 20))
                        .multilineTextAlignment(.center)
                    
                    Spacer()
                    
                    Image("Onboarding")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geometry.size.width * 0.6, alignment: .center)
                    
                    Spacer()
                    
                    VStack (spacing: 10) {
                        Text("But how we manage our")
                        HStack (spacing: 5) {
                            Text("relationships")
                                .foregroundColor(Color.init("Accent Green"))
                            Text("on our phones has")
                        }
                        Text("not evolved since the beginning")
                        HStack (spacing: 5) {
                            Text("of the")
                            Text("smartphone revolution.")
                                .foregroundColor(Color.init("Accent Green"))
                        }
                    }
                    .multilineTextAlignment(.center)
                    .lineSpacing(21)
                    
                    Spacer()
                    
                    Image("DownArrow")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 100)
                    
                    Spacer()
                    
                    Text("It's time to change that.")
                        .fontWeight(.medium)
                }
                .padding(.top, geometry.size.height * 0.05)
                .padding(.horizontal, geometry.size.width * 0.1)
                .frame(width: geometry.size.width, height: geometry.size.height)
                
                
                // Tab View 2
                
                VStack (alignment: .center) {
                    VStack{
                        ZStack {
                            Image("Circle 1")
                            Text("1")
                                .foregroundColor(Color.white)
                        }
                        .padding(.bottom, 30)
                        Text("Redefine Contacts")
                    }
                    Spacer()
                    VStack{
                        ZStack {
                            Image("Circle 2")
                            Text("2")
                                .foregroundColor(Color.white)
                        }
                        .padding(.bottom, 30)
                        Text("Provide Powerful Tools")
                    }
                    Spacer()
                    VStack{
                        ZStack {
                            Image("Circle 3")
                            Text("3")
                                .foregroundColor(Color.white)
                        }
                        .padding(.bottom, 30)
                        Text("Build Stronger Relationships")
                    }
                    Spacer()
                    VStack {
                        
                        if let firstName = user?.fullName?.givenName {
                            NavigationLink(destination: OnboardingWrapper(firstName: firstName).navigationBarBackButtonHidden(true),
                                           isActive: $userAuthenticated) {
                                EmptyView()
                            }
                        }
                        
                        SignInWithAppleButton(.continue) { request in
                            request.requestedScopes = [.fullName, .email]
                        } onCompletion: { result in
                            switch result {
                                case .success(let authResults):
                                    print("Authorisation successful")
                                
                                    switch authResults.credential {
                                        case let appleIDCredential as ASAuthorizationAppleIDCredential:
                                            
                                            // Create an account in your system. 'fullName' and 'email' will only be accessible on signup.
//                                            let userIdentifier = appleIDCredential.user
//                                            let fullName = appleIDCredential.fullName
//                                            let email = appleIDCredential.email
//
//                                            let stringFromByteArray = String(data: Data(appleIDCredential.identityToken!), encoding: .utf8)
//
//                                            print("Token: " + (stringFromByteArray ?? ""))
//                                            print("User ID: " + userIdentifier)
//                                            print(fullName ?? "")
//                                            print(email ?? "")
                                        
                                            user = appleIDCredential
                                        
                                            if (appleIDCredential.fullName != nil) {
                                                let authenticatedUser = DBUser(
                                                    id: appleIDCredential.user,
                                                    firstName: appleIDCredential.fullName!.givenName!,
                                                    lastName: appleIDCredential.fullName!.familyName!,
                                                    email: appleIDCredential.email ?? ""
                                                )
                                                
                                                try! realm.write {
                                                    realm.add(authenticatedUser)
                                                }
                                            }
                                        
                                            userAuthenticated = true
                                        
                                        case let passwordCredential as ASPasswordCredential:
                                        
                                            // Sign in using an existing iCloud Keychain credential.
                                            let username = passwordCredential.user
                                            let password = passwordCredential.password
                                            
                                            print(username)
                                            print(password)
                                            
                                        default:
                                            break
                                    }
                            
                                case .failure(let error):
                                    print("Authorisation failed: \(error.localizedDescription)")
                            }
                        }
                    }
                    .frame(height: 50)
                        
                    Spacer()
                    Text("By clicking “Sign up with Apple” above, you acknowledge that you have read and understood, and agree to Contax’s Terms of Service and Privacy Policy")
                        .foregroundColor(Color("Mid Gray"))
                        .font(.custom("EuclidCircularA-Regular", size: 12))
                        .multilineTextAlignment(.center)
                        .lineSpacing(12)
                        .fontWeight(.light)
                }
                .padding(.top, geometry.size.height * 0.05)
                .padding(.horizontal, geometry.size.width * 0.1)
                .frame(width: geometry.size.width, height: geometry.size.height)
                
                
            }
            .font(.custom("EuclidCircularA-Regular", size: 20))
            .tabViewStyle(.page(indexDisplayMode: .always))
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never))
            .indexViewStyle(PageIndexViewStyle())
        }
    }
}

struct Splash_Previews: PreviewProvider {
    static var previews: some View {
        Splash()
    }
}
