//
//  ContentView.swift
//  Contax
//
//  Created by Arpit Bansal on 7/18/20.
//

import SwiftUI
import RealmSwift
import Contacts
import UnsplashSwiftUI
import KeyboardToolbar

let toolbarItems: [KeyboardToolbarItem] = [
    KeyboardToolbarItem.init(text: "Click 1", callback: {
        print("Click 1")
    }),
    KeyboardToolbarItem.init(text: "Click 2", callback: {
        print("Click 2")
    })
]

let toolbarStyle: KeyboardToolbarStyle = KeyboardToolbarStyle.init(backgroundColor: Color.init("Light Gray"), height: 50, dividerColor: Color.init("Dark Gray"), dividerWidth: 2)

struct ContactListView: View {
    
    @EnvironmentObject var Contacts: ContactsModel
    
    @State private var showContactErrorAlert = false
    @State private var searchTerm = ""
    @State private var showSearchDetailPane: Bool = false
    
    func getSectionedContactDictionary(_ Contacts: [Contact]) -> Dictionary <String , [Contact]> {
        let sectionDictionary: Dictionary<String, [Contact]> = {
            return Dictionary(grouping: Contacts, by: {
                let name = $0.givenName
                let normalizedName = name.folding(options: [.diacriticInsensitive, .caseInsensitive], locale: .current)
                if let normalizedFirstName = normalizedName.first {
                    let firstChar = String(normalizedFirstName).uppercased()
                    return firstChar
                } else {
                    return "#"
                }
            })
        }()
        return sectionDictionary
    }
    
    func filterContactsBySearch(SectionedDictionary: Dictionary<String, [Contact]>, key: String) -> [Contact] {
        return SectionedDictionary[key]!.filter({ (contact) -> Bool in
            self.searchTerm.isEmpty ? true : (
                contact.givenName.lowercased().contains(self.searchTerm.lowercased()) ||
                contact.familyName.lowercased().contains(self.searchTerm.lowercased())
            )
        })
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    Color.init("Base Color").edgesIgnoringSafeArea(.all)
                    VStack (alignment: .leading) {
                        // Search Bar
                        SearchBar(placeholder:Text("Search your contacts"), searchTerm: $searchTerm, showSearchDetailPane: $showSearchDetailPane)
                            .zIndex(1)
                            .background(Color.init("Base Color"))
                        
                        // All Contacts
                        List {
                            let sectionedContactDictionary = getSectionedContactDictionary(Contacts.contacts)
                            ForEach(sectionedContactDictionary.keys.sorted(), id:\.self) { key in
                                
                                // Get contacts for particular section (key)
                                if let contacts = filterContactsBySearch(SectionedDictionary: sectionedContactDictionary, key: key), !contacts.isEmpty {
                                    
                                    Section {
                                        ForEach(contacts) { contact in
                                            ContactListRow(contact: contact, viewSize: geometry)
                                        }
                                    } header: {
                                        Text("\(key)")
                                            .fontWeight(.bold)
                                            .listRowBackground(Color.init("Base Color"))
                                    }
                                }
                            }
                        }
                        .foregroundColor(Color.init("Light Gray"))
                        .scrollContentBackground(Color.clear)
                        .listStyle(GroupedListStyle())
                    }
                    
                    SearchDetailPane(showSearchDetailPane: $showSearchDetailPane, maxHeight: 300)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Text("Contacts").font(.title).foregroundColor(.white).fontWeight(.bold),
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
//            Contacts.fetchContactsForDisplay()
        })
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            Contacts.fetchContactsForDisplay()
        }
        .keyboardToolbar(toolbarItems, style: toolbarStyle)
    }
}
