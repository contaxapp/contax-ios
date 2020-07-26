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
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Image("Placeholder Contact Image")
                .resizable()
                .aspectRatio(1, contentMode: .fill)
            Color.init(red: 0, green: 0, blue: 0, opacity: 0.2)
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
