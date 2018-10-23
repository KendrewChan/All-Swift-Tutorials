//
//  EntityManager.swift
//  MonsterWars
//
//  Created by Kendrew Chan on 5/12/17.
//  Copyright © 2017 Razeware LLC. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class EntityManager { //keep a reference to all entities in the game
    
    //add this code to get updateWithDeltaTime(_:)
    lazy var componentSystems: [GKComponentSystem] = {
        let castleSystem = GKComponentSystem(componentClass: CastleComponent.self)
        let moveSystem = GKComponentSystem(componentClass: MoveComponent.self)
        return [castleSystem, moveSystem]
    }() // Think of GKComponentSystem as a class that stores a collection of components. Here, you create a GKComponentSystem to keep track of all of the CastleComponent instances in your game.
        //  You then put the GKComponentSystem that stores components into an array. update(_:) method gets called on MoveComponent
    
    
    var entities = Set<GKEntity>()
    let scene: SKScene
    var toRemove = Set<GKEntity>()
    
    // simple initializer that stores the scene in the scene property
    init(scene: SKScene) {
        self.scene = scene
    }
    
    // helper function handles adding entities to your game by adding them to the list of entitites, then checks to see if the entity has a SpriteComponent. If it does, it adds the sprite’s node to the scene
    func add(_ entity: GKEntity) {
        entities.insert(entity)
        
        if let spriteNode = entity.component(ofType: SpriteComponent.self)?.node {
            scene.addChild(spriteNode)
        }
        
        //whenever you add a new entity, you add it to each of the component systems in your array
        for componentSystem in componentSystems {
            componentSystem.addComponent(foundIn: entity)
        }
    }
    
    // call this helper function when you want to remove an entity from your game; if the entity has a SpriteComponent, it removes the node from the scene, and it also removes the entity from the list of entities
    func remove(_ entity: GKEntity) {
        if let spriteNode = entity.component(ofType: SpriteComponent.self)?.node {
            spriteNode.removeFromParent()
        }
        
        entities.remove(entity)
        toRemove.insert(entity)
    }
    
    func update(_ deltaTime: CFTimeInterval) {
        // loop through all the component systems in the array and call update(deltaTime:) on each one
        for componentSystem in componentSystems {
            componentSystem.update(deltaTime: deltaTime)
        } // This actually demonstrates the whole purpose and benefit of using GKComponentSystem. The way this is set up, components are updated one system at a time. In games, it’s often convenient to have precise control over the ordering of the processing of each system (physics, rendering, etc)
        
        
        // loop through anything in the toRemove array and remove those entities from the component systems
        for currentRemove in toRemove {
            for componentSystem in componentSystems {
                componentSystem.removeComponent(foundIn: currentRemove)
            }
        }
        toRemove.removeAll()
    }
    
    //handy method to get the castle for a particular team. In here you loop through all of the entities in the game and check to see any entities that have both a TeamComponent and a CastleComponent – which should be the two castles in the game. You then check to see if the team matches the passed in parameter and return that.
    func castle(for team: Team) -> GKEntity? {
        for entity in entities {
            if let teamComponent = entity.component(ofType: TeamComponent.self),
                let _ = entity.component(ofType: CastleComponent.self) {
                if teamComponent.team == team {
                    return entity
                }
            }
        }
        return nil
    }
    
    func spawnQuirk(team: Team) {
        // find position of castle sprite where monsters would spawn
        guard let teamEntity = castle(for: team),
            let teamCastleComponent = teamEntity.component(ofType: CastleComponent.self),
            let teamSpriteComponent = teamEntity.component(ofType: SpriteComponent.self) else {
                return
        }
        
        // checks to see if there are enough coins to spawn the monster, and if so subtracts the appropriate coins and plays a sound
        if teamCastleComponent.coins < costQuirk {
            return
        }
        teamCastleComponent.coins -= costQuirk
        scene.run(SoundManager.sharedInstance.soundSpawn)
        
        // 3
        let monster = Quirk(team: team, entityManager: self) //Quirk represents Quirk.swift
        if let spriteComponent = monster.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: teamSpriteComponent.node.position.x, y: CGFloat.random(min: scene.size.height * 0.25, max: scene.size.height * 0.75))
            spriteComponent.node.zPosition = 2
        }
        add(monster)
    }
    
    func spawnZap(team: Team) {
        // find position of castle sprite where monsters would spawn
        guard let teamEntity = castle(for: team),
            let teamCastleComponent = teamEntity.component(ofType: CastleComponent.self),
            let teamSpriteComponent = teamEntity.component(ofType: SpriteComponent.self) else {
                return
        }
        
        // checks to see if there are enough coins to spawn the monster, and if so subtracts the appropriate coins and plays a sound
        if teamCastleComponent.coins < costZap {
            return
        }
        teamCastleComponent.coins -= costZap
        scene.run(SoundManager.sharedInstance.soundSpawn)
        
        // 3
        let monster = Zap(team: team, entityManager: self)  //Zap represents Zap.swift
        if let spriteComponent = monster.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: teamSpriteComponent.node.position.x, y: CGFloat.random(min: scene.size.height * 0.25, max: scene.size.height * 0.75))
            spriteComponent.node.zPosition = 2
        }
        add(monster)
    }
    
    func spawnMunch(team: Team) {
        // find position of castle sprite where monsters would spawn
        guard let teamEntity = castle(for: team),
            let teamCastleComponent = teamEntity.component(ofType: CastleComponent.self),
            let teamSpriteComponent = teamEntity.component(ofType: SpriteComponent.self) else {
                return
        }
        
        // checks to see if there are enough coins to spawn the monster, and if so subtracts the appropriate coins and plays a sound
        if teamCastleComponent.coins < costMunch {
            return
        }
        teamCastleComponent.coins -= costMunch
        scene.run(SoundManager.sharedInstance.soundSpawn)
        
        // 3
        let monster = Munch(team: team, entityManager: self)  //Munch represents Munch.swift
        if let spriteComponent = monster.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: teamSpriteComponent.node.position.x, y: CGFloat.random(min: scene.size.height * 0.25, max: scene.size.height * 0.75))
            spriteComponent.node.zPosition = 2
        }
        add(monster)
    }
    
    //returns all entities for a particular team
    func entities(for team: Team) -> [GKEntity] {
        return entities.flatMap{ entity in
            if let teamComponent = entity.component(ofType: TeamComponent.self) {
                if teamComponent.team == team {
                    return entity
                }
            }
            return nil
        }
    }
    
    //returns all move components for a particular team
    func moveComponents(for team: Team) -> [MoveComponent] {
        let entitiesToMove = entities(for: team)
        var moveComponents = [MoveComponent]()
        for entity in entitiesToMove {
            if let moveComponent = entity.component(ofType: MoveComponent.self) {
                moveComponents.append(moveComponent)
            }
        }
        return moveComponents
    }
}
