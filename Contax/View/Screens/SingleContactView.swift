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
    
    var ContactsModelRef = ContactsModel()
    
    init(_ contactSelected: Contact?) {
        self.contact = contactSelected
    }
    
    var body: some View {
        ZStack {
            Color.init("Base Color").edgesIgnoringSafeArea(.all)
            GeometryReader { fullView in
                ScrollView {
                    ZStack {
                        ContactImageSection(contact, viewSize: fullView)
                        VStack {
                            HStack(alignment: .center) {
                                Button(action: {
                                    self.presentationMode.wrappedValue.dismiss()
                                }, label: {
                                    Image(systemName: "arrow.left")
                                        .font(.system(size: 20.0))
                                        .foregroundColor(.white)
                                        .background(
                                            Circle()
                                                .frame(width: 30, height: 30)
                                                .foregroundColor(Color.init("Lighter Gray"))
                                        )
                                })
                                
                                Spacer()
                                
                                Button(action: {
                                    print("Show more")
                                }, label: {
                                    Image(systemName: "ellipsis")
                                        .font(.system(size: 20.0))
                                        .foregroundColor(.white)
                                        .background(
                                            Circle()
                                                .frame(width: 30, height: 30)
                                                .foregroundColor(Color.init("Lighter Gray"))
                                        )
                                })
                            }
                            .padding(.top, 20)
                            .padding(.leading, 20)
                            .padding(.trailing, 20)
                            
                            Spacer()
                        }
                    }
                    
                    VStack(spacing: 20) {
                        Text("\(contact!.givenName) \(contact!.familyName)")
                            .foregroundColor(.white)
                            .font(.system(size: 40))
                            .fontWeight(.semibold)
                            .padding(.bottom, 10)
                            .padding(.top, 10)
                        
                        ContactWidgetGrid(contact)
                        ContactNotesSection()
                    }
                    .padding(.all, 20)
                    .foregroundColor(.white)
                }
                .navigationBarHidden(true)
            }
        }
        .onAppear(perform: {
            print(self.contact?.givenName)
        })
    }
}

struct SingleContactView_Previews: PreviewProvider {
    static var previews: some View {
        SingleContactView(.none)
    }
}
