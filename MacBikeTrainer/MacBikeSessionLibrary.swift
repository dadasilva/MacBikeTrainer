//
//  MacBikeLibrary.swift
//  MacBikeTrainer
//
//  Created by David Da Silva on 10/6/20.
//  Copyright © 2020 David Da Silva. All rights reserved.
//

import SwiftUI

struct MacBikeSessionLibrary: View {
    var sessions: [Session] = []
    let bg1Color = Color(NSColor.Name("customControlBG1Color"))
    let bg2Color = Color(NSColor.Name("customControlBG2Color"))
    
    var body: some View {
        ZStack{
            
            LinearGradient(gradient: Gradient(colors: [bg1Color, bg2Color]), startPoint: .bottomLeading, endPoint: .trailing)
            
            HStack {
                NavigationView {
                    List {
                        ForEach(sessions) { session in
                            SessionCell(session: session)
                            Divider()
                        }
                        HStack {
                            Spacer()
                            Text("\(sessions.count) Sessions")
                                .foregroundColor(.secondary)
                            Spacer()
                        }
                    }
                    .cornerRadius(0)
                SessionDetail(session: testData[2])
                }
            }
        }
    }
}


struct MacBikeSessionLibrary_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MacBikeSessionLibrary(sessions: testData)
        }
    }
}


struct SessionCell: View {
    var session: Session
    var body: some View {
        NavigationLink(destination: SessionDetail(session: session)) {
            VStack(alignment: .trailing) {
                HStack {
                    Text(session.name)
                    Spacer()
                    if session.percentComplete == 0 {
                        Text("NEW")
                            .foregroundColor(.green)
                    } else {
                        Text("\(session.percentComplete)%")
                    }
                }
                .padding()
            }
        }
    }
}
