//
//  LDALoadingHanlder.swift
//  LDAContactApp
//
//  Created by Mac on 6/28/17.
//  Copyright © 2017 LeDucAnh. All rights reserved.
//

import UIKit

class LDALoadingHanlder: NSObject {

    static var SharedInstance = LDALoadingHanlder()
    var waitingIndicator : NVActivityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 30, height: 30).returnCenterForSelf(), type: NVActivityIndicatorType.ballPulseSync, color: EnglishSocietyConfigurateVaribles.SharedInstance.ESGymRed, padding: 0)
    func applyIndicator(toview:UIView)
    {
        toview.addSubview(self.waitingIndicator)
        
    }
    func startIndicator()
    {
        
        
        waitingIndicator.startAnimating()
        
    }
    func stopAnimating()
    {
        
        waitingIndicator.stopAnimating()
        
    }
}
