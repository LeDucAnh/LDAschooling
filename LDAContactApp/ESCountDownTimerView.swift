//
//  ESCountDownTimerView.swift
//  EnglishSociety
//
//  Created by Mac on 10/24/16.
//  Copyright © 2016 LeDucAnh. All rights reserved.
//

import UIKit

class ESCountDownTimerView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    static let shareinstance = ESCountDownTimerView()
    var backgroundPlayingColor = UIColor.white
    var backgroundRenderingColor = UIColor.red
    var startTime : Double?
    var gametime  = 120.0
    var gameTimer :Timer?
    var originalWidth :CGFloat?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame =  frame
        
        
        DispatchQueue.main.async {

    //        let screenWidth =  UIScreen.main.bounds.size.width
      //  self.originalWidth = screenWidth
let screenWidth =  frame.size.width
            self.originalWidth =
            screenWidth
            
        }
        
        
    }
    
    convenience init () {
        self.init(frame:CGRect.zero)
    }
    
    required init(coder aDecoder: NSCoder) {
        
       
        super.init(coder: aDecoder)!
    
        
       // fatalError("This class does not support NSCoding")
    }
    func reset ()
    {
        self.frame.size.width = self.originalWidth!
        self.gameTimer?.invalidate()
        self.gameTimer =  nil
        
    }
    func startCountDown(_ startTime:Double)
    {
        self.gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
       
        self.startTime = startTime
        gametime = startTime
        originalWidth = self.frame.size.width
        

    }
    func setValue(_ currentValue:Double,_ maxValue:Double)
   {
    
    DispatchQueue.main.async {
        let leftTimeRateToMaxValue:Double =  Double(currentValue/maxValue)
       
        self.frame.size.width = self.originalWidth! * CGFloat(leftTimeRateToMaxValue)
        print(self.frame.size.width)
    }
    

    }
   
  @objc fileprivate  func update() {
    
        if(gametime > 0) {
           
            //     countDownLabel.text = String(gametime--)
            DispatchQueue.main.async {
                self.gametime = self.gametime - 1
                let leftTimeRateToMaxValue =  self.gametime/self.startTime!
                print(leftTimeRateToMaxValue)
                self.frame.size.width = self.originalWidth! * CGFloat(leftTimeRateToMaxValue)
            }
            
            
        }
        else{
            
        }
    }

  
}
