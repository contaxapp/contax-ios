//
//  ContentView.swift
//  Dex
//
//  Created by Arpit Bansal on 7/18/20.
//

import SwiftUI

struct DevView: View {
    
    var Contacts = ContactsModel()
    
    func printContacts() {
        let contacts = Contacts.fetchContacts()
        print(contacts)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Button(action: printContacts) {
                    Text("Fetch Contacts")
                }
            }
        }
    }
}

struct DevView_Previews: PreviewProvider {
    static var previews: some View {
        DevView()
    }
}
