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
                print("Auth updated. Fetching contacts.")
                Contacts.fetchContactsForDisplay()
            }
        }
    }
    
    @State private var showContactErrorAlert = false
    
    func getSectionedContactDictionary(_ Contacts: [Contact]) -> Dictionary <String , [Contact]> {
        let sectionDictionary: Dictionary<String, [Contact]> = {
            return Dictionary(grouping: Contacts, by: {
                let name = $0.givenName
                let normalizedName = name.folding(options: [.diacriticInsensitive, .caseInsensitive], locale: .current)
                let firstChar = String(normalizedName.first!).uppercased()
                return firstChar
            })
        }()
        return sectionDictionary
    }
    
    @State var searchTerm = ""
    @State private var showDetails = true
    
    var groups = ["Hackathon", "Boston", "Dex"]
    var recentlyViewedContacts = ["Maria", "Waseem", "Nate", "Vivek"]
    var recentlyAddedContacts = ["Princy", "Prachi"]
    
    @ViewBuilder
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    Color.init("Base Color").edgesIgnoringSafeArea(.all)
                    VStack (alignment: .leading) {
                        // Search Bar
                        SearchBar(placeholder:Text("Search your contacts"), searchTerm: $searchTerm)
                        
                        if showDetails {
                            VStack (alignment: .leading) {
                                // Groups
                                Text("Groups")
                                    .foregroundColor(Color.init("Lighter Gray"))
                                    .padding(.horizontal)
                                ScrollView (.horizontal, showsIndicators: false) {
                                    HStack {
                                        ForEach(groups, id: \.self) { group in
                                            ZStack (alignment: .bottom) {
                                                Color.init("Darker Gray")
                                                VStack (alignment: .center) {
                                                    Text("\(group)")
                                                        .font(.system(size: 15))
                                                        .foregroundColor(.white)
                                                        .padding(.bottom, 1)
                                                    Text("12 People")
                                                        .font(.system(size: 10))
                                                        .foregroundColor(.white)
                                                }
                                                .padding(.bottom, 10)
                                            }
                                            .frame(width: 100, height: 100, alignment: .leading)
                                            .cornerRadius(10)
                                        }
                                    }.padding(.horizontal)
                                }.frame(height: 100)
                                
                                // Recently Viewed Contacts
                                Text("Recently Viewed")
                                    .foregroundColor(Color.init("Lighter Gray"))
                                    .padding(.horizontal)
                                    .padding(.top, 10)
                                ScrollView (.horizontal, showsIndicators: false) {
                                    HStack {
                                        ForEach(recentlyViewedContacts, id: \.self) { contact in
                                            VStack (alignment:.center) {
                                                Circle()
                                                    .fill(Color.gray)
                                                    .frame(width: 50, height: 50, alignment: .center)
                                                Text("\(contact)")
                                                    .foregroundColor(.white)
                                            }
                                            .frame(width: 70, height: 80)
                                        }
                                    }.padding(.horizontal)
                                }.frame(height: 100)
                                
                                // Recently Added Contacts
                                Text("Recently Added")
                                    .foregroundColor(Color.init("Lighter Gray"))
                                    .padding(.horizontal)
                                ScrollView (.horizontal, showsIndicators: false) {
                                    HStack {
                                        ForEach(recentlyAddedContacts, id: \.self) { contact in
                                            VStack (alignment:.center) {
                                                Circle()
                                                    .fill(Color.gray)
                                                    .frame(width: 50, height: 50, alignment: .center)
                                                Text("\(contact)")
                                                    .foregroundColor(.white)
                                            }
                                            .frame(width: 70, height: 80)
                                        }
                                    }.padding(.horizontal)
                                }.frame(height: 100)
                                
                                Divider()
                                    .background(Color.init("Lighter Gray"))
                                    .padding(.top, 10)
                                    .padding(.bottom, 10)
                            }
                            .transition(.move(edge: .top))
                        }
            
                        
                        
                        // All Contacts
                        Text("Contacts")
                            .foregroundColor(Color.init("Lighter Gray"))
                            .padding(.horizontal)
                        List {
                            ForEach(getSectionedContactDictionary(Contacts.contacts).keys.sorted(), id:\.self) { key in
                                if let contacts = getSectionedContactDictionary(Contacts.contacts)[key]
                                {
                                    Section(header: Text("\(key)")
                                        .foregroundColor(Color.white)
                                        .fontWeight(.bold)
                                    ) {
                                        ForEach(contacts) { contact in
                                            NavigationLink(destination: SingleContactView(contact)) {
                                                ZStack {
                                                    if contact.image != nil {
                                                        Image(uiImage: UIImage(data: Data(base64Encoded: contact.image!)!)!)
                                                            .resizable()
                                                            .aspectRatio(1, contentMode: .fill)
                                                            .clipShape(Circle())
                                                            .frame(width: 50, height: 50, alignment: .center)
                                                            .overlay(Circle().stroke(Color.white, lineWidth: 1))
                                                    } else {
                                                        Circle()
                                                            .fill(Color.gray)
                                                            .frame(width: 50, height: 50, alignment: .center)
                                                            .overlay(Circle().stroke(Color.white, lineWidth: 1))
                                                        Text(HelperFunctions.returnInitials(contact))
                                                    }
                                                }.frame(width: geometry.size.width * 0.1)
                                                
                                                Text("\(contact.givenName) \(contact.familyName)")
                                                    .foregroundColor(.white)
                                                    .frame(width: geometry.size.width * 0.9, alignment: .leading)
                                                    .padding(.leading, 10)
                                            }
                                        }
                                        .listRowBackground(Color.init("Base Color"))
                                        .padding(.top, 5)
                                        .padding(.bottom, 5)
                                    }
                                }
                            }
                        }
                        .listStyle(PlainListStyle())
                        .simultaneousGesture(DragGesture().onChanged({ value in
                            // if keyboard is opened then hide it
                            print("SCROLLED")
                            if (value.predictedEndTranslation.height < 0) {
                                withAnimation {
                                    showDetails.toggle()
                                }
                            }
                        }))
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

struct ContactListView_Previews: PreviewProvider {
    static var previews: some View {
        ContactListView()
    }
}
