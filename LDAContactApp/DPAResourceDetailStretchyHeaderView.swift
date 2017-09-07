//
//  DPAResourceDetailStretchyHeaderView.swift
//  DiepPhapAm
//
//  Created by Mac on 8/24/16.
//  Copyright © 2016 LeDucAnh. All rights reserved.
//

import UIKit
import SDWebImage

protocol DPAResourceDetailStretchyHeaderViewDelegate
{
    func EscortButtonDidTouch()
    
}

class DPAResourceDetailStretchyHeaderView: GSKStretchyHeaderView {
    @IBAction func EscortButtonDidTouch(_ sender: Any) {
        self.delegate?.EscortButtonDidTouch()
    }
    var delegate : DPAResourceDetailStretchyHeaderViewDelegate?
    
    
    
    @IBOutlet weak var HSUFWTEscortRegistrationButton: UIButton!
    
    
    @IBOutlet weak var HSUFWTUserNameLabel: UILabel!

    @IBOutlet weak var HSUFWTUserProfileImageview: UIImageView!
    @IBOutlet weak var DPAResourceDetailStretchyHeaderView_ResourceImageView: UIImageView!
    override func willChangeStretchFactor() {
        
        if let index =   ESAnimation.shareInstance.findIndex(ofView: self.HSUFWTUserProfileImageview, in: ESAnimation.shareInstance.GradientBorderAnimationObjectArr)
        {
            
            let mylayer =  ESAnimation.shareInstance.GradientBorderAnimationObjectArr[index].gradientLayer
            
            for layer in (HSUFWTUserProfileImageview.superview?.layer.sublayers)!
            {
                let borderOutsideSet:CGFloat = 2.0
                
                if let layer  = mylayer
                {
                    DispatchQueue.main.async {

                    layer.frame = CGRect(x: self.HSUFWTUserProfileImageview.frame.origin.x - borderOutsideSet * 2 , y:self.HSUFWTUserProfileImageview.frame.origin.y - borderOutsideSet * 2 , width: self.HSUFWTUserProfileImageview.frame.size.width + borderOutsideSet * 10, height: self.HSUFWTUserProfileImageview.frame.size.height +  borderOutsideSet * 10)
                    }
                }
            }
            
        }
        

    }
    override func didChangeStretchFactor(_ stretchFactor: CGFloat) {
        
        
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    func setEscortButtonText(_ text:String)
    {
        HSUFWTEscortRegistrationButton.setTitle(text, for: .normal)
        
    }

    func setRingOnImageView()
    {
        
      ESAnimation.shareInstance.executeGradientBorderAnimationFor(view: self.HSUFWTUserProfileImageview, colors: [UIColor.white.cgColor,UIColor.red.cgColor,UIColor.orange.cgColor])
        ESAnimation.shareInstance.shakeView(self.HSUFWTUserProfileImageview, updown: 2, leftright: 0.4)
    }
        func setLabelText(_ text:String)
    {
        self.HSUFWTUserNameLabel.text = text
    }
    func setImageViewWithURL(_ pictureURL:String)
    {
        self.DPAResourceDetailStretchyHeaderView_ResourceImageView.sd_setImage(with: URL(string: (pictureURL )) as URL!)
                self.HSUFWTUserProfileImageview.sd_setImage(with: URL(string: (pictureURL )) as URL!)
        
    }
}
