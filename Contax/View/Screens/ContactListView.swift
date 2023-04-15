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

struct ContactListView: View {
    
    @EnvironmentObject var Contacts: ContactsModel
    
    @State private var showContactErrorAlert = false
    @State private var searchTerm = ""
    @State private var showSearchDetailPane: Bool = false
    @State var selected = SearchTokens()
    
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
                    VStack (alignment: .leading) {
                        // Search Bar
                        SearchBar(placeholder:Text("Search your contacts"), searchTerm: $searchTerm, showSearchDetailPane: $showSearchDetailPane, searchTokens: $selected)
                            .zIndex(1)
                            .background(Color.white)
                            .padding(.top, 20)
                            .padding(.bottom, 10)
                        
                        // All Contacts
                        List {
                            let sectionedContactDictionary = getSectionedContactDictionary(Contacts.contacts)
                            ForEach(sectionedContactDictionary.keys.sorted(), id:\.self) { key in
                                
                                // Get contacts for particular section (key)
                                let contacts = filterContactsBySearch(SectionedDictionary: sectionedContactDictionary, key: key)
                                
                                if !contacts.isEmpty {
                                    
                                    Section {
                                        ForEach(contacts) { contact in
                                            ContactListRow(contact: contact, viewSize: geometry)
                                        }
                                    } header: {
                                        Text("\(key)")
                                            .foregroundColor(Color.init("Mid Gray"))
                                            .font(.custom("EuclidCircularA-Regular", size: 15))
                                    }
                                }
                            }
                        }
                        .foregroundColor(Color.init("Light Gray"))
                        .scrollContentBackground(.hidden)
                        .listStyle(GroupedListStyle())
                    }
                    
                    SearchDetailPane(showSearchDetailPane: $showSearchDetailPane, selected: $selected, maxHeight: 350)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Text("Contacts").font(.custom("EuclidCircularA-Medium", size: 25)).foregroundColor(Color.init("Dark Gray")).fontWeight(.medium),
                trailing: HStack {
                    Button {
                        print("Create Contact")
                    } label: {
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(Color.init("Dark Gray"))
                    }
                    
                    NavigationLink(destination: {
                        SettingsView()
                    }, label: {
                        Image("Placeholder Contact Image")
                            .resizable()
                            .frame(width: 35, height: 35, alignment: .center)
                            .clipShape(Circle())
                            .aspectRatio(1, contentMode: .fit)
                    })
                }
                    .padding(.horizontal)
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
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            Contacts.fetchContactsForDisplay()
        }
    }
}
