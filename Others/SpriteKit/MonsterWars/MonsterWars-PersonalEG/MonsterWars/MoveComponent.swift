//
//  MoveComponent.swift
//  MonsterWars
//
//  Created by Kendrew Chan on 6/12/17.
//  Copyright © 2017 Razeware LLC. All rights reserved.
//

import SpriteKit
import GameplayKit

// GKAgent2D is a subclass of GKComponent. You subclass it here so customize its functionality. Also, you implement GKAgentDelegate - this is how you'll match up the position of the sprite with the agent's position
class MoveComponent: GKAgent2D, GKAgentDelegate {
    
    // reference to the entityManger to access other entities
    let entityManager: EntityManager
    
    // GKAgent2D has various properties like max speed, acceleration. Here you configure them based on passed in parameters. You also set this class as its own delegate, and make the mass very small so objects respond to direction changes more easily.
    init(maxSpeed: Float, maxAcceleration: Float, radius: Float, entityManager: EntityManager) {
        self.entityManager = entityManager
        super.init()
        delegate = self
        self.maxSpeed = maxSpeed
        self.maxAcceleration = maxAcceleration
        self.radius = radius
        print(self.mass)
        self.mass = 0.01
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Before the agent updates its position, you set the position of the agent to the sprite component's position. This is so that agents will be positioned in the correct spot to start. Note there's some funky conversions going on here - GameplayKit uses float2 instead of CGPoint
    func agentWillUpdate(_ agent: GKAgent) {
        guard let spriteComponent = entity?.component(ofType: SpriteComponent.self) else {
            return
        }
        
        position = float2(spriteComponent.node.position)
    }
    
    // set the sprite's position to match the agent's position as agentDidUpdate(_:) is called after the agent updates its position
    func agentDidUpdate(_ agent: GKAgent) {
        guard let spriteComponent = entity?.component(ofType: SpriteComponent.self) else {
            return
        }
        
        spriteComponent.node.position = CGPoint(position)
    }
    
    func closestMoveComponent(for team: Team) -> GKAgent2D? {
        
        var closestMoveComponent: MoveComponent? = nil
        var closestDistance = CGFloat(0)
        
        let enemyMoveComponents = entityManager.moveComponents(for: team)
        for enemyMoveComponent in enemyMoveComponents {
            let distance = (CGPoint(enemyMoveComponent.position) - CGPoint(position)).length()
            if closestMoveComponent == nil || distance < closestDistance {
                closestMoveComponent = enemyMoveComponent
                closestDistance = distance
            }
        }
        return closestMoveComponent
        
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        // find the team component for the current entity
        guard let entity = entity,
            let teamComponent = entity.component(ofType: TeamComponent.self) else {
                return
        }
        
        // use the helper method you wrote to find the closest enemy
        guard let enemyMoveComponent = closestMoveComponent(for: teamComponent.team.oppositeTeam()) else {
            return
        }
        
        // use the helper method you wrote to find all your allies move components
        let alliedMoveComponents = entityManager.moveComponents(for: teamComponent.team)
        
        // reset the behavior with the updated values
        behavior = MoveBehavior(targetSpeed: maxSpeed, seek: enemyMoveComponent, avoid: alliedMoveComponents)
    }
}
