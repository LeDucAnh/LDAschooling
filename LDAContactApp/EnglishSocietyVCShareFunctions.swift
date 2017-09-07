//
//  EnglishSocietyVCShareFunctions.swift
//  EnglishSociety
//
//  Created by Mac on 10/26/16.
//  Copyright © 2016 LeDucAnh. All rights reserved.
//

import UIKit
import Eureka
import AVFoundation
extension Dictionary {
    mutating func update(_ other:Dictionary) {
        for (key,value) in other {
            self.updateValue(value, forKey:key)
        }
    }
}


class EnglishSocietyVCShareFunctions: NSObject {
static var SharedInstance = EnglishSocietyVCShareFunctions()
    func setupView(_ vc:UIViewController)
    {
        vc.navigationController?.navigationBar.isTranslucent  =  false
        vc.navigationController?.navigationBar.tintColor = UIColor.white
        let font = UIFont.boldSystemFont(ofSize: 15.0)
        
        
        vc.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: font]
        
        vc.navigationController?.navigationBar.barTintColor = EnglishSocietyConfigurateVaribles.SharedInstance.ESDarkBlack
        vc.tabBarController?.tabBar.barTintColor = EnglishSocietyConfigurateVaribles.SharedInstance.ESDarkBlack
        
        
        UIApplication.shared.statusBarStyle = .lightContent

    }
    func checkIfRegistrationFormNil(_ form:Form) -> Bool
    {
        
    return true
        /*
        if let row =    form.rowBy(tag:"Loc")! as? LocationRow {
            if   row.value == nil{
                return true
            }
        }
        if let row =    form.rowBy(tag:"Name")! as? NameRow {
            
            if   row.value == nil{
                return true

            }
            
        }
        if let row =    form.rowBy(tag:"Phone")! as? PhoneRow {
            
            if row.value == nil{
                return true

                
                        }
            
            
        }
        if let row =    form.rowBy(tag:"Email")! as? EmailRow {
            
            if row.value == nil
            {
                return true

            }
            
        }
        if let row =    form.rowBy(tag:"Date")! as? DateRow {
            
            if row.value == nil
            {
                return true

            }
            
            
        }
        if let row =    form.rowBy(tag:"Peoples")! as? IntRow {
            if row.value == nil
            {
            }
            
            
        }
        if let row =    form.rowBy(tag:"Address")! as? TextRow {
            if row.value == nil
            {
                return true

                            }
            
        }
        if let row =    form.rowBy(tag:"Request")! as? TextRow {
            if row.value == nil
            {
                return true

            }
            
            
        }
        if let row =    form.rowBy(tag:"Note")! as? TextRow {
            if row.value == nil
            {
                return true

            }
            
            
            
        }

        
        return false
 */
        
    }
    func simpleHideView(_ view:UIView,time:Double)
    {
        if view.alpha == 0
        {
            return
            
        }

        DispatchQueue.main.async {

        view.alpha = 1.0
        UIView.animate(withDuration: time, animations: {
            
            view.alpha = 0.0
            view.isHidden =  true
            
        })
        }

    }
    func simpleShowView(_ view:UIView,time:Double)
    {
        if view.alpha == 1
        {
            return
            
        }
        DispatchQueue.main.async {
        view.alpha = 0.0
        UIView.animate(withDuration: time, animations: {
            
            view.alpha = 1.0
            view.isHidden =  false

        })
        }
        
    }

    func setlabelToChalk(_ label:UILabel,size:CGFloat)
    {
        label.font  =  UIFont(name: "Chalkduster", size: size)
        label.textColor = UIColor.white
        
        
    }
    func setlabelToAmericanTypeWriterFont(_ label:UILabel,size:CGFloat)
    {
        label.font  =  UIFont(name: "American TypeWriter", size: size)
        label.textColor = UIColor.white
        
        
    }

    func heightForView(_ text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
       
        
        
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
    func setStatusBarBackgroundColor(_ color: UIColor) {
        
        guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
        
        statusBar.backgroundColor = color
    }
    func generateThumbnailFormCurrentAVPlayerTime(_ avplayer:AVPlayer,completion:@escaping (_ thumbnail:UIImage)->Void)
        
    {
       // var sourceURL = URL(string: "Your Asset URL")
        let asset = (avplayer.currentItem?.asset)!
        
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        //appliesPreferredTrackTransform
        imageGenerator.appliesPreferredTrackTransform =  true
        let currentTime = avplayer.currentItem?.currentTime()
        let imageRef = try! imageGenerator.copyCGImage(at: currentTime!, actualTime: nil)
        let thumbnail = UIImage(cgImage:imageRef)
        completion(thumbnail)
        

    }


    
    
}
