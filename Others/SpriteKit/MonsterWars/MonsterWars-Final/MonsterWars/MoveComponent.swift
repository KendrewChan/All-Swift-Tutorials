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

import SpriteKit
import GameplayKit

class MoveComponent: GKAgent2D, GKAgentDelegate {

  let entityManager: EntityManager

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

  func agentWillUpdate(_ agent: GKAgent) {
    guard let spriteComponent = entity?.component(ofType: SpriteComponent.self) else {
      return
    }

    position = float2(spriteComponent.node.position)
  }

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

    guard let entity = entity,
      let teamComponent = entity.component(ofType: TeamComponent.self) else {
        return
    }

    guard let enemyMoveComponent = closestMoveComponent(for: teamComponent.team.oppositeTeam()) else {
      return
    }

    let alliedMoveComponents = entityManager.moveComponents(for: teamComponent.team)

    behavior = MoveBehavior(targetSpeed: maxSpeed, seek: enemyMoveComponent, avoid: alliedMoveComponents)
  }
}
