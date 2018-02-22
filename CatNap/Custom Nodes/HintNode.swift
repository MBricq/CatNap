//
//  HintNode.swift
//  CatNap
//
//  Created by Marin on 22/02/2018.
//  Copyright © 2018 Marin. All rights reserved.
//

import SpriteKit

class HintNode: SKSpriteNode, EventListenerNode {
    
    var arrowPath: CGPath = {
        let bezierPath = UIBezierPath()
        
        bezierPath.move(to: CGPoint(x: 0.5, y: 65.69))
        bezierPath.addLine(to: CGPoint(x: 74.99, y: 1.5))
        bezierPath.addLine(to: CGPoint(x: 74.99, y: 38.66))
        bezierPath.addLine(to: CGPoint(x: 257.5, y: 38.66))
        bezierPath.addLine(to: CGPoint(x: 257.5, y: 92.72))
        bezierPath.addLine(to: CGPoint(x: 74.99, y: 92.72))
        bezierPath.addLine(to: CGPoint(x: 74.99, y: 126.5))
        bezierPath.addLine(to: CGPoint(x: 0.5, y: 65.69))
        bezierPath.close()
        
        return bezierPath.cgPath
    }()
    
    func didMoveToScene() {
        color = SKColor.clear
        
        let shape = SKShapeNode(path: arrowPath)
        shape.fillColor = SKColor.white
        shape.fillTexture = SKTexture(imageNamed: "wood_tinted")
        shape.alpha = 0.8
        addChild(shape)
        
        let move = SKAction.moveBy(x: -30, y: 0, duration: 0.4)
        let bounce = SKAction.sequence([move, move.reversed()])
        let bounceAction = SKAction.repeat(bounce, count: 3)
        run(bounceAction, completion: {self.removeFromParent()})
        
    }
}
