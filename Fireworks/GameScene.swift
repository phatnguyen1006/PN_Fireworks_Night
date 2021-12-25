//
//  GameScene.swift
//  Fireworks
//
//  Created by Phat Nguyen on 25/12/2021.
//

import SpriteKit

class GameScene: SKScene {
    var gameTimer: Timer?
    var fireworks = [SKNode]()
    
    let leftEdge = -22
    let bottomEdge = -22
    let rightEdge = 1024 + 22
    
    var scores = 0 {
        didSet {
            // update some nodes
            
        }
    }
    
    override func didMove(to view: SKView) {
        addChild(background())
        
        gameTimer = Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(launchFireworks), userInfo: nil, repeats: true)
    }
    
    func background() -> SKSpriteNode {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.zPosition = -1
        // background.blendMode = .replace
        return background
    }
    
    @objc func launchFireworks() {
        /// UIBezierPath: A path that consists of straight and curved line segments that you can render in your custom views.
        
        
        
        
    }
}
