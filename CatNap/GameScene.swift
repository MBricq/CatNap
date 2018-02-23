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
    static let None: UInt32 = 0b0        // 0
    static let Cat: UInt32 = 0b1         // 1
    static let Block: UInt32 = 0b10      // 2
    static let Bed: UInt32 = 0b100       // 4
    static let Edge: UInt32 = 0b1000     // 8
    static let Label: UInt32 = 0b10000   // 16
    static let Spring: UInt32 = 0b100000 // 32
    static let Hook: UInt32 = 0b1000000  // 64
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // MARK : variables of the nodes
    var bedNode: BedNode!
    var catNode: CatNode!
    var hookBaseNode: HookBaseNode?
    var isTheScenePlayable = true
    var currentLevel: Int = 0
    
    // this function is a factory method, it allows it to be used as a constructor of a non existing class
    class func level(levelNum: Int) -> GameScene? {
        let scene = GameScene(fileNamed: "Level\(levelNum)")!
        scene.currentLevel = levelNum
        scene.scaleMode = .aspectFill
        return scene
    }
    
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
        bedNode = childNode(withName: "bed") as? BedNode
        // search "cat_body" through all the nodes of the scene and their children
        catNode = childNode(withName: "//cat_body") as? CatNode
        hookBaseNode = childNode(withName: "hookBase") as? HookBaseNode
        
        // play the music
        SKTAudio.sharedInstance().playBackgroundMusic("backgroundMusic.mp3")
    }
    
    override func didSimulatePhysics() {
        if isTheScenePlayable && hookBaseNode?.isHooked != true {
            if abs(catNode.parent!.zRotation) > CGFloat(35).degreesToRadians() {
                lose()
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if collision == PhysicsCategory.Edge | PhysicsCategory.Label {
            
            // this is a test such as they are in C++ : it tests if the bodyA is the label, if it is then labelNode is equal to contact.bodyA.node, otherwise it is contact.bodyB.node
            // eitherway the label is then casts as a MessageNode and it calls its function didBounce()
            let labelNode = (contact.bodyA.categoryBitMask == PhysicsCategory.Label ? contact.bodyA.node : contact.bodyB.node) as! MessageNode
            labelNode.didBounce()
            
        } else if isTheScenePlayable {
            
            if collision == PhysicsCategory.Cat | PhysicsCategory.Bed {
                print("You win!")
                win()
            } else if collision == PhysicsCategory.Cat | PhysicsCategory.Edge {
                print("FAIL!")
                lose()
            } else if collision == PhysicsCategory.Cat | PhysicsCategory.Hook && hookBaseNode?.isHooked == false {
                hookBaseNode?.hookCat(catPhysicsBody: catNode.parent!.physicsBody!)
            }
        }
    }
    
    func inGameMessage(text: String, color: UIColor) {
        let message = MessageNode(message: text, color: color)
        message.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(message)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        print(currentLevel)
        if currentLevel == 0 {
            currentLevel = 1
            newGame()
        }
    }
    
    func newGame() {
        if currentLevel == 7 {
            let scene = GameScene(fileNamed: "GameOver")
            scene?.scaleMode = scaleMode
            view?.presentScene(scene)
        } else {
            let scene = GameScene.level(levelNum: currentLevel)
            scene?.scaleMode = scaleMode
            view?.presentScene(scene)
        }
    }
    
    func win() {
        
        if currentLevel < 7 {
            currentLevel += 1
        }
        
        isTheScenePlayable = false
        
        catNode.curlAt(onlyToYOfPoint: bedNode.position)
        
        SKTAudio.sharedInstance().pauseBackgroundMusic()
        SKTAudio.sharedInstance().playSoundEffect("win.mp3")
        
        inGameMessage(text: "Nice!", color: UIColor.cyan)
        
        run(SKAction.afterDelay(4, runBlock: newGame))
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
