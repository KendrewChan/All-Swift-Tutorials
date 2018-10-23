//
//  GameScene.swift
//  Bamboo Breakout
/**
 * Copyright (c) 2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */ 

import SpriteKit

let BallCategoryName = "ball"
let PaddleCategoryName = "paddle"
let BlockCategoryName = "block"
let GameMessageName = "gameMessage"
var isFingerOnPaddle = false

class GameScene: SKScene {
  
  override func didMove(to view: SKView) {
    super.didMove(to: view)
    
    physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0) //removes all gravity from the scene
    
    let ball = childNode(withName: "ball") as! SKSpriteNode
    ball.physicsBody!.applyImpulse(CGVector(dx: 2.0, dy: -2.0))
    
    let borderBody = SKPhysicsBody(edgeLoopFrom: self.frame) //border collider around the scene's frame, edge-based body that has no mass or volume and is unaffected by forces or impulses/momentum
    
    borderBody.friction = 0 //frame body has no friction
    
    self.physicsBody = borderBody //sets the GameScene's physicsBody as the borderBody
  }

    
    /////////// 3 step process to touching with finger
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first //first touch
        let touchLocation = touch!.location(in: self)
        
        if let body = physicsWorld.body(at: touchLocation) {
            if body.node!.name == "paddle" {
                print("Began touch on paddle")
                isFingerOnPaddle = true
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isFingerOnPaddle {
            // Updates position of the paddle depending on player's finger
            let touch = touches.first
            let touchLocation = touch!.location(in: self)
            let previousLocation = touch!.previousLocation(in: self)
            
            let paddle = childNode(withName: "paddle") as! SKSpriteNode //gets the SKSpriteNode
            
            // Take the current paddle position and add the difference between the new and the previous touch locations
            var paddleX = paddle.position.x + (touchLocation.x - previousLocation.x) // (paddle position) + (distance between tocuh and paddle)
            
            //limits the paddle to prevent it from going off the screen
            paddleX = max(paddleX, paddle.size.width/2)
            paddleX = min(paddleX, size.width - paddle.size.width/2)
            
            //sets paddle's position to the one calculate above
            paddle.position = CGPoint(x: paddleX, y: paddle.position.y)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isFingerOnPaddle = false
    }
    /////////// 3 step process to touching with finger
    
}
