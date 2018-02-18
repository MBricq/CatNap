//
//  GameScene.swift
//  CatNap
//
//  Created by Marin on 16/02/2018.
//  Copyright © 2018 Marin. All rights reserved.
//

import SpriteKit
import GameplayKit

protocol EventListenerNode {
    func didMoveToScene()
}

class GameScene: SKScene {
    
    // MARK : variables of the nodes
    var bedNode: BedNode!
    var catNode: CatNode!
    
    override func didMove(to view: SKView) {
        // calculate the playable area for all devices and set it up as the edge of the scene
        let maxAspectRatio : CGFloat = 16/9
        let maxAspectRatioHeight = size.width / maxAspectRatio
        let playableMargin : CGFloat = (size.height - maxAspectRatioHeight) / 2
        let playableRect = CGRect(x: 0, y: playableMargin, width: size.width, height: size.height - 2*playableMargin)
        physicsBody = SKPhysicsBody(edgeLoopFrom: playableRect)
        
        // call the didMoveToScene() of all the nodes with the EventListenerNode protocol
        enumerateChildNodes(withName: "//*") { (node, _) in
            if let eventNode = node as? EventListenerNode {
                eventNode.didMoveToScene()
            }
        }
        
        // search "bed" through all the nodes of the scene
        bedNode = childNode(withName: "bed") as! BedNode
        // search "cat_body" through all the nodes of the scene and their children
        catNode = childNode(withName: "//cat_body") as! CatNode
        
        //let reference = childNode(withName: "cat_shared") as! SKReferenceNode
    }
}
