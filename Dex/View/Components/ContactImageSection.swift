//
//  ContactImageSection.swift
//  Dex
//
//  Created by Arpit Bansal on 7/26/20.
//

import SwiftUI

struct ContactImageSection: View {
    var contact: Contact?
    var viewSize: GeometryProxy?
    
    init(_ contactSelected: Contact?, viewSize: GeometryProxy?) {
        self.contact = contactSelected
        self.viewSize = viewSize
    }
    
    var contactImage: UIImage? {
        if (contact?.image != nil) {
            return UIImage(data: Data(base64Encoded: contact!.image!)!)!
        }
        
        return nil
    }
    
//    var imageAspectRatio: Float {
//        return contactImage?.size.height / contactImage?.size.width
//    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.init(.black)
            if contactImage != nil {
                Image(uiImage: contactImage!)
                    .resizable()
                    .aspectRatio(1, contentMode: .fill)
                    .overlay(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.init(.clear),
                                Color.init(.black).opacity(0.7)
                            ]
                        ),
                        startPoint: UnitPoint(x: (contactImage?.size.width)! / 2, y: 0),
                        endPoint: UnitPoint(x: (contactImage?.size.width)! / 2, y: 1))
                    )
            }
//            Color.init(red: 0, green: 0, blue: 0, opacity: 0.2)
            Text("\(contact!.givenName) \(contact!.familyName)")
                .foregroundColor(.white)
                .font(.title)
                .fontWeight(.semibold)
                .padding(.bottom, 20)
        }
        .frame(width: self.viewSize?.size.width, height: (self.viewSize?.size.height)! * 0.35, alignment: .bottom)
    }
}

struct ContactImageSection_Previews: PreviewProvider {
    static var previews: some View {
        ContactImageSection(nil, viewSize: nil)
    }
}
