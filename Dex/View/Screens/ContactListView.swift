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
    
    @State private var authorizationChange: Bool = false {
        didSet {
            DispatchQueue.main.async {
                Contacts.fetchContacts(from: .all)
            }
        }
    }
    
    var groupedContacts: [ContactGroup] {
        return Dictionary(grouping: Contacts.contacts) { (contact) -> Character in
            return contact.givenName.first!
        }
        .map { (key: Character, value: [Contact]) -> ContactGroup in
            ContactGroup(id: key, contacts: value)
        }
        .sorted { (left, right) -> Bool in
            left.id < right.id
        }
    }
    
    init(){
//        UINavigationBar.appearance().largeTitleTextAttributes = [
//            .foregroundColor: UIColor.white,
//            .font: UIFont.systemFont(ofSize: 28, weight: .semibold)
//        ]
        UITableView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.init("Base Color").edgesIgnoringSafeArea(.all)
                VStack {
                    List {
                        ForEach(groupedContacts) { (group) in
                            Section(header: Text("\(String(group.id))")
                                        .font(.custom("Helvetica", size: 15.0))
                                        .foregroundColor(.white)
                                        .fontWeight(.bold)
                            ) {
                                ForEach(group.contacts) { contact in
                                    NavigationLink(destination: SingleContactView(contact)) {
                                        HStack {
                                            Image("Placeholder Contact Image")
                                                .resizable()
                                                .frame(width: 50, height: 50, alignment: .center)
                                                .cornerRadius(5.0)
                                                .padding(.trailing, 10)
                                            Text("\(contact.givenName) \(contact.familyName)")
                                                .font(.custom("Helvetica Neue", size: 15.0))
                                                .fontWeight(.medium)
                                                .foregroundColor(.white)
                                        }
                                    }.buttonStyle(PlainButtonStyle())
                                }
                            }
                        }
                        .listRowBackground(Color.init(.clear))
                    }
                    .listStyle(GroupedListStyle())
                }
            }
            .navigationBarItems(
                leading: Text("Contact List").font(.title).foregroundColor(.white).fontWeight(.bold),
                trailing: Image(systemName: "plus").font(.title).foregroundColor(.white)
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
                    Contacts.fetchContacts(from: .all)
                    print(groupedContacts)
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
