//
//  GameScene.swift
//  CatNap
//
//  Created by Marin on 16/02/2018.
//  Copyright © 2018 Marin. All rights reserved.
//

import SpriteKit
import GameplayKit

// this protocol is used to make a call to a function in the tagged node when it's added to the scene
protocol EventListenerNode {
    func didMoveToScene()
}

// this protocol is used to flag a node as touchable
protocol InteractiveNode {
    func interact()
}

struct PhysicsCategory {
    static let None: UInt32 = 0b0      // 0
    static let Cat: UInt32 = 0b1       // 1
    static let Block: UInt32 = 0b10    // 2
    static let Bed: UInt32 = 0b100     // 4
    static let Edge: UInt32 = 0b1000   // 8
    static let Label: UInt32 = 0b10000 // 16
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // MARK : variables of the nodes
    var bedNode: BedNode!
    var catNode: CatNode!
    var isTheScenePlayable = true
    
    override func didMove(to view: SKView) {
        
        // calculate the playable area for all devices and set it up as the edge of the scene
        let maxAspectRatio : CGFloat = 16/9
        let maxAspectRatioHeight = size.width / maxAspectRatio
        let playableMargin : CGFloat = (size.height - maxAspectRatioHeight) / 2
        let playableRect = CGRect(x: 0, y: playableMargin, width: size.width, height: size.height - 2*playableMargin)
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: playableRect)
        physicsWorld.contactDelegate = self
        physicsBody?.categoryBitMask = PhysicsCategory.Edge
        
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
        
        // play the music
        SKTAudio.sharedInstance().playBackgroundMusic("backgroundMusic.mp3")
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if isTheScenePlayable {
            let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
            
            if collision == PhysicsCategory.Cat | PhysicsCategory.Bed {
                print("You win!")
                win()
                
            } else if collision == PhysicsCategory.Cat | PhysicsCategory.Edge {
                print("FAIL!")
                lose()
            }
        }
    }
    
    func inGameMessage(text: String, color: UIColor) {
        let message = MessageNode(message: text, color: color)
        message.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(message)
    }
    
    func newGame() {
        let scene = GameScene(fileNamed: "GameScene")
        scene?.scaleMode = scaleMode
        view?.presentScene(scene)
    }
    
    func win() {
        isTheScenePlayable = false
        
        catNode.curlAt(onlyToYOfPoint: bedNode.position)
        
        SKTAudio.sharedInstance().pauseBackgroundMusic()
        SKTAudio.sharedInstance().playSoundEffect("win.mp3")
        
        inGameMessage(text: "Nice!", color: UIColor.cyan)
        
        run(SKAction.afterDelay(3, runBlock: newGame))
    }
    
    func lose() {
        isTheScenePlayable = false
        
        catNode.wakeUp()
        
        SKTAudio.sharedInstance().pauseBackgroundMusic()
        SKTAudio.sharedInstance().playSoundEffect("lose.mp3")
        
        inGameMessage(text: "Try again...", color: UIColor.red)
        
        run(SKAction.afterDelay(5, runBlock: newGame))
    }
}
