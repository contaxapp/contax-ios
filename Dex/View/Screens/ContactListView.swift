//
//  ContentView.swift
//  Dex
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
                Contacts.fetchUpdatedContacts(from: .all)
            }
        }
    }
    
    init(){
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().barTintColor = UIColor.init(named: "Base Color")
        
        UITableView.appearance().backgroundColor = .clear
        
        // Realm Database
        let realm = try! Realm()
    }
    
    func returnInitials(_ contact: DBContact) -> String {
        let givenName = contact.givenName
        let familyName = contact.familyName
        
        return String(givenName[givenName.startIndex]) + String(familyName[familyName.startIndex])
    }
    
    @ViewBuilder
    var body: some View {
        NavigationView {
            ZStack {
                Color.init("Base Color").edgesIgnoringSafeArea(.all)
                VStack {
                    if Contacts.contacts != nil {
                        List {
                            ForEach(Contacts.contacts!) {contact in
                                Text("\(contact.givenName)").foregroundColor(.white)
                            }.listRowBackground(Color.init("Base Color"))
                        }.listStyle(PlainListStyle())
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Text("Contact List").font(.title).foregroundColor(.white).fontWeight(.bold),
                trailing: Button(action: {
                    print("Create Contact")
                }, label: {
                    Image(systemName: "plus").font(.title).foregroundColor(.white)
                })
            )
        }
        .onAppear(perform: {
            
            let authorizationStatus = Contacts.checkAuthorizationStatus()
            
            switch(authorizationStatus) {
                case 0: // notDetermined - User has not chosen yet
                    print("Not set. Requesting authorization and updating state.")
                    Contacts.requestAuthorization()
                    authorizationChange.toggle()
                case 1: // restricted - User cannot changet the setting due to parental restriction
                    // Show error
                    print("Restricted. Error")
                case 2: // denied - User has denied access to contacts
                    // Show error
                    print("Denied. Error")
                case 3:
                    print("Authorized. Fetching contacts.")
//                    Contacts.fetchUpdatedContacts(from: .all)
                    Contacts.fetchStoredContacts()
                default:
                    print("Will never reach here")
            }
        })
    }
}

struct ContactListView_Previews: PreviewProvider {
    static var previews: some View {
        ContactListView()
    }
}
