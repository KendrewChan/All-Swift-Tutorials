//
//  File.swift
//  MonsterWars
//
//  Created by Kendrew Chan on 5/12/17.
//  Copyright © 2017 Razeware LLC. All rights reserved.
//

import SpriteKit
import GameplayKit

class Castle: GKEntity { //it’s often convenient to subclass GKEntity for each type of object in your game. The alternative is to create a base GKEntity and dynamically add the types of components you need; but often you want to have a “cookie cutter” for a particular type of object.
    
    init(imageName: String, team: Team, entityManager: EntityManager) {
        super.init()
        
        // add the SpriteComponent to the entity
        let texture = SKTexture(imageNamed: imageName)
        let spriteComponent = SpriteComponent(entity: self, texture: texture, size: texture.size())
        addComponent(spriteComponent)

        addComponent(TeamComponent(team: team))
        
        addComponent(CastleComponent())
        
        addComponent(MoveComponent(maxSpeed: 0, maxAcceleration: 0, radius: Float(spriteComponent.node.size.width / 2), entityManager: entityManager))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
