//
//  CastleComponents.swift
//  MonsterWars
//
//  Created by Kendrew Chan on 6/12/17.
//  Copyright © 2017 Razeware LLC. All rights reserved.
//

import SpriteKit
import GameplayKit

class CastleComponent: GKComponent { //used to keep track of is each player’s current coins
    
    //store the number of coins in the castle and the last time coins were earned
    var coins = 0
    var lastCoinDrop = TimeInterval(0)
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // SpriteKit calls update(deltaTime:) on each frame of the game. Note that SpriteKit does not call this method automatically; there’s a little bit of setup to get this to happen, which you’ll do shortly
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        //This code spawns coins periodically.
        let coinDropInterval = TimeInterval(0.5)
        let coinsPerInterval = 10
        if (CACurrentMediaTime() - lastCoinDrop > coinDropInterval) {
            lastCoinDrop = CACurrentMediaTime()
            coins += coinsPerInterval
        }
    }
}
