//
//  ContactNavbar.swift
//  Contax
//
//  Created by Arpit Bansal on 16/04/22.
//

import SwiftUI

struct ContactNavbar: View {
    let backAction: () -> ()
    
    var body: some View {
        HStack(alignment: .center) {
            Button(action: {
                backAction()
            }, label: {
                HStack {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18))
                        .foregroundColor(Color.init("Mid Gray"))
                    Text("Back")
                        .font(.custom("EuclidCircularA-Light", size: 20))
                        .foregroundColor(Color.init("Mid Gray"))
                }
            })
            
            Spacer()
            
            HStack {
                Button(action: {
                    print("Edit")
                }, label: {
                    Image(systemName: "pencil.circle")
                        .font(.system(size: 25.0))
                        .foregroundColor(Color.init("Accent Green"))
                })
                .padding(.trailing, 10)
                
                Button(action: {
                    print("Share")
                }, label: {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 25.0))
                        .foregroundColor(Color.init("Accent Green"))
                })
            }
        }
        .padding(.vertical)
        .padding(.horizontal)
    }
}
