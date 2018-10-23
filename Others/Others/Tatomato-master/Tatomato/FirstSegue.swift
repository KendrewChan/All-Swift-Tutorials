//
//  firstSegue.swift
//  Tatomato
//
//  Created by 胡雨阳 on 16/1/14.
//  Copyright © 2016年 胡雨阳. All rights reserved.
//

import UIKit

class FirstSegue: UIStoryboardSegue {
    
    override func perform() {
        let firstVCView = self.source.view as UIView!
        let secondVCView = self.destination.view as UIView!
        
        let screenWidth = UIScreen.main.bounds.size.width
        let screenHeight = UIScreen.main.bounds.size.height
        
        secondVCView?.frame = CGRect(x: 0.0, y: screenHeight, width: screenWidth, height: screenHeight)
        
        let window = UIApplication.shared.keyWindow
        window?.insertSubview(secondVCView!, aboveSubview: firstVCView!)
        
        
        // MARK: - Animation
        
        UIView.animate(withDuration: 0.45, delay: 0.0, usingSpringWithDamping: 0.69, initialSpringVelocity: 0.1, options: [.curveLinear], animations: { () -> Void in
                secondVCView?.frame = (secondVCView?.frame.offsetBy(dx: 0.0, dy: -screenHeight))!
            }) { (finished: Bool) -> Void in
                self.source.present(self.destination, animated: false, completion: nil)
        }
    }
    
}
