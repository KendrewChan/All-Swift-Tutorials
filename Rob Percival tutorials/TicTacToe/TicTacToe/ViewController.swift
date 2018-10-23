//
//  ViewController.swift
//  TicTacToe
//
//  Created by Rob Percival on 20/06/2016.
//  Copyright © 2016 Appfish. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var winnerLabel: UILabel!
    @IBOutlet var playAgainButton: UIButton!
    
    // 1 is noughts, 2 is crosses
    
    var activeGame = true
    
    var activePlayer = 1
    
    var gameState = [0, 0, 0, 0, 0, 0, 0, 0, 0] // 0 - empty, 1 - noughts, 2 - crosses
    
    let winningCombinations = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]

    @IBAction func buttonPressed(_ sender: AnyObject) { //each nought & cross is a button with var of "sender"
        
        let activePosition = sender.tag - 1
        
        if gameState[activePosition] == 0 && activeGame { //to ensure noughts and crosses don't appear together if clicked, and to find gameState of each activePositions
            
            gameState[activePosition] = activePlayer //links activePlayer to activePosition, thereby setting up a turn by turn basis
        
            if activePlayer == 1 {
            
                sender.setImage(UIImage(named: "nought.png"), for: [])
                activePlayer = 2
                
            
            } else {
            
                sender.setImage(UIImage(named: "cross.png"), for: [])
                activePlayer = 1
            
            }
            
            for combination in winningCombinations { //there exists combination[0],combination[1] & combination[2]
                
                if gameState[combination[0]] != 0 && gameState[combination[0]] == gameState[combination[1]] && gameState[combination[1]] == gameState[combination[2]] { //to ensure winning combination is all noughts/crosses. 
                    // Also, combination[0] refers to 1st digit in each combination & combination[1] refers to 2nd digit & combination[2] refers to 3rd digit
                    // meaning combination[0] = 0 in [0,1,2] / 3 in [3,4,5], whilst combination[1] refers to 1 in [0,1,2] / 4 in [3,4,5]
                    
                    // We have a winner!
                    
                    activeGame = false //prevents game from being further played
                    
                    winnerLabel.isHidden = false
                    playAgainButton.isHidden = false
                    
                    if gameState[combination[0]] == 1 { //all 3 images must be equal to win, thus gameState[combination[0]] = gameState[combination[1]] = gameState[combination[2]]
                        
                        winnerLabel.text = "Noughts has won!"
                        
                    } else {
                        
                        winnerLabel.text = "Crosses has won!"
                        
                    }
                    
                    UIView.animate(withDuration: 1, animations: { //animating in the winning text
                        
                        self.winnerLabel.center = CGPoint(x: self.winnerLabel.center.x + 500, y: self.winnerLabel.center.y)
                        self.playAgainButton.center = CGPoint(x: self.playAgainButton.center.x + 500, y: self.playAgainButton.center.y)
                        
                    })
                    
                }
                
            }
            
        }
        
    }
    
    @IBAction func playAgain(_ sender: AnyObject) {
        
        activeGame = true
        
        activePlayer = 1
        
        gameState = [0, 0, 0, 0, 0, 0, 0, 0, 0]
        
        for i in 1..<10 {
            
            if let button = view.viewWithTag(i) as? UIButton { //sets the images with tags of 0, 1, 2, 3, ...8
                
                button.setImage(nil, for: []) //initially no image
                
            }
            
            winnerLabel.isHidden = true
            playAgainButton.isHidden = true
            
            winnerLabel.center = CGPoint(x: winnerLabel.center.x - 500, y: winnerLabel.center.y)
            playAgainButton.center = CGPoint(x: playAgainButton.center.x - 500, y: playAgainButton.center.y)
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        winnerLabel.isHidden = true
        playAgainButton.isHidden = true
        
        winnerLabel.center = CGPoint(x: winnerLabel.center.x - 500, y: winnerLabel.center.y)
        playAgainButton.center = CGPoint(x: playAgainButton.center.x - 500, y: playAgainButton.center.y)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

