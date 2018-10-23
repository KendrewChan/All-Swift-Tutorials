//
//  GameScene.swift
//  SKTestGame
//
//  Created by Kendrew Chan on 5/12/17.
//  Copyright © 2017 KCStudios. All rights reserved.
//

import SpriteKit


func + (left: CGPoint, right: CGPoint) -> CGPoint {     //These are standard implementations of some vector math functions
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

func / (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

#if !(arch(x86_64) || arch(arm64))
    func sqrt(a: CGFloat) -> CGFloat {
        return CGFloat(sqrtf(Float(a)))
    }
#endif

extension CGPoint {
    func length() -> CGFloat {
        return sqrt(x*x + y*y)
    }
    
    func normalized() -> CGPoint {
        return self / length()
    }
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    struct PhysicsCategory {            // setting up the constants for the physics categories you'll need
        static let None      : UInt32 = 0
        static let All       : UInt32 = UInt32.max
        static let Monster   : UInt32 = 0b1       // 1
        static let Projectile: UInt32 = 0b10      // 2
    }
    
    let player = SKSpriteNode(imageNamed: "player")
    var monstersDestroyed = 0
    
    override func didMove(to view: SKView) {
        
        // 2
        backgroundColor = SKColor.white
        // 3
        player.position = CGPoint(x: size.width * 0.1, y: size.height * 0.5) //You position the sprite to be 10% across vertically, 
                                                                            //and centered horizontally.
        // 4
        addChild(player) //To make the sprite appear on the scene, you must add it as a child of the scene. This is similar to how   
                        //you make views children of other views.
        physicsWorld.gravity = CGVector.zero //gravity = 0
        physicsWorld.contactDelegate = self //sets the scene as the delegate to be notified when two physics bodies collide
        
        run(SKAction.repeatForever( //call the method to create monsters that continuously spawn over time
            SKAction.sequence([
                SKAction.run(addMonster),
                SKAction.wait(forDuration: 1.0) //every 1 second 1 monster spawn
                ])
        ))
        
        let backgroundMusic = SKAudioNode(fileNamed: "background-music-aac.caf")
        backgroundMusic.autoplayLooped = true
        addChild(backgroundMusic)
    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat { //input of min and max of type "CGFloat" to return type CGFloat as output
        return random() * (max - min) + min
    }
    
    func addMonster() {
        // Create sprite
        let monster = SKSpriteNode(imageNamed: "monster")
        
        // Determine where to spawn the monster along the Y axis
        let actualY = random(min: monster.size.height/2, max: size.height - monster.size.height/2)
        
        // Position the monster slightly off-screen along the right edge,
        // and along a random position along the Y axis as calculated above
        monster.position = CGPoint(x: size.width + monster.size.width/2, y: actualY)
        
        // Add the monster to the scene
        addChild(monster)
        monster.physicsBody = SKPhysicsBody(rectangleOf: monster.size) // rectangular body with size of monster
        monster.physicsBody?.isDynamic = true // sprite is dynamic, meaning the physics engine will not control the movement of the
                                             // monster
        monster.physicsBody?.categoryBitMask = PhysicsCategory.Monster // Sets the category bit mask to be the monsterCategory
                                                                      // defined earlier
        monster.physicsBody?.contactTestBitMask = PhysicsCategory.Projectile // contactTestBitMask indicates what categories of 
                                                                            // objects this object should notify the contact listener when they intersect
        monster.physicsBody?.collisionBitMask = PhysicsCategory.None // collisionBitMask indicates what categories of objects this object that the physics engine handle contact responses to (i.e. bounce off of)
            // You don't want the monster and projectile to bounce off each other - it's OK for them to go right through each other in this game - so you set this to 0
        
        
        // Determine speed of the monster
        let actualDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))
        
        // Create the actions
        let actionMove = SKAction.move(to: CGPoint(x: -monster.size.width/2, y: actualY), duration: TimeInterval(actualDuration)) //You use this action to direct the object to move off-screen to the left. Note that you can specify the duration for how long the movement should take, and here you vary the speed randomly from 2-4 seconds.
        
        let actionMoveDone = SKAction.removeFromParent() //SpriteKit comes with a handy action that removes a node from its parent, effectively “deleting it” from the scene. Here you use this action to remove the monster from the scene when it is no longer visible. This is important because otherwise you’d have an endless supply of monsters and would eventually consume all device resources.
        let loseAction = SKAction.run() {
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            let gameOverScene = GameOverScene(size: self.size, won: false)
            self.view?.presentScene(gameOverScene, transition: reveal)
        }
        
        monster.run(SKAction.sequence([actionMove, loseAction, actionMoveDone])) //The sequence action allows you to chain together a sequence of actions that are performed in order, one at a time. This way, you can have the “move to” action perform first, and once it is complete perform the “remove from parent” action.
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        run(SKAction.playSoundFileNamed("pew-pew-lei.caf", waitForCompletion: false))
        
        // 1 - Choose one of the touches to work with
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.location(in: self)
        
        // 2 - Set up initial location of projectile
        let projectile = SKSpriteNode(imageNamed: "projectile")
        projectile.position = player.position
        projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width/2) //set body as a circlur shape with same size
        projectile.physicsBody?.isDynamic = true // physics engine will not control movement
        projectile.physicsBody?.categoryBitMask = PhysicsCategory.Projectile //category of "Projectile
        projectile.physicsBody?.contactTestBitMask = PhysicsCategory.Monster //notify object when projectile intersects monser
        projectile.physicsBody?.collisionBitMask = PhysicsCategory.None //indicates what categories of objects this object that the physics engine handle contact responses to (i.e. bounce off of)
        projectile.physicsBody?.usesPreciseCollisionDetection = true //important to set for fast moving bodies (like projectiles), because otherwise there is a chance that two fast moving bodies can pass through each other without a collision being detected.
        
        
        // 3 - Determine offset of location to projectile
        let offset = touchLocation - projectile.position
        
        // 4 - Bail out if you are shooting down or backwards, ( occurs when user touches behind the ninja
        if (offset.x < 0) { return } // a negative number ( which is < 0) is shooting backwards
        
        // 5 - OK to add now - you've double checked position
        addChild(projectile)
        
        // 6 - Get the direction of where to shoot by converting the offset into a unit vector (of length 1) by calling normalized()
        let direction = offset.normalized()
        
        // 7 - Make it shoot far enough to be guaranteed off screen
        let shootAmount = direction * 1000 // 1 * 1000 = length
        
        // 8 - Add the shoot amount to the current position
        let realDest = shootAmount + projectile.position
        
        // 9 - Create the actions
        let actionMove = SKAction.move(to: realDest, duration: 2.0) //2 seconds to reach length of 1000
        let actionMoveDone = SKAction.removeFromParent()
        projectile.run(SKAction.sequence([actionMove, actionMoveDone])) //run the sequence and remove object once distance reached
        
    }
    
    func projectileDidCollideWithMonster(projectile: SKSpriteNode, monster: SKSpriteNode) {
        print("Hit")
        projectile.removeFromParent()
        monster.removeFromParent()
        
        monstersDestroyed += 1
        if (monstersDestroyed > 30) {
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            let gameOverScene = GameOverScene(size: self.size, won: true)
            self.view?.presentScene(gameOverScene, transition: reveal)
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        // 1
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        // 2
        if ((firstBody.categoryBitMask & PhysicsCategory.Monster != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.Projectile != 0)) {
            if let monster = firstBody.node as? SKSpriteNode, let
                projectile = secondBody.node as? SKSpriteNode {
                projectileDidCollideWithMonster(projectile: projectile, monster: monster)
//                There are two parts to this method:
//             1. This method passes you the two bodies that collide, but does not guarantee that they are passed in any particular
//                order. So this bit of code just arranges them so they are sorted by their category bit masks so you can make some
//                assumptions later.
//             2. Finally, it checks to see if the two bodies that collide are the projectile and monster, and if so calls the method
//                you wrote earlier.
            }
        }
        
    }
}
