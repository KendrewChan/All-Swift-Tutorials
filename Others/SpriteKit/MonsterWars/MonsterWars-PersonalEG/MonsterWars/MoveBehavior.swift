//
//  MoveBehavior.swift
//  MonsterWars
//
//  Created by Kendrew Chan on 6/12/17.
//  Copyright © 2017 Razeware LLC. All rights reserved.
//

import GameplayKit
import SpriteKit

// create a GKBehavior subclass here so you can easily configure a set of movement goals.
class MoveBehavior: GKBehavior {
    
    init(targetSpeed: Float, seek: GKAgent, avoid: [GKAgent]) {
        super.init()
        // If the speed < 0, agent should not move
        if targetSpeed > 0 {
            // To add a goal to your behavior, you use the setWeight(_:for:) method. This allows you to specify a goal, along with a weight of how important it is - larger weight values take priority. In this instance, you set a low priority goal for the agent to reach the target speed
            setWeight(0.5, for: GKGoal(toReachTargetSpeed: targetSpeed))
            // Here you set a medium priority goal for the agent to move toward another agent. You will use this to make your monsters move toward the closest enemy
            setWeight(0.5, for: GKGoal(toSeekAgent: seek))
            // Here you set a high priority goal to avoid colliding with a group of other agents. You will use this to make your monsters stay away from their allies so they are nicely spread out
            setWeight(0.5, for: GKGoal(toAvoid: avoid, maxPredictionTime: 1.0))
        }
    }
}
