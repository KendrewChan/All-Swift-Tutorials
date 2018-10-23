/*
 * Copyright (c) 2015 Razeware LLC
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

import Foundation
import SpriteKit
import GameplayKit

class EntityManager {

  var entities = Set<GKEntity>()
  let scene: SKScene

  lazy var componentSystems: [GKComponentSystem] = {
    let castleSystem = GKComponentSystem(componentClass: CastleComponent.self)
    let moveSystem = GKComponentSystem(componentClass: MoveComponent.self)
    return [castleSystem, moveSystem]
  }()

  var toRemove = Set<GKEntity>()

  init(scene: SKScene) {
    self.scene = scene
  }

  func add(_ entity: GKEntity) {
    entities.insert(entity)

    if let spriteNode = entity.component(ofType: SpriteComponent.self)?.node {
      scene.addChild(spriteNode)
    }

    for componentSystem in componentSystems {
      componentSystem.addComponent(foundIn: entity)
    }
  }

  func remove(_ entity: GKEntity) {
    if let spriteNode = entity.component(ofType: SpriteComponent.self)?.node {
      spriteNode.removeFromParent()
    }

    entities.remove(entity)
    toRemove.insert(entity)
  }

  func update(_ deltaTime: CFTimeInterval) {
    for componentSystem in componentSystems {
      componentSystem.update(deltaTime: deltaTime)
    }

    for currentRemove in toRemove {
      for componentSystem in componentSystems {
        componentSystem.removeComponent(foundIn: currentRemove)
      }
    }
    toRemove.removeAll()
  }

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
    guard let teamEntity = castle(for: team),
      let teamCastleComponent = teamEntity.component(ofType: CastleComponent.self),
      let teamSpriteComponent = teamEntity.component(ofType: SpriteComponent.self) else {
        return
    }

    if teamCastleComponent.coins < costQuirk {
      return
    }
    teamCastleComponent.coins -= costQuirk
    scene.run(SoundManager.sharedInstance.soundSpawn)

    let monster = Quirk(team: team, entityManager: self)
    if let spriteComponent = monster.component(ofType: SpriteComponent.self) {
      spriteComponent.node.position = CGPoint(x: teamSpriteComponent.node.position.x, y: CGFloat.random(min: scene.size.height * 0.25, max: scene.size.height * 0.75))
      spriteComponent.node.zPosition = 2
    }
    add(monster)
  }

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
