//
//  ViewController.swift
//  Tatomato
//
//  Created by 胡雨阳 on 15/12/28.
//  Copyright © 2015年 胡雨阳. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timerView: Cycle!
    @IBOutlet weak var startButton: UIButton!
    
    let defaults = UserDefaults.standard
    let tapToStop = UITapGestureRecognizer()
    
    var timer: Timer?
    var endDate: Date?
    var localNotification: UILocalNotification?
    var pomodoroClass = Pomodoro()
    let settingViewController =  SettingViewController()
    
    var process: Float {
        get {
            return timerView.valueProgress / 67 * 100
        }
        set {
            timerView.valueProgress = newValue / 100 * 67
            updateUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeGestureRecognizer: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.showViewController as (ViewController) -> () -> ()))
        swipeGestureRecognizer.direction = .up
        self.view.addGestureRecognizer(swipeGestureRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI() //////
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    // MARK: - Timer
    
    @IBAction func buttonStartPressed(_ sender: AnyObject?) {
        if pomodoroClass.pomoMode == 0 {
            timer?.invalidate()
            timer = nil
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(ViewController.pomoing(_:)), userInfo: nil, repeats: true)
        }
        
        pomodoroClass.start()
        print("Pomodoro Started")
        
        startButton.setTitle("Stop", for: UIControlState())
        tapToStop.addTarget(self, action: #selector(ViewController.stopTimer(_:)))
        startButton.addGestureRecognizer(tapToStop)
        
        localNotification = UILocalNotification()
        let seconds = Date(timeIntervalSinceNow: Double(pomodoroClass.pomoTime))
        localNotification!.fireDate = seconds
        localNotification!.timeZone = TimeZone.current
        localNotification!.alertBody = "Time for work is up!"
        localNotification!.soundName = UILocalNotificationDefaultSoundName
        UIApplication.shared.scheduleLocalNotification(localNotification!)
    }
    
    func stopTimer(_ sender: UITapGestureRecognizer) {
        stopPomo()
        pomodoroClass.updateDisplay()
        startButton.removeGestureRecognizer(tapToStop)
        startButton.setTitle("Start", for: UIControlState())
    }
    ///////
    func pomoing(_ timer: Timer) {
        process = pomodoroClass.process
    }
    
    func updateUI() {
        pomodoroClass.refreshTime()
        timeLabel.text = pomodoroClass.timerLabel
        timerView.setNeedsDisplay()
    }
    ///////
    func stopPomo() {
        print("Pomo Stop")
        pomodoroClass.stop()
        stopTimer()
        process = 0
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    // MARK: - Transition
    
    func showViewController() {
        self.performSegue(withIdentifier: "FirstSegue", sender: self)
    }

}

