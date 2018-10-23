//
//  Quirk.swift
//  MonsterWars
//
//  Created by Kendrew Chan on 6/12/17.
//  Copyright © 2017 Razeware LLC. All rights reserved.
//

import SpriteKit
import GameplayKit

class Quirk: GKEntity {
    
    init(team: Team, entityManager: EntityManager) {
        super.init()
        //set the texture according to the team
        let texture = SKTexture(imageNamed: "quirk1")
        let spriteComponent = SpriteComponent(texture: texture)
        //add the sprite component to the entity
        addComponent(spriteComponent)
        //add a team component to complete all this entity needs
        addComponent(TeamComponent(team: team))
        
        addComponent(HealthComponent(parentNode: spriteComponent.node, barWidth: texture.size().width, barOffset: texture.size().height/2, health: 15, entityManager: entityManager))
        
        addComponent(MoveComponent(maxSpeed: 150, maxAcceleration: 5, radius: Float(texture.size().width * 0.3), entityManager: entityManager))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
