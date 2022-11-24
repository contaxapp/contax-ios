//
//  SingleContactView.swift
//  Contax
//
//  Created by Arpit Bansal on 7/26/20.
//

import SwiftUI
import Contacts

struct SingleContactView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    let contact : Contact?
    
    struct phoneCode: Decodable {
        var name: String
        var dial_code: String
        var code: String
    }
    
    func load<T: Decodable>(_ filename: String) -> T {
        let data: Data

        guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
            else {
                fatalError("Couldn't find \(filename) in main bundle.")
        }

        do {
            data = try Data(contentsOf: file)
        } catch {
            fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
        }

        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
        }
    }
    
    var body: some View {
        ZStack {
            Color.init("Base Color").edgesIgnoringSafeArea(.all)
            GeometryReader { fullView in
                ScrollView (.vertical, showsIndicators: false) {
                    VStack {
                        ContactNavbar(backAction: {
                            self.presentationMode.wrappedValue.dismiss()
                        })
                        
                        ContactImageSection(contact: contact, viewSize: fullView)
                        
                        VStack (alignment: .center) {
                            Text("\(contact!.givenName) \(contact!.familyName)")
                                .foregroundColor(Color.init("Dark Gray"))
                                .font(.custom("EuclidCircularA-Regular", size: 30))
                                .padding(.bottom, 10)
                            
                            ContactWidgetGrid(contact: contact)
                        }
                        
                        VStack(alignment: .leading, spacing: 20) {
                            
                            let phoneCodes: [phoneCode] = load("PhoneCodes.json")
                            
                            // Text("(" + phoneCodes.first(where: { phoneCode in
                            //                                            phoneCode.dial_code == phoneNumber.phone.substring(to: phoneNumber.phone.index(phoneNumber.phone.startIndex, offsetBy: 3))
                            //                                        })!.name + ")")
                            //                                        .foregroundColor(Color.init("Dark Gray"))
                            
                            // Phone Numbers
                            SectionHeader(heading: "Phone Numbers")
                            ForEach(contact!.phoneNumbers, id: \.phone) { phoneNumber in
                                ContactDetailCard(
                                    title: phoneNumber.label.replacingOccurrences(of: "_$!<", with: "").replacingOccurrences(of: ">!$_", with: ""),
                                    content: phoneNumber.phone
                                )
                            }
                            
                            // Email Addresses
                            SectionHeader(heading: "Email")
                            ForEach(contact!.emailAddresses, id: \.email) { emailAddress in
                                ContactDetailCard(
                                    title: emailAddress.label.replacingOccurrences(of: "_$!<", with: "").replacingOccurrences(of: ">!$_", with: ""),
                                    content: emailAddress.email
                                )
                            }
                            
                            SectionHeader(heading: "Notes")
                            if (!contact!.note.isEmpty) {
                                ContactDetailCard(
                                    title: "April 16, 2022",
                                    content: contact!.note
                                )
                            } else {
                                Text("No notes found")
                            }
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal)
                    }
                }
                .navigationBarHidden(true)
            }
        }
        .onAppear(perform: {
            
        })
    }
}
