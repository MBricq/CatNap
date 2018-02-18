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
        print("Cat added")
        let catBodyTexture = SKTexture(imageNamed: "cat_body_outline")
        parent?.physicsBody = SKPhysicsBody(texture: catBodyTexture, size: catBodyTexture.size())
    }
    
}
