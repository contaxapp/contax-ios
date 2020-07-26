//
//  SingleContactView.swift
//  Dex
//
//  Created by Arpit Bansal on 7/26/20.
//

import SwiftUI
import Contacts

struct SingleContactView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    let contact : Contact?
    
    init(_ contactSelected: Contact?) {
        self.contact = contactSelected
    }
    
    var body: some View {
        ZStack {
            Color.init("Base Color").edgesIgnoringSafeArea(.all)
            GeometryReader { fullView in
                ScrollView {
                    ContactImageSection(contact, viewSize: fullView)
                    
                    VStack(spacing: 40) {
                        ContactWidgetGrid()
                        ContactNotesSection()
                    }
                    .padding(.all, 20)
                    .foregroundColor(.white)
                    .frame(minWidth: 0, idealWidth: fullView.size.width, maxWidth: .infinity, minHeight: fullView.size.height * 0.65, maxHeight: .infinity, alignment: .center)
                }
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(
                    leading:
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
                        }),
                    trailing:
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
                )
            }
        }
    }
}

struct SingleContactView_Previews: PreviewProvider {
    static var previews: some View {
        SingleContactView(.none)
    }
}
