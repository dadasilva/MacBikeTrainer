//
//  Session.swift
//  MacBikeTrainer
//
//  Created by David Da Silva on 10/9/20.
//  Copyright © 2020 David Da Silva. All rights reserved.
//

import Foundation

struct Session: Identifiable {
    var id = UUID() //requirement
    var name: String
    var percentComplete: Int
}

let testData = [
    Session(name: "Beginner", percentComplete: 100),
    Session(name: "Straight Run", percentComplete: 50),
    Session(name: "Hard",  percentComplete: 0),
    Session(name: "Beginner", percentComplete: 0),
    Session(name: "Straight Run", percentComplete: 50),
    Session(name: "Hard",  percentComplete: 0),
    Session(name: "Beginner", percentComplete: 100),
    Session(name: "Straight Run", percentComplete: 50),
    Session(name: "Hard",  percentComplete: 0),
    Session(name: "Beginner", percentComplete: 100),
    Session(name: "Straight Run", percentComplete: 50),
    Session(name: "Hard",  percentComplete: 2),
    Session(name: "Death Hill",  percentComplete: 40)
]
