//
//  TeamComponent.swift
//  MonsterWars
//
//  Created by Kendrew Chan on 6/12/17.
//  Copyright © 2017 Razeware LLC. All rights reserved.
//

import SpriteKit
import GameplayKit

// enumeration to keep track of the two teams in this game – team 1 and team 2. It also has a helper method to return the opposite team, which will come in handy later.
enum Team: Int {
    case team1 = 1
    case team2 = 2
    
    static let allValues = [team1, team2]
    
    func oppositeTeam() -> Team {
        switch self {
        case .team1:
            return .team2
        case .team2:
            return .team1
        }
    }
}

// keeps track of the team for this entity
class TeamComponent: GKComponent {
    let team: Team
    
    init(team: Team) {
        self.team = team
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
