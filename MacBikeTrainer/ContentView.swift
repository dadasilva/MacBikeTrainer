//
//  ContentView.swift
//  MacBikeTrainer
//
//  Created by David Da Silva on 10/5/20.
//  Copyright © 2020 David Da Silva. All rights reserved.
//

import SwiftUI

#if DEBUG

struct ContentView: View {
    var body: some View {
        VStack {
            Text("MacBikeTrainer")
                .multilineTextAlignment(.center)
            HStack {
                Text("Home Excercise For Everyone")
                Text("Version 1.0")
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

#endif
