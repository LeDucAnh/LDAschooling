//
//  EnglishSocietyConfigurateVaribles.swift
//  EnglishSociety
//
//  Created by Mac on 10/21/16.
//  Copyright © 2016 LeDucAnh. All rights reserved.
//

import UIKit

class EnglishSocietyConfigurateVaribles: NSObject {
static var SharedInstance = EnglishSocietyConfigurateVaribles()
    var ESnavigationControllerColor = UIColor(red: 255/255, green: 0, blue: 84/255.0, alpha: 1)
    var ESGreenColor = UIColor(red: 41/255, green: 171/225, blue: 23/255.0, alpha: 1)
   // var ESDarkBlack = UIColor(displayP3Red: 17/255, green: 17/255, blue: 17/255, alpha: 1)
    var ESDarkBlack = UIColor(red: 37/255, green: 37/255, blue: 37/255, alpha: 1)
    
    var ESColorArray = [UIColor]()
    var ESGold = UIColor(red: 255/255, green: 207/255, blue: 0/255, alpha: 1)
      var ESBlue = UIColor(red: 70/255, green: 93/255, blue: 172/255, alpha: 1)
        var ESGreen = UIColor(red: 41/255, green: 171/255, blue: 23/255, alpha: 1)
    
    var ESVintageGold  =  UIColor(red: 253/255, green: 253/255, blue: 164/255, alpha: 1)
    
    var ESGymOrange =   UIColor(red: 239/255, green: 145/255, blue: 24/255, alpha: 1)
    var ESGymRed  =  UIColor(red: 250/255, green: 0/255, blue: 52/255, alpha: 1)
    let ScreenSize  = UIScreen.main.bounds.size
    
    let Screenwidth  = UIScreen.main.bounds.size.width
    // static let sharedInstance = AppDelegate()

    func randColor()->UIColor
    {
        var colorarray =  self.bringtArray
        let max = colorarray.count - 1
        let randx = Int(arc4random_uniform(UInt32(max)))
return colorarray[randx]

    }
    var bringtArray = [UIColor]()

    override init() {
        
        self.ESColorArray = [
            UIColor(red: 119/255, green: 89/255, blue: 179/255, alpha: 1),
            UIColor(red: 255/255, green: 94/255, blue: 23/255, alpha: 1),
            UIColor(red: 22/255, green: 22/255, blue: 22/255, alpha: 1.0),
            UIColor(red: 33/255, green: 191/255, blue: 94/255, alpha: 1),
      UIColor(red: 45/255, green: 109/255, blue: 201/255, alpha: 1),
      UIColor(red: 255/255, green: 173/255, blue: 54/255, alpha: 1),
            UIColor(red: 232/255, green: 92/255, blue: 141/255, alpha: 1)]

        self.bringtArray = [
            UIColor(red: 119/255, green: 89/255, blue: 179/255, alpha: 1),
            UIColor(red: 255/255, green: 94/255, blue: 23/255, alpha: 1),
            UIColor(red: 33/255, green: 191/255, blue: 94/255, alpha: 1),
            UIColor(red: 45/255, green: 109/255, blue: 201/255, alpha: 1),
            UIColor(red: 255/255, green: 173/255, blue: 54/255, alpha: 1),
            UIColor(red: 232/255, green: 92/255, blue: 141/255, alpha: 1),ESnavigationControllerColor,UIColor.red,UIColor.yellow]
        

        
    }
    

}
