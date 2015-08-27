//
//  CustomCollectionViewCell.swift
//  IOSClockDemo
//
//  Created by 沈家瑜 on 15/8/25.
//  Copyright (c) 2015年 沈家瑜. All rights reserved.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    var label: UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        let w = frame.width
        let h = frame.height
        label = UILabel(frame: CGRect(x: w / 2 - 80, y: h / 2 - 30, width: 160, height: 60))
        label.backgroundColor = UIColor.clearColor()
        label.textColor = UIColor.orangeColor()
        label.textAlignment = .Center
        label.font = UIFont.boldSystemFontOfSize(25 * UIScreen.mainScreen().bounds.width / 500)
        self.contentView.addSubview(label)
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        super.touchesBegan(touches, withEvent: event)
        self.layer.pop_removeAllAnimations()
        var animat = self.layer.pop_animationForKey("toScale") as? POPSpringAnimation
        
        if animat != nil {
            animat?.toValue = NSValue(CGPoint: CGPoint(x: 0.8, y: 0.8))
        } else {
            animat = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY)
            animat!.toValue = NSValue(CGPoint: CGPoint(x: 0.8, y: 0.8))
            animat!.autoreverses = false
            animat!.springBounciness = 15
            animat!.springSpeed = 20
            self.layer.pop_addAnimation(animat, forKey: "toScale")
        }
        
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.alpha = 0.6
        })
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        super.touchesEnded(touches, withEvent: event)
        self.layer.pop_removeAllAnimations()
        var animat = self.layer.pop_animationForKey("returnScale") as? POPSpringAnimation
        
        if animat != nil {
            animat!.fromValue = NSValue(CGPoint: CGPoint(x: 0.8, y: 0.8))
            animat?.toValue = NSValue(CGPoint: CGPoint(x: 1.0, y: 1.0))
        } else {
            animat = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY)
            animat!.fromValue = NSValue(CGPoint: CGPoint(x: 0.8, y: 0.8))
            animat!.toValue = NSValue(CGPoint: CGPoint(x: 1.0, y: 1.0))
            animat!.autoreverses = false
            animat!.springBounciness = 15
            animat!.springSpeed = 20
            self.layer.pop_addAnimation(animat, forKey: "returnScale")
        }
        
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.alpha = 1
        })
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        super.touchesMoved(touches, withEvent: event)
        self.layer.pop_removeAllAnimations()
        var animat = self.layer.pop_animationForKey("returnScale") as? POPSpringAnimation
        
        if animat != nil {
            animat!.fromValue = NSValue(CGPoint: CGPoint(x: 0.8, y: 0.8))
            animat?.toValue = NSValue(CGPoint: CGPoint(x: 1.0, y: 1.0))
        } else {
            animat = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY)
            animat!.fromValue = NSValue(CGPoint: CGPoint(x: 0.8, y: 0.8))
            animat!.toValue = NSValue(CGPoint: CGPoint(x: 1.0, y: 1.0))
            animat!.autoreverses = false
            animat!.springBounciness = 15
            animat!.springSpeed = 20
            self.layer.pop_addAnimation(animat, forKey: "returnScale")
        }
        
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.alpha = 1
        })
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
