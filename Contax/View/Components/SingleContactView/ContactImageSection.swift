//
//  ContactImageSection.swift
//  Contax
//
//  Created by Arpit Bansal on 7/26/20.
//

import SwiftUI

struct ContactImageSection: View {
    
    private var contact: Contact?
    private var viewSize: GeometryProxy?
    
    init(_ contactSelected: Contact?, viewSize: GeometryProxy?) {
        self.contact = contactSelected
        self.viewSize = viewSize
    }
    
    private var contactImage: UIImage? {
        if (contact?.image != nil) {
            return UIImage(data: Data(base64Encoded: contact!.image!)!)!
        }
        
        return nil
    }
    
    var body: some View {
        ZStack {
            /*Circle()
                .fill(LinearGradient(gradient: Gradient(colors: [Color.init("Gradient Color Light"), Color.init("Gradient Color Dark")]), startPoint: .leading, endPoint: .trailing))
                .frame(width: self.viewSize!.size.width * 1.2, height: self.viewSize!.size.height)
                .position(x: self.viewSize!.size.width/2, y: -20)
                .shadow(color: Color.init(Color.RGBColorSpace.sRGB, red: 0, green: 0, blue: 0, opacity: 0.2), radius: 8.0, x: 2.0, y: 2.0)*/
            VStack {
                if contactImage != nil {
                    Image(uiImage: contactImage!)
                        .resizable()
                        .aspectRatio(1, contentMode: .fill)
                        .clipShape(Circle())
                        .frame(width: self.viewSize!.size.width * 0.35, height: self.viewSize!.size.width * 0.35, alignment: .center)
                        .overlay(Circle().stroke(Color.white, lineWidth: 5))
                } else {
                    ZStack {
                        Circle()
                            .fill(Color.gray)
                            .frame(width: self.viewSize!.size.width * 0.35, height: self.viewSize!.size.width * 0.35, alignment: .center)
                            .overlay(Circle().stroke(Color.white, lineWidth: 5))
                        Text(HelperFunctions.returnInitials(contact!))
                            .foregroundColor(Color.white)
                            .font(.system(size: 60))
                    }
                }
            }
        }
        .frame(width: self.viewSize?.size.width, height: (self.viewSize?.size.height)! * 0.2)
    }
}
