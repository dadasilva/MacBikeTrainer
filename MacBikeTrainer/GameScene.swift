//
//  GameScene.swift
//  unbearable
//
//  Created by David Da Silva on 9/19/20.
//  Copyright © 2020 David Da Silva. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    private var jakeNode : SKSpriteNode?
    
    
    override func didMove(to view: SKView) {
        
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        // Create shape node to use during mouse interaction
        let jakeTexture = SKTextureAtlas(named: "jake")
        let f1 = jakeTexture.textureNamed("jake1")
        let f2 = jakeTexture.textureNamed("jake2")
        let f3 = jakeTexture.textureNamed("jake3")
        let f4 = jakeTexture.textureNamed("jake4")
        let jake = [f1, f2, f3, f4]
        self.jakeNode = SKSpriteNode.init(texture: jake[0])
          
        if let sprite = self.jakeNode {
            let movebike = SKAction.animate(with: jake, timePerFrame: 0.08)
            sprite.setScale(0.5)
            self.addChild(sprite)
            sprite.run(SKAction.repeatForever(movebike))
            sprite.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            sprite.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                                SKAction.fadeOut(withDuration: 0.5),
                                                SKAction.removeFromParent()]))
        }
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.jakeNode?.copy() as! SKSpriteNode? {
            n.position = pos
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.jakeNode?.copy() as! SKSpriteNode? {
            n.position = pos
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.jakeNode?.copy() as! SKSpriteNode? {
            n.position = pos
            self.addChild(n)
        }
    }
    
    override func mouseDown(with event: NSEvent) {
        self.touchDown(atPoint: event.location(in: self))
    }
    
    override func mouseDragged(with event: NSEvent) {
        self.touchMoved(toPoint: event.location(in: self))
    }
    
    override func mouseUp(with event: NSEvent) {
        self.touchUp(atPoint: event.location(in: self))
    }
    
    override func keyDown(with event: NSEvent) {
        
        let jakeTexture = SKTextureAtlas(named: "jake")
        let f1 = jakeTexture.textureNamed("jake1")
        let f2 = jakeTexture.textureNamed("jake2")
        let f3 = jakeTexture.textureNamed("jake3")
        let f4 = jakeTexture.textureNamed("jake4")
        let jake = [f1, f2, f3, f4]
        
        switch event.keyCode {
        case 0x31:
            let sprite = SKSpriteNode(texture: jake[0])
            let movebike = SKAction.animate(with: jake, timePerFrame: 0.08)
            sprite.position = CGPoint(x: 150, y: 100)
            sprite.setScale(0.5)
            self.addChild(sprite)
            sprite.run(SKAction.repeatForever(movebike))
        default:
            print("keyDown: \(event.characters!) keyCode: \(event.keyCode)")
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
