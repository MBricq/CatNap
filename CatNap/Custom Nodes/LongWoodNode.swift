//
//  LongWoodNode.swift
//  CatNap
//
//  Created by Marin on 22/02/2018.
//  Copyright © 2018 Marin. All rights reserved.
//

import SpriteKit

class LongWoodNode: SKSpriteNode, EventListenerNode, InteractiveNode {
    
    func didMoveToScene() {
        guard let scene = scene else {
            return
        }
        
        if parent == scene {
            scene.addChild(LongWoodNode.makeCompound(in: scene))
        }
    }
    
    func interact() {
        isUserInteractionEnabled = false
        let playMusic = SKAction.playSoundFileNamed("pop.mp3", waitForCompletion: false)
        let disappear = SKAction.removeFromParent()
        run(SKAction.sequence([playMusic, disappear]))
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        interact()
    }
    
    static func makeCompound(in scene: SKScene) -> SKNode {
        let compound = LongWoodNode()
        
        // goes through all the children of the scene and run the function only for the StoneNode
        for wood in scene.children.filter({node in node is LongWoodNode}) {
            wood.removeFromParent()
            compound.addChild(wood)
        }
        
        // create a physic body for each stone and store them in bodies
        let bodies = compound.children.map({node in SKPhysicsBody(rectangleOf: node.frame.size, center: node.position)})
        
        // changes the compund's physics body to an union of all the bodies in bodies
        compound.physicsBody = SKPhysicsBody(bodies: bodies)
        compound.physicsBody?.categoryBitMask = PhysicsCategory.Block
        compound.physicsBody?.collisionBitMask = PhysicsCategory.Cat | PhysicsCategory.Edge | PhysicsCategory.Block
        compound.isUserInteractionEnabled = true
        compound.zPosition = 1
        
        return compound
    }
}
