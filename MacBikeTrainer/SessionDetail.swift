//
//  SessionDetail.swift
//  MacBikeTrainer
//
//  Created by David Da Silva on 10/9/20.
//  Copyright © 2020 David Da Silva. All rights reserved.
//

import SwiftUI

struct SessionDetail: View {
    var session: Session
    let aColor = Color(NSColor.Name("customControlColor"))

    var body: some View {
        ZStack {

        Rectangle()
            .foregroundColor(aColor)
            .frame(width: 220, height: 170, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .cornerRadius(20)
            
        GroupBox(label: Text("\(session.name)")
                    .font(.headline), content: {
            VStack {
                Text("This is the starting place")
                    .padding(.all)
                
                if session.percentComplete == 0 {
                    Text("NEW")
                } else {
                    Text("\(session.percentComplete) % Complete")
                        .padding(.all, 5)
                }
                
                
                Button(action: { print("Start Pushed") }) {
                    HStack {
                        Text("Go")
                            .fontWeight(.semibold)
                            .font(.subheadline)
                    }
                    .cornerRadius(10)
                }
                .background(aColor)
                .cornerRadius(10)
                
            }
        })
        .cornerRadius(10)
        .padding()
        }
        .cornerRadius(15)
    }
}

struct SessionDetail_Previews: PreviewProvider {
    static var previews: some View {
        SessionDetail(session: testData[1])
    }
}
