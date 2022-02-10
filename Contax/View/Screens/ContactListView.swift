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
                Contacts.fetchContactsForDisplay(firstTime: true)
            }
        }
    }
    
    init() {
        
    }
    
    func returnInitials(_ contact: Contact) -> String {
        let givenName = contact.givenName
        let familyName = contact.familyName
        
        return String(givenName[givenName.startIndex]) + String(familyName[familyName.startIndex])
    }
    
    func convertContactType(contactToConvert: DBContact?) -> Contact? {
        let convertedContact = Contact(givenName: contactToConvert!.givenName, middleName: contactToConvert!.middleName, familyName: contactToConvert!.familyName, nickname: contactToConvert!.nickname, jobTitle: contactToConvert!.jobTitle, department: contactToConvert!.department, organization: contactToConvert!.organization)
        
        return convertedContact
    }
    
    @ViewBuilder
    var body: some View {
        NavigationView {
            ZStack {
                Color.init("Base Color").edgesIgnoringSafeArea(.all)
                VStack {
                    List {
                        ForEach(Contacts.contacts) { contact in
                                NavigationLink(destination: SingleContactView(contact)) {
                                    HStack(alignment: .center) {
                                        ZStack {
                                            Circle()
                                                .fill(Color.gray)
                                            Text(returnInitials(contact))
                                        }
                                        Text("\(contact.givenName) \(contact.familyName)").foregroundColor(.white)
                                    }
                                }
                        }.listRowBackground(Color.init("Base Color"))
                    }.listStyle(PlainListStyle())
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
                    Contacts.fetchContactsForDisplay(firstTime: false)
                default:
                    print("Will never reach here")
            }
        })
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            Contacts.fetchContactsForDisplay(firstTime: false)
        }
    }
}

struct ContactListView_Previews: PreviewProvider {
    static var previews: some View {
        ContactListView()
    }
}
