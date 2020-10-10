//
//  SessionDelegate.swift
//  MacBikeTrainer
//
//  Created by David Da Silva on 10/9/20.
//  Copyright © 2020 David Da Silva. All rights reserved.
//

import SwiftUI

struct SessionDelegate {
    var body: some View {
        NavigationView {
            Text("Hello, World!")
                .navigationBarTitle(Text("Sessions"))
        }
    }
}

struct SessionDelegate_Previews: PreviewProvider {
    static var previews: some View {
        SessionDelegate()
    }
}
