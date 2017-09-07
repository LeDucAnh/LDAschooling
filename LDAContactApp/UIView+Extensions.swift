//
//  UIView+Extensions.swift
//  LDAContactApp
//
//  Created by Mac on 5/16/17.
//  Copyright © 2017 LeDucAnh. All rights reserved.
//

import UIKit

public enum LDACAAnchorKey : Int
{
    case top
    case left
    case bottom
    case right
    case widthConstant
    case heightConstant
    
}
public class LDACAAnchorValue
{
    var AnchorValues : [String:NSLayoutConstraint]?
    
    init(AnchorValues:[String:NSLayoutConstraint])
    {
        self.AnchorValues = AnchorValues
    }
    func anchorValueWithLDACAAnchorKey(_  key :LDACAAnchorKey ) -> NSLayoutConstraint
    {
        
        
        
     return   self.AnchorValues![String(key.rawValue)]!
     // return  (self.AnchorValueArr?[key.rawValue])!
        
    }
}

//CGRect Extensions
extension CGRect{
    public func returnCenterForSelf() -> CGRect
    {
        let x = EnglishSocietyConfigurateVaribles.SharedInstance.ScreenSize.width/2 - self.size.width/2
        let y = EnglishSocietyConfigurateVaribles.SharedInstance.ScreenSize.height/2 -  self.size.height/2
        
   return  CGRect(x: x, y: y, width: self.size.width, height: self.size.height)
        
    }
 
}
extension UIView {
    
    public func addConstraintsWithFormat(_ format: String, views: UIView...) {
        
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
    public func fillSuperview() {
        translatesAutoresizingMaskIntoConstraints = false
        if let superview = superview {
            leftAnchor.constraint(equalTo: superview.leftAnchor).isActive = true
            rightAnchor.constraint(equalTo: superview.rightAnchor).isActive = true
            topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
            bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
        }
    }
    
    public func anchor(_ top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, topConstant: CGFloat = 0, leftConstant: CGFloat = 0, bottomConstant: CGFloat = 0, rightConstant: CGFloat = 0, widthConstant: CGFloat = 0, heightConstant: CGFloat = 0) -> LDACAAnchorValue {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        
        return LDACAAnchorValue(AnchorValues: anchorWithReturnAnchors(top, left: left, bottom: bottom, right: right, topConstant: topConstant, leftConstant: leftConstant, bottomConstant: bottomConstant, rightConstant: rightConstant, widthConstant: widthConstant, heightConstant: heightConstant))
    }
    
    public func anchorWithReturnAnchors(_ top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, topConstant: CGFloat = 0, leftConstant: CGFloat = 0, bottomConstant: CGFloat = 0, rightConstant: CGFloat = 0, widthConstant: CGFloat = 0, heightConstant: CGFloat = 0) -> [String:NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false
        
        var anchors = [NSLayoutConstraint]()
        
        var anchorValues = [String:NSLayoutConstraint]()
        
        if let top = top {
            
            anchorValues["0"] = topAnchor.constraint(equalTo: top, constant: topConstant)
            anchorValues["0"]?.isActive = true
           // anchors.append(topAnchor.constraint(equalTo: top, constant: topConstant))
        }
        
        if let left = left {
            
            
            anchorValues["1"] = leftAnchor.constraint(equalTo: left, constant: leftConstant)
            anchorValues["1"]?.isActive = true
           // anchors.append(leftAnchor.constraint(equalTo: left, constant: leftConstant))
        }
        
        if let bottom = bottom {
            
            
            
            anchorValues["2"] = bottomAnchor.constraint(equalTo: bottom, constant: -bottomConstant)
            anchorValues["2"]?.isActive = true
           // anchors.append(bottomAnchor.constraint(equalTo: bottom, constant: -bottomConstant))
        }
        
        if let right = right {
            
            anchorValues["3"] = rightAnchor.constraint(equalTo: right, constant: -rightConstant)
            anchorValues["3"]?.isActive = true
            
          //  anchors.append(rightAnchor.constraint(equalTo: right, constant: -rightConstant))
        }
        
        if widthConstant >= 0 {
            
            anchorValues["4"] = widthAnchor.constraint(equalToConstant: widthConstant)
            anchorValues["4"]?.isActive = true
            
            
            //anchors.append(widthAnchor.constraint(equalToConstant: widthConstant))
        }
        
        if heightConstant >= 0 {
            
            anchorValues["5"] = heightAnchor.constraint(equalToConstant: heightConstant)
            anchorValues["5"]?.isActive = true
            
          //  anchors.append(heightAnchor.constraint(equalToConstant: heightConstant))
        }
        
     //   anchors.forEach({$0.isActive = true})
        
        return anchorValues
    }
    
    public func anchorCenterXToSuperview(constant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        if let anchor = superview?.centerXAnchor {
            centerXAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        }
    }
    
    public func anchorCenterYToSuperview(constant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        if let anchor = superview?.centerYAnchor {
            centerYAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        }
    }
    
    public func anchorCenterSuperview() {
        anchorCenterXToSuperview()
        anchorCenterYToSuperview()
    }
}
