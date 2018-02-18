//
//  BedNode.swift
//  CatNap
//
//  Created by Marin on 18/02/2018.
//  Copyright © 2018 Marin. All rights reserved.
//

import SpriteKit

class BedNode: SKSpriteNode, EventListenerNode {
    func didMoveToScene() {
        print("Bed added")
        let bodySize = CGSize(width: 40, height: 30)
        physicsBody = SKPhysicsBody(rectangleOf: bodySize)
        physicsBody?.isDynamic = false
    }
}
