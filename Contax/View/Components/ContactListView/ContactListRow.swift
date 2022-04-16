//
//  ContactListRow.swift
//  Contax
//
//  Created by Arpit Bansal on 16/04/22.
//

import SwiftUI

struct ContactListRow: View {
    
    private var contact: Contact
    private var viewSize: GeometryProxy?
    
    init(_ contact: Contact, viewSize: GeometryProxy?) {
        self.contact = contact
        self.viewSize = viewSize
    }
    
    var body: some View {
        NavigationLink(destination: SingleContactView(self.contact)) {
            ZStack {
                if self.contact.image != nil {
                    Image(uiImage: UIImage(data: Data(base64Encoded: self.contact.image!)!)!)
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
                    Text(HelperFunctions.returnInitials(self.contact))
                }
            }.frame(width: self.viewSize!.size.width * 0.1)
            
            Text("\(self.contact.givenName) \(self.contact.familyName)")
                .foregroundColor(.white)
                .frame(width: self.viewSize!.size.width * 0.9, alignment: .leading)
                .padding(.leading, 10)
        }
        .listRowBackground(Color.init("Base Color"))
        .padding(.top, 5)
        .padding(.bottom, 5)
    }
}
