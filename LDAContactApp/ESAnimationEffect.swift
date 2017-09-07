//
//  ESAnimationEffect.swift
//  HSUFreeWalkingtour
//
//  Created by Mac on 11/9/16.
//  Copyright © 2016 LeDucAnh. All rights reserved.
//

import UIKit

class ESAnimationEffect: NSObject {
    static var sharedInstance = ESAnimationEffect()
    func ESAnimateAppear(_ view:UIView) {
       // view.isHidden = false
       
        
        view.transform =   CGAffineTransform(scaleX: 0.2, y: 0.2)
        UIView.animate(withDuration: 0.5, animations: {
            view.transform =   CGAffineTransform(scaleX: 1.5, y: 1.5)
            
            
        }, completion: { (Bool) in
            
            UIView.animate(withDuration: 0.2, animations: {
                view.transform =   CGAffineTransform(scaleX: 1, y: 1)
            })
            
            

        })
    }
    func ESAnimateToScale(_ view:UIView,fromScale:Float,toScale:Float,inDuration:Float)
    {
        
        view.transform =   CGAffineTransform(scaleX: CGFloat(fromScale), y: CGFloat(fromScale))
        UIView.animate(withDuration: TimeInterval(inDuration), animations: {
            view.transform =   CGAffineTransform(scaleX: CGFloat(toScale), y: CGFloat(toScale))
            
            
        }, completion: { (Bool) in
            
            UIView.animate(withDuration: 0.2, animations: {
                view.transform =   CGAffineTransform(scaleX: 1, y: 1)
            })
            
            
            
        })

    }
    
}
