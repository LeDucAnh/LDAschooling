
//
//  LDAActionResultHanlder.swift
//  LDAContactApp
//
//  Created by Mac on 6/10/17.
//  Copyright © 2017 LeDucAnh. All rights reserved.
//

import UIKit
import Whisper

public enum LDAActionResultHandlerType
{
    case success
    case fail
}
class LDAActionResultHandler: NSObject {

    static var sharedInstance = LDAActionResultHandler()
    
    
    func handleAction(title:String,returnCase:LDAActionResultHandlerType)
    {
        var murmur = Murmur(title: title)
        murmur.titleColor = UIColor.white
        murmur.font = UIFont.systemFont(ofSize: 15.0)
        
        
        if returnCase == LDAActionResultHandlerType.fail
        {
            murmur.backgroundColor = EnglishSocietyConfigurateVaribles.SharedInstance.ESGymRed
        }
        
        if returnCase == LDAActionResultHandlerType.success
        {
            murmur.backgroundColor = UIColor.green
        }
        
        
        // Show and hide a message after delay
        Whisper.show(whistle: murmur, action: .show(0.5))
        
        // Present a permanent status bar message
        Whisper.show(whistle: murmur, action: .present)
        
        // Hide a message
        Whisper.hide(whistleAfter: 3)
        
    }
    
    func notqualifiedRole(expectedRole:Int)
    {
        let userrole =  UserRoleInString.UserRoleInstring(fromInt: (FirebaseAuthAPI.shareInstance.currentLDACAUSer?.role)!)
        
        let expectedRole =  UserRoleInString.UserRoleInstring(fromInt: (expectedRole))
        

        let string = "User Role is \(userrole) not qualified to the expected \(expectedRole) Role"
        LDAActionResultHandler.sharedInstance.handleAction(title: string, returnCase: .fail)

    }
    
    func handleAction(title:String)
    {
        var murmur = Murmur(title: title)
        murmur.titleColor = UIColor.white
        murmur.font = UIFont.systemFont(ofSize: 15.0)
        
        
        murmur.backgroundColor = EnglishSocietyConfigurateVaribles.SharedInstance.ESGymRed
        
        // Show and hide a message after delay
        Whisper.show(whistle: murmur, action: .show(4))
        
        // Present a permanent status bar message
        Whisper.show(whistle: murmur, action: .present)
        
        // Hide a message
        Whisper.hide(whistleAfter: 3)

    }

}
