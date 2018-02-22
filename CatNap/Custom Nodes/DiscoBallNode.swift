//
//  DiscoBallNode.swift
//  CatNap
//
//  Created by Marin on 22/02/2018.
//  Copyright © 2018 Marin. All rights reserved.
//

import SpriteKit
import AVFoundation

class DiscoBallNode: SKSpriteNode, EventListenerNode, InteractiveNode {
    
    private var player: AVPlayer!
    private var video: SKVideoNode!
    
    private let spinAction = SKAction.repeatForever(SKAction.animate(with: [
        SKTexture(imageNamed: "discoball1"),
        SKTexture(imageNamed: "discoball2"),
        SKTexture(imageNamed: "discoball3")
        ], timePerFrame: 0.2))
    
    private var isDiscoTime: Bool = false {
        didSet {
            video.isHidden = !isDiscoTime
            SKTAudio.sharedInstance().playBackgroundMusic(isDiscoTime ? "disco-sound.m4a" : "backgroundMusic.mp3")
            
            if isDiscoTime {
                video.play()
                run(spinAction)
                video.run(SKAction.wait(forDuration: 4.2), completion: {self.isDiscoTime = false})
            } else {
                video.pause()
                removeAllActions()
            }
            
            DiscoBallNode.isDiscoTime = isDiscoTime
        }
    }
    // this line makes it available from other files
    static private(set) var isDiscoTime = false
    
    func didMoveToScene() {
        isUserInteractionEnabled = true
        
        let fileURL = Bundle.main.url(forResource: "discolights-loop", withExtension: "mov")!
        player = AVPlayer(url: fileURL)
        video = SKVideoNode(avPlayer: player)
        
        video.size = scene!.size
        video.position = CGPoint(x: scene!.frame.midX, y: scene!.frame.midY)
        video.zPosition = -1
        video.alpha = 0.75
        scene?.addChild(video)
        
        video.isHidden = true
        video.pause()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didReachEndOfVideo), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    func interact() {
        if !isDiscoTime {
            isDiscoTime = true
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        interact()
    }
    
    @objc func didReachEndOfVideo() {
        print("rewind!")
        player.currentItem?.seek(to: kCMTimeZero, completionHandler: { [weak self]_ in
            self?.player.play()
        })
    }
}
