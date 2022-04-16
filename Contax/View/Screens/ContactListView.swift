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
    @State var searchTerm = ""
    @State private var showDetails = true
    
    var groups = ["Hackathon", "Boston", "Dex"]
    var recentlyViewedContacts = ["Maria", "Waseem", "Nate", "Vivek"]
    var recentlyAddedContacts = ["Princy", "Prachi"]
    
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

    @ViewBuilder
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    Color.init("Base Color").edgesIgnoringSafeArea(.all)
                    VStack (alignment: .leading) {
                        // Search Bar
                        SearchBar(placeholder:Text("Search your contacts"), searchTerm: $searchTerm)
                            .zIndex(1)
                            .background(Color.init("Base Color"))
                        
                        if showDetails && searchTerm.isEmpty {
                            VStack (alignment: .leading) {
                                // Groups
                                SectionHeader(heading: "Groups")
                                ScrollView (.horizontal, showsIndicators: false) {
                                    HStack {
                                        ForEach(groups, id: \.self) { group in
                                            ContactGroupSquare(group)
                                        }
                                    }.padding(.horizontal)
                                }
                                
                                // Recently Viewed Contacts
                                SectionHeader(heading: "Recently Viewed", paddingTop: 10)
                                ScrollView (.horizontal, showsIndicators: false) {
                                    HStack {
                                        ForEach(recentlyViewedContacts, id: \.self) { contact in
                                            ContactCircle(contact)
                                        }
                                    }.padding(.horizontal)
                                }
                                
                                // Recently Added Contacts
                                SectionHeader(heading: "Recently Added", paddingTop: 10)
                                ScrollView (.horizontal, showsIndicators: false) {
                                    HStack {
                                        ForEach(recentlyAddedContacts, id: \.self) { contact in
                                            ContactCircle(contact)
                                        }
                                    }.padding(.horizontal)
                                }
                                
                                Divider()
                                    .background(Color.init("Lighter Gray"))
                                    .padding(.top, 10)
                                    .padding(.bottom, 10)
                            }
                            .transition(.move(edge: .top))
                            .zIndex(0)
                        }
            
                        
                        
                        // All Contacts
                        SectionHeader(heading: "Contacts")
                        if #available(iOS 15.0, *) {
                            List {
                                let sectionedContactDictionary = getSectionedContactDictionary(Contacts.contacts)
                                ForEach(sectionedContactDictionary.keys.sorted(), id:\.self) { key in
                                    
                                    // Get contacts for particular section (key)
                                    if let contacts = filterContactsBySearch(SectionedDictionary: sectionedContactDictionary, key: key), !contacts.isEmpty {
                                        Section(header: Text("\(key)")
                                            .foregroundColor(Color.white)
                                            .fontWeight(.bold)
                                        ) {
                                            ForEach(contacts) { contact in
                                                ContactListRow(contact, viewSize: geometry)
                                            }
                                        }
                                    }
                                }
                            }
                            .listStyle(PlainListStyle())
                            .simultaneousGesture(DragGesture().onChanged({ value in
                                // if keyboard is opened then hide it
                                if (value.predictedEndTranslation.height < 0) {
                                    withAnimation {
                                        if (showDetails == true) {
                                            showDetails.toggle()
                                        }
                                    }
                                }
                            }))
                            .refreshable {
                                withAnimation {
                                    if (showDetails == false) {
                                        showDetails.toggle()
                                    }
                                }
                            }
                        } else {
                            // Fallback on earlier versions
                        }
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
