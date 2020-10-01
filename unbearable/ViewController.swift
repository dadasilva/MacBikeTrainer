//
//  ViewController.swift
//  unbearable
//
//  Created by David Da Silva on 9/19/20.
//  Copyright © 2020 David Da Silva. All rights reserved.
//

import Cocoa
import SpriteKit
import GameplayKit
import CoreBluetooth

class ViewController: NSViewController, NSTextFieldDelegate {

    @IBOutlet var skView: SKView!
    @IBOutlet weak var powerLabel: NSTextField!
    @IBOutlet weak var dataLabel: NSTextField!
    @IBOutlet weak var heartRateLabel: NSTextField!
    
    var bikeTrainerPeripheral: CBPeripheral!
    var centralManager: CBCentralManager!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        powerLabel.delegate = self
        dataLabel.delegate = self
        centralManager = CBCentralManager(delegate: self, queue: nil)
        
//        let timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fire), userInfo: nil, repeats: true)
    
        if let view = self.skView {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                // Present the scene
                view.presentScene(scene)
                //Insert data to scene
            }
            
            
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
        
    }
//    @objc func fire() {
//        print("FIRE!")
//    }
}


