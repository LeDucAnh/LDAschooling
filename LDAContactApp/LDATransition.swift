//
//  LDATransition.swift
//  LDAContactApp
//
//  Created by Mac on 5/6/17.
//  Copyright © 2017 LeDucAnh. All rights reserved.
//

import UIKit
/*
class LDATransition: NSObject {

}
 */
import UIKit
extension UIImage {
    convenience init(view: UIView) {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        
        self.init(cgImage: (image?.cgImage)!)
        //  self.init(CGImage: (image?.CGImage!)!)
    }
}
class ClassImageHelper:NSObject
{
    
    
   static let sharedInstance = ClassImageHelper()
    func snapshotForView(view:UIView)->UIImageView
    {
        let snapshotImage = UIImage(view :view)
        let snapshotImageView =  UIImageView(image: snapshotImage)
        snapshotImageView.frame =  view.frame
        
        return snapshotImageView
    }
}
class LDATransition: NSObject {
    static let sharedInstance = LDATransition()
    func scaleAnimation(fView:UIView,sView:UIView,superView:UIView)
    {
        
       // if fView.superview !=  sView.superview{
            //error
       //     return
        //}
       
        
        fView.isHidden = false
        sView.isHidden = false
        let sViewsnapshot =    ClassImageHelper.sharedInstance.snapshotForView(view: sView)
        
     let fViewsnapshot =    ClassImageHelper.sharedInstance.snapshotForView(view: fView)
        fView.isHidden = true
        sView.isHidden = true

        superView.addSubview(fViewsnapshot)
        
        superView.addSubview(sViewsnapshot)
        
        superView.bringSubview(toFront: sViewsnapshot)
        superView.bringSubview(toFront: fViewsnapshot)
        
        fViewsnapshot.frame =  fView.frame
        sViewsnapshot.frame =  sView.frame
        sViewsnapshot.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        fViewsnapshot.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        UIView.animate(withDuration: 0.5,
                       animations: {
                        fViewsnapshot.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                        sViewsnapshot.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        },
                       completion: { _ in
                        
                        fView.isHidden = true
                        sView.isHidden = false
                        
                        fViewsnapshot.removeFromSuperview()
                        sViewsnapshot.removeFromSuperview()

        })
        
    }
    
}
