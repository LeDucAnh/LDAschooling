//
//  LDACATransitionButton.swift
//  LDAContactApp
//
//  Created by Mac on 5/15/17.
//  Copyright © 2017 LeDucAnh. All rights reserved.
//

import UIKit
public enum TransitrionButtonState
{
    case open, close
}


class LDACATransitrionButton {
    var state : TransitrionButtonState = .close
    
    var button :WCLShineButton?
    
    var targetView:UIView?
    var originalframe :CGRect?
    var heightConstraint : NSLayoutConstraint?
    func embedTransitionButtonToView(view:UIView)
    {
        
        
        targetView = view
        originalframe = view.frame
        
        var param1 = WCLShineParams()
        param1.bigShineColor = UIColor(rgb: (153,152,38))
        param1.smallShineColor = UIColor(rgb: (102,102,102))
        let height:CGFloat = 30.0
        
        
        let button = WCLShineButton(frame: .init(x: view.frame.origin.x, y: view.frame.origin.y - height/2, width: height, height: height), params: param1)
        button.isSelected = true
        
        button.fillColor = UIColor(rgb: (153,152,38))
        button.color = UIColor(rgb: (170,170,170))
        
        
        button.addTarget(self, action: #selector(action), for: .touchUpInside)
        
        
        
        self.heightConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 100)
        
        view.superview?.addSubview(button)
        
        view.addConstraint(self.heightConstraint!)
        
        
    }
    
    @objc private func action() {
        print("点击")
        
        if self.state == .close
        {
            openForView()
        }
        else
        {
            self.closeForView()
        }
    }
    func openForView()
    {
        
        self.state = .open
        
        UIView.animate(withDuration: 1, delay: 0.25,options: UIViewAnimationOptions.curveEaseOut,animations: {
            
            self.targetView?.transform = CGAffineTransform(scaleX: 1, y: 1)
            
        },completion: nil)
        
        
        return
            
            (self.heightConstraint?.constant = (self.originalframe?.size.height)!)!
        
        UIView.animate(withDuration: 1, animations: {
            // self.view.layoutIfNeeded()
            
            self.targetView?.superview?.layoutIfNeeded()
            //   self.targetView?.layoutIfNeeded()
        })
        
        
        return
            ESAnimation.shareInstance.resizeAnimation(view: targetView!, newframe: originalframe!, time: 1)
        
        
        
        
        
    }
    
    
    func closeForView()
    {
        
        self.state = .close
        //    self.targetView.add
        
        
        UIView.animate(withDuration: 1, delay: 0.25,options: UIViewAnimationOptions.curveEaseOut,animations: {
            
            self.targetView?.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
            
        },completion: nil)
        
        
        return
            (self.heightConstraint?.constant = 0)!
        UIView.animate(withDuration: 1, animations: {
            // self.view.layoutIfNeeded()
            
            
            
            self.targetView?.superview?.layoutIfNeeded()
            self.targetView?.layoutIfNeeded()
        })
        
        
        return
        
        let newframe = CGRect(x: (targetView?.frame.origin.x)!, y: (targetView?.frame.origin.y)!, width: 0, height: 0)
        ESAnimation.shareInstance.resizeAnimation(view: targetView!, newframe: newframe, time: 1)
        
    }
    
    
}

