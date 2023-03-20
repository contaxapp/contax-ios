//
//  ContaxtGroupView.swift
//  Contax
//
//  Created by Arpit Bansal on 12/06/22.
//

import SwiftUI
import RealmSwift
import Contacts
import UnsplashSwiftUI

let contactGroups = [ContactGroup(id: "1", name: "Boston", contacts: []), ContactGroup(id: "2", name: "Mumbai", contacts: [])]

struct ContactGroupView: View {
    
    @EnvironmentObject var Contacts: ContactsModel
    
    @State private var showContactErrorAlert = false
    @State private var searchTerm = ""
    
    func getSectionedGroupDictionary(_ ContactGroups: [ContactGroup]) -> Dictionary <String , [ContactGroup]> {
        let sectionDictionary: Dictionary<String, [ContactGroup]> = {
            return Dictionary(grouping: ContactGroups, by: {
                let name = $0.name
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
    
    func filterGroupsBySearch(SectionedDictionary: Dictionary<String, [ContactGroup]>, key: String) -> [ContactGroup] {
        return SectionedDictionary[key]!.filter({ (ContactGroup) -> Bool in
            self.searchTerm.isEmpty ? true : (
                ContactGroup.name.lowercased().contains(self.searchTerm.lowercased())
            )
        })
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    VStack (alignment: .leading) {
                        // Search Bar
//                        SearchBar(placeholder:Text("Search your contacts"), searchTerm: $searchTerm)
//                            .zIndex(1)
//                            .background(Color.white)
//                            .padding(.top, 20)
//                            .padding(.bottom, 10)
                        
                        // All Contacts
                        List {
                            let sectionedGroupDictionary = getSectionedGroupDictionary(contactGroups)
                            ForEach(sectionedGroupDictionary.keys.sorted(), id:\.self) { key in
                                
                                // Get contacts for particular section (key)
                                if let groups = filterGroupsBySearch(SectionedDictionary: sectionedGroupDictionary, key: key), !groups.isEmpty {
                                    
                                    Section {
                                        ForEach(groups) { group in
                                            GroupListRow(group: group, viewSize: geometry)
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
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Text("Groups").font(.custom("EuclidCircularA-Medium", size: 25)).foregroundColor(Color.init("Dark Gray")).fontWeight(.medium),
                trailing: HStack {
                    Button {
                        print("Create Group")
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
