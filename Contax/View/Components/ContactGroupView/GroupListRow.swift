//
//  GroupListRow.swift
//  Contax
//
//  Created by Arpit Bansal on 03/12/22.
//

import SwiftUI

struct GroupListRow: View {
    let group: ContactGroup
    let viewSize: GeometryProxy?
    
    var body: some View {
        NavigationLink(destination: Text(group.name)) {
            ZStack {
//                if self.contact.image != nil {
//                    Image(uiImage: UIImage(data: Data(base64Encoded: self.contact.image!)!)!)
//                        .resizable()
//                        .aspectRatio(contentMode: .fill)
//                        .frame(width: 40, height: 40, alignment: .center)
//                        .clipShape(Circle())
//                        .overlay(Circle().stroke(Color.white, lineWidth: 1))
//                } else {
                    Circle()
                        .fill(Color.gray)
                        .frame(width: 40, height: 40, alignment: .center)
                        .overlay(Circle().stroke(Color.white, lineWidth: 1))
                    Text(HelperFunctions.returnGroupInitials(self.group.name))
//                }
            }.frame(width: self.viewSize!.size.width * 0.1)
            
            Text("\(self.group.name)")
                .foregroundColor(Color.init("Dark Gray"))
                .font(.custom("EuclidCircularA-Regular", size: 15))
                .padding(.leading, 10)
        }
        .padding(.top, 2)
        .padding(.bottom, 2)
    }
}
