//
//  LDATextHelpers.swift
//  LDAContactApp
//
//  Created by Mac on 4/11/17.
//  Copyright © 2017 LeDucAnh. All rights reserved.
//

import UIKit

class LDATextHelpers: NSObject {

    static var sharedInstance = LDATextHelpers()
    func heightForView(_ text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        
        
        
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }

}
