//
//  ContactListRow.swift
//  Contax
//
//  Created by Arpit Bansal on 16/04/22.
//

import SwiftUI

struct ContactListRow: View {
    
    let contact: Contact
    let viewSize: GeometryProxy?
    
    var body: some View {
        NavigationLink(destination: SingleContactView(contact: self.contact)) {
            ZStack {
                if self.contact.image != nil {
                    Image(uiImage: UIImage(data: Data(base64Encoded: self.contact.image!)!)!)
                        .resizable()
                        .aspectRatio(1, contentMode: .fill)
                        .clipShape(Circle())
                        .frame(width: 40, height: 40, alignment: .center)
                        .overlay(Circle().stroke(Color.white, lineWidth: 1))
                } else {
                    Circle()
                        .fill(Color.gray)
                        .frame(width: 40, height: 40, alignment: .center)
                        .overlay(Circle().stroke(Color.white, lineWidth: 1))
                    Text(HelperFunctions.returnInitials(self.contact))
                }
            }.frame(width: self.viewSize!.size.width * 0.1)
            
            Text("\(self.contact.givenName) \(self.contact.familyName)")
                .foregroundColor(Color.init("Dark Gray"))
                .font(.custom("EuclidCircularA-Light", size: 15))
                .padding(.leading, 10)
        }
        .listRowBackground(Color.init("Base Color"))
        .padding(.top, 2)
        .padding(.bottom, 2)
    }
}
