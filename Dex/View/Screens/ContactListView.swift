//
//  ContentView.swift
//  Dex
//
//  Created by Arpit Bansal on 7/18/20.
//

import SwiftUI
import Contacts

struct ContactListView: View {
    
    @ObservedObject var Contacts = ContactsModel()
    
    @State private var searchText: String = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.init(.white).edgesIgnoringSafeArea(.all)
                VStack {
                    SearchBar(text: $searchText)
                    List(Contacts.contacts) { contact in
                        /*
                        Button(action: {
                            print(contact)
                            if let hashedContact = Contacts.hashContact(contact) {
                                print(hashedContact)
                            }
                        }) {
                            Text("\(contact.givenName) \(contact.familyName)")
                        }*/
                        NavigationLink(destination: SingleContactView(contact)) {
                            Text("\(contact.givenName) \(contact.familyName)")
                        }
                    }.listStyle(InsetListStyle())
                }
            }
            
            .navigationBarTitle("Contact List")
        }
        .statusBar(hidden: true)
        .onAppear(perform: {
            Contacts.requestAuthorization()
            Contacts.fetchContacts(from: .all)
        })
    }
}

struct ContactListView_Previews: PreviewProvider {
    static var previews: some View {
        ContactListView()
    }
}
