//
//  GameScene.swift
//  JumperClone
//
//  Created by Kendrew Chan on 5/12/17.
//  Copyright © 2017 KCStudios. All rights reserved.
//

import SpriteKit
import CoreMotion //for using motion with phone?

class GameScene: SKScene {
    
    var background: SKNode!
    var midground: SKNode!
    var foreground: SKNode!
    
    var hud: SKNode!
    
    var player: SKNode!
    
    var scaleFactor: CGFloat!
    
    var startButton = SKSpriteNode(imageNamed: "TapToStart")
    
    var endOfGamePosition = 0
    
    let motionManager = CMMotionManager()
    
    var xAcceleration: CGFloat = 0.0
    
    var scoreLabel: SKLabelNode!
    var flowerLabel: SKLabelNode!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        backgroundColor = SKColor.white
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
    }
}
