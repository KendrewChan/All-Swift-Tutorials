//
//  ViewController.swift
//  Sound Shaker
//
//  Created by Rob Percival on 21/06/2016.
//  Copyright © 2016 Appfish. All rights reserved.
//

import UIKit/Users/kendrew/Desktop/Swift/Sound Shaker/Sound Shaker/ViewController.swift
import AVFoundation

class ViewController: UIViewController {
    
    var player = AVAudioPlayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        
        if event?.subtype == UIEventSubtype.motionShake {
            
            let soundArray = ["boing", "explosion", "hit", "knife", "shoot", "swish", "wah", "warble"] //numbering from 0,1,2,3...
            
            let randomNumber = Int(arc4random_uniform(UInt32(soundArray.count))) //arc4random only works with UInt32 type of integers, meanwhile, randomNumber has to be changed into an integer
                // finds number of arrays in "soundArray" and randomly chooses one
            
            let fileLocation = Bundle.main.path(forResource: soundArray[randomNumber], ofType: "mp3") //file location chooses a random sound from the array of "soundArray"
            
            do {
                
                try player = AVAudioPlayer(contentsOf: URL(fileURLWithPath: fileLocation!))
                
                player.play()
                
            } catch {
                
                // process error
                
            }
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

