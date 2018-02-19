//
//  MessageNode.swift
//  CatNap
//
//  Created by Marin on 18/02/2018.
//  Copyright © 2018 Marin. All rights reserved.
//

import SpriteKit

class MessageNode: SKLabelNode {
    var bouncesCount: Int = 0
    
    convenience init(message: String, color: UIColor) {
        self.init(fontNamed: "AvenirNext-Regular")
        
        text = message
        fontSize = 256
        fontColor = SKColor.gray
        zPosition = 100
        
        let front = SKLabelNode(fontNamed: "AvenirNext-Regular")
        front.text = message
        front.fontSize = 256
        front.fontColor = color
        front.position = CGPoint(x: -2, y: -2)
        addChild(front)
        
        physicsBody = SKPhysicsBody(circleOfRadius: 10)
        physicsBody?.categoryBitMask = PhysicsCategory.Label
        physicsBody?.collisionBitMask = PhysicsCategory.Edge
        physicsBody?.contactTestBitMask = PhysicsCategory.Edge
        physicsBody?.restitution = 0.7
    }
    
    func didBounce() {
        bouncesCount += 1
        if bouncesCount == 3 {
            run(SKAction.removeFromParent())
        }
    }
}
