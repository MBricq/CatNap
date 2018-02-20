//
//  HookBaseNode.swift
//  CatNap
//
//  Created by Marin on 19/02/2018.
//  Copyright © 2018 Marin. All rights reserved.
//

import SpriteKit

class HookBaseNode: SKSpriteNode, EventListenerNode {
    private var hookNode = SKSpriteNode(imageNamed: "hook")
    private var ropeNode = SKSpriteNode(imageNamed: "rope")
    private var hookJoint: SKPhysicsJointFixed!
    
    var isHooked: Bool {
        return hookJoint != nil
    }
    
    func didMoveToScene() {
        // make sure the node has been added to the scene
        guard let scene = scene else {
            return
        }
        
        // add the joint between the ceiling and the hookBase
        let ceilingFix = SKPhysicsJointFixed.joint(withBodyA: scene.physicsBody!, bodyB: physicsBody!, anchor: position)
        scene.physicsWorld.add(ceilingFix)
        
        // add the rope on the scene
        ropeNode.anchorPoint = CGPoint(x: 0, y: 0.5)
        ropeNode.zRotation = CGFloat(270).degreesToRadians()
        ropeNode.position = position
        scene.addChild(ropeNode)
        
        // add the hook itself
        hookNode.position = CGPoint(x: position.x, y: position.y - ropeNode.size.width)
        hookNode.physicsBody = SKPhysicsBody(circleOfRadius: hookNode.size.width/2)
        hookNode.physicsBody?.categoryBitMask = PhysicsCategory.Hook
        hookNode.physicsBody?.contactTestBitMask = PhysicsCategory.Cat
        hookNode.physicsBody?.collisionBitMask = PhysicsCategory.None
        scene.addChild(hookNode)
        
        // connect the hook to its base
        let hookPosition = CGPoint(x: hookNode.position.x, y: hookNode.position.y + hookNode.size.height/2)
        let ropeJoint = SKPhysicsJointSpring.joint(withBodyA: physicsBody!, bodyB: hookNode.physicsBody!, anchorA: position, anchorB: hookPosition)
        scene.physicsWorld.add(ropeJoint)
        
        // make sure the rope is always in the direction of the hook
        let range = SKRange(lowerLimit: 0, upperLimit: 0)
        let orientConstraint = SKConstraint.orient(to: hookNode, offset: range)
        ropeNode.constraints = [orientConstraint]
                
        // make the hook swing
        hookNode.physicsBody?.applyImpulse(CGVector(dx: 30, dy: 0))
        
        // listen to the cat notification
        NotificationCenter.default.addObserver(self, selector: #selector(catTapped), name: NSNotification.Name(CatNode.kCatTappedNotification), object: nil)
    }
    
    func hookCat(catPhysicsBody: SKPhysicsBody) {
                
        catPhysicsBody.velocity = CGVector(dx: 0, dy: 0)
        catPhysicsBody.angularVelocity = 0
        
        let pinPoint = CGPoint(x: hookNode.position.x, y: hookNode.position.y + hookNode.size.height/2)
        hookJoint = SKPhysicsJointFixed.joint(withBodyA: hookNode.physicsBody!, bodyB: catPhysicsBody, anchor: pinPoint)
        scene?.physicsWorld.add(hookJoint)
        
        hookNode.physicsBody?.contactTestBitMask = PhysicsCategory.None
    }
    
    @objc func catTapped() {
        if isHooked {
            releaseCat()
        }
    }
    
    func releaseCat() {
        
        hookNode.physicsBody?.categoryBitMask = PhysicsCategory.None
        hookNode.physicsBody?.collisionBitMask = PhysicsCategory.None
        
        hookJoint.bodyA.node!.zRotation = 0
        hookJoint.bodyB.node!.zRotation = 0
        
        scene?.physicsWorld.remove(hookJoint)
        hookJoint = nil
    }
}
