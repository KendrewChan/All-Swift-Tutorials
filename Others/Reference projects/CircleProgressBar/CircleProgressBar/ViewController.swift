//
//  ViewController.swift
//  CircleProgressBar
//
//  Created by Kendrew Chan on 1/5/18.
//  Copyright © 2018 Kendrew Chan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let shapeLayer = CAShapeLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let center = view.center
        
        let circularPath = UIBezierPath(arcCenter: center, radius: 100, startAngle: -CGFloat.pi/2/*to bring the startAngle to the top*/, endAngle: 2*CGFloat.pi, clockwise: true) // path of circular progress bar
        shapeLayer.path = circularPath.cgPath // creating circular path
        
        shapeLayer.strokeColor = UIColor.red.cgColor // color of outer ring
        shapeLayer.lineWidth = 10 // width of outer ring
        shapeLayer.fillColor = UIColor.clear.cgColor // transparent ring
        
        shapeLayer.lineCap = kCALineCapRound // to soften the edges of the progress ring
        
        shapeLayer.strokeEnd = 0 // relative location to stop the outer ring animation
        
        let trackLayer = CAShapeLayer() // to have secondary translucent ring for progress ring
        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = UIColor.lightGray.cgColor
        trackLayer.lineWidth = 10
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = kCALineCapRound
        view.layer.addSublayer(trackLayer)
        
        view.layer.addSublayer(shapeLayer)
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }

    @objc private func handleTap() {
        // animate stroke
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 1 // combined with 'shapeLayer.strokeEnd' to form animation
        basicAnimation.duration = 2 // duration of progress -> in seconds (convertable to timerValue)
        
        basicAnimation.fillMode = kCAFillModeForwards // need this for animation to stay a the end
        basicAnimation.isRemovedOnCompletion = false // prevent the progress bar from resetting on finish
        
        shapeLayer.add(basicAnimation, forKey: "basicAnima")
    }
}

