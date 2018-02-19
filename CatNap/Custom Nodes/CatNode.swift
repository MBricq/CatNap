//
//  CatNode.swift
//  CatNap
//
//  Created by Marin on 18/02/2018.
//  Copyright © 2018 Marin. All rights reserved.
//

import SpriteKit

class CatNode: SKSpriteNode, EventListenerNode {
    
    func didMoveToScene() {
        // this shouldn't be necessary but there is a bug with the current version of XCode
        isPaused = false
        
        print("Cat added")
        let catBodyTexture = SKTexture(imageNamed: "cat_body_outline")
        parent?.physicsBody = SKPhysicsBody(texture: catBodyTexture, size: catBodyTexture.size())
        parent?.physicsBody?.categoryBitMask = PhysicsCategory.Cat
        parent?.physicsBody?.collisionBitMask = PhysicsCategory.Block | PhysicsCategory.Edge
        parent?.physicsBody?.contactTestBitMask = PhysicsCategory.Edge | PhysicsCategory.Bed
    }
    
    func wakeUp() {
        for child in children {
            child.removeFromParent()
        }
        texture = nil
        color = SKColor.clear
        
        let catAwake = SKSpriteNode(fileNamed: "CatWakeUp")?.childNode(withName: "cat_awake")
        
        catAwake?.move(toParent: self)
        catAwake?.position = CGPoint(x: -30, y: 100)
        
        // this shouldn't be necessary but there is a bug with the current version of XCode
        catAwake?.isPaused = false
    }
    
    private func curlAt(scenePoint: CGPoint, xChange: Bool, yChange: Bool) {
        parent?.physicsBody = nil
        for child in children {
            child.removeFromParent()
        }
        texture = nil
        color = SKColor.clear
        
        let catCurl = SKSpriteNode(fileNamed: "CatCurls")?.childNode(withName: "cat_curl")
        catCurl?.move(toParent: self)
        catCurl?.position = CGPoint(x: -30, y: 100)
        
        var locationPoint = convert(scenePoint, from: scene!)
        locationPoint.y -= frame.size.height/3
        
        if (xChange && yChange) {
            run(SKAction.group([SKAction.move(to: locationPoint, duration: 0.66),
                                SKAction.rotate(toAngle: -parent!.zRotation, duration: 0.5)
                                ])
            )
        } else if (!xChange && yChange) {
            run(SKAction.group([SKAction.moveTo(y: locationPoint.y, duration: 0.66),
                                SKAction.rotate(toAngle: -parent!.zRotation, duration: 0.5)
                ])
            )
        } else if (xChange && !yChange) {
            run(SKAction.group([SKAction.moveTo(x: locationPoint.x, duration: 0.66),
                                SKAction.rotate(toAngle: -parent!.zRotation, duration: 0.5)
                ])
            )
        }
        // this shouldn't be necessary but there is a bug with the current version of XCode
        catCurl?.isPaused = false
    }
    
    func curlAt(scenePoint: CGPoint) {
        curlAt(scenePoint: scenePoint, xChange: true, yChange: true)
    }
    
    func curlAt(onlyToXOfPoint: CGPoint) {
        curlAt(scenePoint: onlyToXOfPoint, xChange: true, yChange: false)
    }
    
    func curlAt(onlyToYOfPoint: CGPoint) {
        curlAt(scenePoint: onlyToYOfPoint, xChange: false, yChange: true)
    }
}
