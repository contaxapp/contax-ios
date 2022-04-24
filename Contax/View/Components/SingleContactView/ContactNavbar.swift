//
//  ContactNavbar.swift
//  Contax
//
//  Created by Arpit Bansal on 16/04/22.
//

import SwiftUI

struct ContactNavbar: View {
    var backAction: () -> ()
    
    var body: some View {
        HStack(alignment: .center) {
            Button(action: {
                backAction()
            }, label: {
                Image(systemName: "arrow.left")
                    .font(.system(size: 20.0))
                    .foregroundColor(.white)
                    .background(
                        Circle()
                            .frame(width: 30, height: 30)
                            .foregroundColor(Color.init("Darker Gray"))
                    )
            })
            
            Spacer()
            
            HStack {
                Button(action: {
                    print("Edit")
                }, label: {
                    Image(systemName: "pencil")
                        .font(.system(size: 20.0))
                        .foregroundColor(.white)
                        .background(
                            Circle()
                                .frame(width: 30, height: 30)
                                .foregroundColor(Color.init("Darker Gray"))
                        )
                })
                .padding(.trailing, 10)
                
                Button(action: {
                    print("Show more")
                }, label: {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 20.0))
                        .foregroundColor(.white)
                        .background(
                            Circle()
                                .frame(width: 30, height: 30)
                                .foregroundColor(Color.init("Darker Gray"))
                        )
                })
            }
        }
        .padding(.vertical)
        .padding(.horizontal)
    }
}
