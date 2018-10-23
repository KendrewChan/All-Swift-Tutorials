//
//  ViewController.swift
//  Back To Bach
//
//  Created by Rob Percival on 21/06/2016.
//  Copyright © 2016 Appfish. All rights reserved.
//

import UIKit
import AVFoundation //remb to import AVFoundation first

class ViewController: UIViewController {
    
    var player = AVAudioPlayer() //sets audioplayer as var
    let audioPath = Bundle.main.path(forResource: "bach", ofType: "mp3")
    var timer = Timer() //sets var for Timer
    
    func updateScrubber() {
        
        scrubber.value = Float(player.currentTime) //changes duration of audioplayer to a float value and make it proportional to scrubber value
        
    }

    @IBAction func play(_ sender: AnyObject) {
        
        player.play()
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.updateScrubber), userInfo: nil, repeats: true) //sets timer to follow value of scrubber moving along with audio
        
    }
    
    
    @IBAction func volumeChanged(_ sender: AnyObject) {
        
        player.volume = volumeSlider.value
        
    }
    
    @IBOutlet var volumeSlider: UISlider!
    
    
    @IBAction func scrubberMoved(_ sender: AnyObject) {
        
       player.currentTime = TimeInterval(scrubber.value)
        
    }
    
    @IBOutlet var scrubber: UISlider!
    
    @IBAction func pause(_ sender: AnyObject) { //pause function stops the audio and resets it
        
        player.pause()
        
        timer.invalidate()
        
    }
    
    @IBAction func stop(_ sender: AnyObject) {
        
        timer.invalidate()
        
        player.pause()
        
        scrubber.value = 0
        
        do {
            
            try player = AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioPath!))
            
        } catch {
            
            // process error
            
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        do {
            
            try player = AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioPath!))
            
            scrubber.maximumValue = Float(player.duration)
            
        } catch {
            
            // process error
            
        }
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

