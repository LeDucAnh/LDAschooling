//
//  ESAnimation.swift
//  HSUFreeWalkingtour
//
//  Created by Mac on 12/29/16.
//  Copyright © 2016 LeDucAnh. All rights reserved.
//

import UIKit

extension UIView :CloneableViewPotocol{
    internal func clone() -> UIView {
        let newView = UIView()
        return newView
        
    }
    
    
   
}
protocol CloneableViewPotocol {
    func clone()->UIView
}
class ESAnimation: NSObject ,UIGestureRecognizerDelegate{
    
  static  let shareInstance  = ESAnimation()
    func shakeView(_ view:UIView)
    {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x:view.center.x - 10,y: view.center.y - 0.5))
        animation.toValue = NSValue(cgPoint: CGPoint(x:view.center.x + 10,y: view.center.y + 0.5))
        view.layer.add(animation, forKey: "position")

    }
    func shakeView(_ view:UIView,updown:CGFloat,leftright:CGFloat)
    {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x:view.center.x - leftright,y: view.center.y - updown))
        animation.toValue = NSValue(cgPoint: CGPoint(x:view.center.x + leftright,y: view.center.y + updown))
        view.layer.add(animation, forKey: "position")
        
    }
    func fadeIn(_ view:UIView,withDuration duration: TimeInterval ) {
        UIView.animate(withDuration: duration, animations: {
            view.alpha = 1.0
        })
    }
    
    /**
     Fade out a view with a duration
     
     - parameter duration: custom animation duration
     */
    
    func fadeOutToAlpha(_ view:UIView,toAlpha:Double,withDuration duration: TimeInterval) {
        UIView.animate(withDuration: duration, animations: {
            view.alpha = CGFloat(toAlpha)
        })
    }

    func fadeOut(_ view:UIView,withDuration duration: TimeInterval ) {

        self.fadeOutToAlpha(view, toAlpha: 0, withDuration: duration)
    }
 
    class GradientBorderAnimationObject {
        var view:UIView?
        var gradientLayer:CAGradientLayer?
    }
    var  GradientBorderAnimationObjectArr = [GradientBorderAnimationObject]()
 
    func findIndex(ofString valueToFind: CAGradientLayer, in array: [GradientBorderAnimationObject]) -> Int? {
     
        for (index, value) in array.enumerated() {
            if value.gradientLayer == valueToFind {
                return index
            }
        }
        return nil
    }
    func findIndex(ofView valueToFind: UIView, in array: [GradientBorderAnimationObject]) -> Int? {
        
        for (index, value) in array.enumerated() {
            if value.view == valueToFind {
                return index
            }
        }
        return nil
    }

    func findIndex(ofString valueToFind: CAGradientLayer, in array: [CALayer]) -> Int? {
        
        for (index, value) in array.enumerated() {
            if value == valueToFind {
                return index
            }
        }
        return nil
    }

    func executeGradientBorderAnimationFor(view:UIView,colors:[CGColor]? = nil)
    {
       
        var shape = CAShapeLayer()
     //    gradient.setValue("gradientBorder", forKey: "id")
              if let index =  self.findIndex(ofView: view, in: self.GradientBorderAnimationObjectArr)
       {
        
                let layer = self.GradientBorderAnimationObjectArr[index].gradientLayer
        
                self.GradientBorderAnimationObjectArr.remove(at: index)

        
                layer?.removeFromSuperlayer()
                layer?.removeAllAnimations()
      
        

        }
        
        let GradientBorderAnimationObj = GradientBorderAnimationObject()
        GradientBorderAnimationObj.view = view
        
        GradientBorderAnimationObj.gradientLayer = CAGradientLayer()
        self.GradientBorderAnimationObjectArr.append(GradientBorderAnimationObj)

    
        let frame = view.frame
        

        let borderOutsideSet:CGFloat = 2.0
        let path = UIBezierPath(roundedRect: CGRect(x: borderOutsideSet , y: borderOutsideSet , width: frame.size.width + borderOutsideSet * 2  , height: frame.size.height + borderOutsideSet * 2), cornerRadius: CGFloat(frame.size.height ))
     
    
        shape.path = path.cgPath
        shape.fillColor = UIColor.clear.cgColor
        shape.strokeColor = UIColor.white.cgColor
        
        shape.lineWidth = 2.5
        
      //  let borderOutsideSet:CGFloat = 2.0

      
        GradientBorderAnimationObj.gradientLayer?.frame = CGRect(x: frame.origin.x - borderOutsideSet * 2 , y:frame.origin.y - borderOutsideSet * 2 , width: frame.size.width + borderOutsideSet * 10, height: frame.size.height +  borderOutsideSet * 10)
        if colors == nil
        {
            GradientBorderAnimationObj.gradientLayer?.colors = [UIColor.blue.cgColor,
                                                                UIColor.green.cgColor]
        }
        else
        {
            
            GradientBorderAnimationObj.gradientLayer?.colors = colors
        }

        GradientBorderAnimationObj.gradientLayer?.startPoint = CGPoint(x: 0, y: 1)
        GradientBorderAnimationObj.gradientLayer?.endPoint = CGPoint(x: 1, y: 0)
        GradientBorderAnimationObj.gradientLayer?.mask = shape
        /*
         let newframe = CGRect(x: view.frame.origin.x - 30, y: view.frame.origin.y + 40, width: view.frame.size.width, height: view.frame.size.height)
         
         view.frame = newframe.insetBy(dx: borderOutsideSet * 3 , dy: borderOutsideSet * 3);
         view.layer.cornerRadius = (view.frame.size.width - borderOutsideSet  )/2
         */

     
        view.superview?.layer.addSublayer(GradientBorderAnimationObj.gradientLayer!)
        

   // view.layer.addSublayer(gradient)

        let animation = CABasicAnimation(keyPath: "strokeEnd")
        
        // Set the animation duration appropriately
        animation.duration = 2.5
    // Animate from 0 (no circle) to 1 (full circle)
        animation.fromValue = 0
        animation.toValue = 1
        
        // Do a linear animation (i.e. the speed of the animation stays the same)
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
     
        // Set the circleLayer's strokeEnd property to 1.0 now so that it's the
        // right value when the animation ends.
        shape.strokeEnd = 1.0
        // Do the actual animation
        
        shape.add(animation, forKey: "animateCircle")
    //    }
        
        
    }
    
    
    private var vibrancyEffectView:UIVisualEffectView?
    private var blurEffectView :UIVisualEffectView?
    private var tempView:UIView?

    
    func cloneViewToFrontAndBlurBackground(view:UIView,widthOffset:CGFloat,height:CGFloat)
    {
        tempView = view.clone()
        
        self.bringViewToFrontAndBlurBackground(view: tempView!, widthOffset: widthOffset, height: height)
    }
    
    func bringViewToFrontAndBlurBackground(view:UIView,widthOffset:CGFloat,height:CGFloat)
    {
        // tempView =  (view as! UIImageView).copyWithZone() as! UIView
        view.backgroundColor = UIColor.clear
        if blurEffectView != nil
        {
            return
        }
        tempView = view
        tempView?.frame = CGRect(x: widthOffset, y: (UIApplication.shared.keyWindow?.bounds)!.size.height/2 -  height/2, width: (UIApplication.shared.keyWindow?.bounds)!.size.width - widthOffset*2, height: height)
        
        //    view.frame = CGRect(x: widthOffset, y: (UIApplication.shared.keyWindow?.bounds)!.size.height/2 -  height/2, width: (UIApplication.shared.keyWindow?.bounds)!.size.width - widthOffset*2, height: height)
        
        // 1
        let blurEffect = UIBlurEffect(style: .light)
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        
        // 2
        vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)
        /// vibrancyEffectView?.contentView.addSubview(tempView!)
        // vibrancyEffectView?.contentView.bringSubview(toFront: tempView!)
        
        // vibrancyEffectView?.addSubview(tempView!)
        
        
        // 3
        blurEffectView =    UIVisualEffectView(effect: blurEffect)
        blurEffectView?.backgroundColor = UIColor.clear
        blurEffectView?.contentView.addSubview(vibrancyEffectView!)
        //4
        blurEffectView?.frame = (UIApplication.shared.keyWindow?.bounds)!
        vibrancyEffectView?.frame = (UIApplication.shared.keyWindow?.bounds)!
        //5
        
        //   UITapGestureRecognizer(target: self, action: #selector(ESAnimation.handleTap(sender:)))
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(sender:)))
        tap.delegate = self
        blurEffectView?.addGestureRecognizer(tap)
        
        //6
        UIApplication.shared.keyWindow?.addSubview(blurEffectView!)
        blurEffectView?.alpha = 0
        
        ESAnimation.shareInstance.fadeOutToAlpha(blurEffectView!, toAlpha: 0.975, withDuration: 0.4)
        
        UIApplication.shared.keyWindow?.addSubview(tempView!)
        UIApplication.shared.keyWindow?.bringSubview(toFront: tempView!)
        tempView?.alpha = 0.0
        ESAnimation.shareInstance.fadeIn(tempView!, withDuration: 0.6)
        
        /*
         DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 10) {
         
         // here code perfomed with delay
         self.removeFrontViewAndBlurBackground(view:view)
         }
         */
        
        //   UIApplication.shared.keyWindow?.layoutIfNeeded()
        //UIApplication.shared.keyWindow?.layoutSubviews()
        

        }
    func handleTap(sender: UITapGestureRecognizer? = nil) {
        // handling code
        
        self.removeFrontViewAndBlurBackground()
    }

    func removeFrontViewAndBlurBackground()
        {
            DispatchQueue.main.async {

              
            self.blurEffectView?.removeFromSuperview()
            self.tempView?.removeFromSuperview()
        //    self.tempView?.layer.sublayers?.removeAll()
            self.vibrancyEffectView?.removeFromSuperview()
                self.blurEffectView =  nil
                 self.tempView =  nil
      
            }
    }
    

    func resizeAnimation(view:UIView,newframe:CGRect,time:Double)
    {
  
        view.frame = newframe
        
        view.superview?.layoutIfNeeded()
        view.superview?.layoutSubviews()
        view.layoutIfNeeded()
        view.layoutSubviews()
    
        UIView.animate(withDuration: time, animations: {
           // self.view.layoutIfNeeded()
            
            
        view.superview?.layoutIfNeeded()
            view.superview?.layoutSubviews()
            view.layoutIfNeeded()
            view.layoutSubviews()
        })
        
        
    }

    
}
