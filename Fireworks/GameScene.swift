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

    // MARK: - for case let comes in: it lets us attempts some work (typecasting to SKSpriteNode in this case), and run the loop body only for items that were successfully typecast.
    // MARK: - The let node part creates a new constant called node, the case…as SKSpriteNode part means “if we can typecast this item as a sprite node, and of course the for loop is the loop itself.
    
    override func didMove(to view: SKView) {
        addChild(background())
        
        gameTimer = Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(launchFireworks), userInfo: nil, repeats: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        checkTouches(touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        checkTouches(touches)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // reversed(): Return reverse order.
        for (index, firework) in fireworks.enumerated().reversed() {
            if firework.position.y > 900 {
                // this uses a position high above so that rockets can explode off screen
                fireworks.remove(at: index)
                firework.removeFromParent()
            }
        }
    }
    
    func background() -> SKSpriteNode {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.zPosition = -1
        // background.blendMode = .replace
        return background
    }
    
    func checkTouches(_ touches: Set<UITouch>) {
        // get 1st touch
        guard let touch = touches.first else { return }
        
        // take nodes in touch location
        let location = touch.location(in: self)
        /** @types: nodesAtPoint: [node] */
        let nodesAtPoint = nodes(at: location)
        
        // loop
        for case let node as SKSpriteNode in nodesAtPoint {
            guard node.name == "firework" else { continue }
            
            // another loop to check color is same
            for parent in fireworks {
                guard let firework = parent.children.first as? SKSpriteNode else { continue }
                
                if firework.name == "firework" && firework.color != node.color {
                    firework.name = "firework"
                            firework.colorBlendFactor = 1
                }
            }
            
            node.name = "selected"
            node.colorBlendFactor = 0   // colorBlendFactor value to 0. That will disable the color blending entirely, making the firework white.
        }
        
    }
    
    func createFirework(xMovement: CGFloat, x: Int, y: Int) {
        /// 1: Create a Node ( Container to contain firework)
        /// 2: Setup firework and put into the container (colorBlendFactor: A floating-point value that describes how the color is blended with the sprite’s texture. )
        /// 3: Set color to firework
        /// 4: Drawn a path movement
        /// 5: Node will follow to the path
        /// 6: Add fuse effect to node
        /// 7: AddChild
        
        // 1
        let node = SKNode()
        node.position = CGPoint(x: x, y: y)
        
        // 2
        let firework = SKSpriteNode(imageNamed: "rocket")
        firework.colorBlendFactor = 1
        firework.name = "firework"
        node.addChild(firework)
        
        // 3
        switch Int.random(in: 0...2) {
        case 0:
            firework.color = .cyan
        case 1:
            firework.color = .green
        case 2:
            firework.color = .red
        default:
            break
        }
        
        // 4
        let path = UIBezierPath()
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: xMovement, y: 1000))
        
        // 5
        let move = SKAction.follow(path.cgPath, asOffset: true, orientToPath: true, speed: 200)
        node.run(move)
        
        // 6
        if let emitter = SKEmitterNode(fileNamed: "fuse") {
            emitter.position = CGPoint(x: 0, y: -22)
            node.addChild(emitter)
        }
        
        // 7
        fireworks.append(node)
        addChild(node)
    }
    
    func explode(firework: SKNode) {
        if let emitter = SKEmitterNode(fileNamed: "explode") {
            emitter.position = firework.position
            addChild(emitter)
        }
        
        firework.removeFromParent()
    }
    
    func explodeFireworks() {
        var numExploded = 0

        for (index, fireworkContainer) in fireworks.enumerated().reversed() {
            guard let firework = fireworkContainer.children.first as? SKSpriteNode else { continue }

            if firework.name == "selected" {
                // destroy this firework!
                explode(firework: fireworkContainer)
                fireworks.remove(at: index)
                numExploded += 1
            }
        }

        switch numExploded {
        case 0:
            // nothing – rubbish!
            break
        case 1:
            scores += 200
        case 2:
            scores += 500
        case 3:
            scores += 1500
        case 4:
            scores += 2500
        default:
            scores += 4000
        }
    }
    
    @objc func launchFireworks() {
        /// UIBezierPath: A path that consists of straight and curved line segments that you can render in your custom views.
        
        let movementAmount: CGFloat = 1800
        
        switch Int.random(in: 0...3) {
        case 0:
            // fire five, straight up
            createFirework(xMovement: 0, x: 512, y: bottomEdge)
            createFirework(xMovement: 0, x: 512 - 200, y: bottomEdge)
            createFirework(xMovement: 0, x: 512 - 100, y: bottomEdge)
            createFirework(xMovement: 0, x: 512 + 100, y: bottomEdge)
            createFirework(xMovement: 0, x: 512 + 200, y: bottomEdge)
            
        case 1:
            // fire five, in a fan
            createFirework(xMovement: 0, x: 512, y: bottomEdge)
            createFirework(xMovement: -200, x: 512 - 200, y: bottomEdge)
            createFirework(xMovement: -100, x: 512 - 100, y: bottomEdge)
            createFirework(xMovement: 100, x: 512 + 100, y: bottomEdge)
            createFirework(xMovement: 200, x: 512 + 200, y: bottomEdge)
            
        case 2:
            // fire five, from the left to the right
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 400)
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 300)
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 200)
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 100)
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge)
            
        case 3:
            // fire five, from the right to the left
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 400)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 300)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 200)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 100)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge)
            
        default:
            break
        }
    }
}
