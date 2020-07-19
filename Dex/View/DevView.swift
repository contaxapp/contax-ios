//
//  ContentView.swift
//  Dex
//
//  Created by Arpit Bansal on 7/18/20.
//

import SwiftUI
import Contacts

struct DevView: View {
    
    @ObservedObject var Contacts = ContactsModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.init("Base Color").edgesIgnoringSafeArea(.all)
                List(Contacts.contacts) { contact in
                    Button(action: {
                        print(contact)
                        if let hashedContact = Contacts.hashContact(contact) {
                            print(hashedContact)
                        }
                    }) {
                        Text("\(contact.givenName ?? "") \(contact.familyName ?? "")")
                    }
                }.listStyle(InsetListStyle())
            }
            
            .navigationBarTitle("Contact List")
        }
        .onAppear(perform: {
            Contacts.requestAuthorization()
//            Contacts.fetchContacts(from: .containers)
            Contacts.fetchContacts(from: .all)
        })
    }
}

struct DevView_Previews: PreviewProvider {
    static var previews: some View {
        DevView()
    }
}
