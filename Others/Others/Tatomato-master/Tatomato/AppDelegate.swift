//
//  AppDelegate.swift
//  Tatomato
//
//  Created by 胡雨阳 on 15/12/28.
//  Copyright © 2015年 胡雨阳. All rights reserved.
//

import UIKit
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var viewController: ViewController?
    var audioPlayer: AVAudioPlayer!
    var audioEngine = AVAudioEngine()
    var bgTask: UIBackgroundTaskIdentifier!
    
    let app = UIApplication.shared

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        
        // 修改 UINavigation Bar 颜色 & 字体
        
        UINavigationBar.appearance().barTintColor = UIColor(red: 56.0/255.0, green: 51.0/255.0, blue: 76.0/255.0, alpha: 1.0)
        UINavigationBar.appearance().tintColor = UIColor(red: 235.0/255.0, green: 235.0/255.0, blue: 235.0/255.0, alpha: 1.0)
        
        if let barFont = UIFont(name: "Avenir-Light", size: 24.0) {
            UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0), NSFontAttributeName: barFont]
        }
        
        // 修改 UIStatusBar 颜色
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        return true
    }
    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        print("didReceiveLocalNotification \(notification)")
    }
    

    func applicationWillResignActive(_ application: UIApplication) {
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        print("Application will enter background.")
        
        self.bgTask = app.beginBackgroundTask(expirationHandler: {
            self.app.endBackgroundTask(self.bgTask)
            self.bgTask = UIBackgroundTaskInvalid
        })
        
        Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(AppDelegate.applyForMoreTime), userInfo: nil, repeats: true)
        
        Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(AppDelegate.doSomething), userInfo: nil, repeats: true)
    }

    func doSomething() {
        print("Doing something. \(app.backgroundTimeRemaining)")
    }
    
    func applyForMoreTime() {
        if app.backgroundTimeRemaining < 30 {
            let filePathUrl = URL(string: Bundle.main.path(forResource: "Silence", ofType: "mp3")!)!
            
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: AVAudioSessionCategoryOptions.mixWithOthers)
            } catch _ {
                
            }
            self.audioPlayer = try? AVAudioPlayer(contentsOf: filePathUrl)
            self.audioEngine.reset()
            self.audioPlayer.play()
            
            self.app.endBackgroundTask(self.bgTask)
            self.bgTask = app.beginBackgroundTask(expirationHandler: {
                self.app.endBackgroundTask(self.bgTask)
                self.bgTask = UIBackgroundTaskInvalid
            })
        }
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
    }
}

