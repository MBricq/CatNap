//
//  BlockNode.swift
//  CatNap
//
//  Created by Marin on 18/02/2018.
//  Copyright © 2018 Marin. All rights reserved.
//

import SpriteKit

class BlockNode: SKSpriteNode, EventListenerNode, InteractiveNode {
    func didMoveToScene() {
        isUserInteractionEnabled = true
    }
    
    func interact() {
        isUserInteractionEnabled = false
        let playMusic = SKAction.playSoundFileNamed("pop.mp3", waitForCompletion: false)
        let scale = SKAction.scale(to: 0.8, duration: 0.1)
        let disappear = SKAction.removeFromParent()
        run(SKAction.sequence([playMusic, scale, disappear]))
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        print("destroy block")
        interact()
    }
}
