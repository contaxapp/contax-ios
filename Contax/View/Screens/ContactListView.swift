//
//  ContentView.swift
//  Contax
//
//  Created by Arpit Bansal on 7/18/20.
//

import SwiftUI
import RealmSwift
import Contacts

struct ContactListView: View {
    
    @ObservedObject var Contacts = ContactsModel()
    
    @State private var authorizationChange: Bool = false {
        didSet {
            DispatchQueue.main.async {
                print("Auth updated. Fetching contacts.")
                Contacts.fetchContactsForDisplay()
            }
        }
    }
    
    @State private var showContactErrorAlert = false
    
    @ViewBuilder
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    Color.init("Base Color").edgesIgnoringSafeArea(.all)
                    VStack {
                        List {
                            ForEach(Contacts.contacts) { contact in
                                NavigationLink(destination: SingleContactView(contact)) {
                                    ZStack {
                                        if contact.image != nil {
                                            Image(uiImage: UIImage(data: Data(base64Encoded: contact.image!)!)!)
                                                .resizable()
                                                .aspectRatio(1, contentMode: .fill)
                                                .clipShape(Circle())
                                                .frame(width: 50, height: 50, alignment: .center)
                                                .overlay(Circle().stroke(Color.white, lineWidth: 1))
                                        } else {
                                            Circle()
                                                .fill(Color.gray)
                                                .frame(width: 50, height: 50, alignment: .center)
                                                .overlay(Circle().stroke(Color.white, lineWidth: 1))
                                            Text(HelperFunctions.returnInitials(contact))
                                        }
                                    }.frame(width: geometry.size.width * 0.1)
                                    
                                    Text("\(contact.givenName) \(contact.familyName)")
                                        .foregroundColor(.white)
                                        .frame(width: geometry.size.width * 0.9, alignment: .leading)
                                        .padding(.leading, 10)
                                }
                            }
                            .listRowBackground(Color.init("Base Color"))
                            .padding(.top, 5)
                            .padding(.bottom, 5)
                        }
                        .listStyle(PlainListStyle())
                        .padding(.top, 20)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Text("Contact Book").font(.title).foregroundColor(.white).fontWeight(.bold),
                trailing: Button(action: {
                    print("Create Contact")
                }, label: {
                    Image(systemName: "plus").font(.title).foregroundColor(.white)
                })
            )
        }
        .alert(isPresented: $showContactErrorAlert, content: {
            Alert(
                title: Text("Contact Access"),
                message: Text("Access was denied. Kindly restart the app"),
                dismissButton: .default(
                    Text("Ok")
                )
            )
        })
        .onAppear(perform: {
            let authorizationStatus = Contacts.checkAuthorizationStatus()
            
            switch(authorizationStatus) {
                case 0: // notDetermined - User has not chosen yet
                    print("Not set. Requesting authorization and updating state.")
                    Task {
                        let auth = await Contacts.requestAuthorization()
                        if (auth) {
                            authorizationChange.toggle()
                        } else {
                            showContactErrorAlert.toggle()
                        }
                    }
                case 1: // restricted - User cannot changet the setting due to parental restriction
                    // Show error
                    print("Restricted. Error")
                case 2: // denied - User has denied access to contacts
                    // Show error
                    print("Denied. Error")
                case 3:
                    print("Authorized. Fetching contacts.")
                    Contacts.fetchContactsForDisplay()
                default:
                    print("Will never reach here")
            }
        })
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            Contacts.fetchContactsForDisplay()
        }
    }
}

struct ContactListView_Previews: PreviewProvider {
    static var previews: some View {
        ContactListView()
    }
}
