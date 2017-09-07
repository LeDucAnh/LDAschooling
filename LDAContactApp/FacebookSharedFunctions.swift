//
//  FacebookSharedFunctions.swift
//  LDAContactApp
//
//  Created by Mac on 4/7/17.
//  Copyright © 2017 LeDucAnh. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit


class FacebookSharedFunctions: NSObject {

    static var sharedInstance = FacebookSharedFunctions()
    func GetFacebookUserProfile(_ completion:@escaping (_ userFBDict:NSDictionary)->Void)
    {
        if (FBSDKAccessToken .current() != nil)
        {
            let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"])
            graphRequest.start(completionHandler: { (connection, result, error) -> Void in
                if ((error) != nil)
                {
                    // Process error
                    print("Error: \(error)")
                    //  completion(nil)
                    
                }
                else
                {
                    let userFBInfoDict = result as! NSDictionary
                    completion(userFBInfoDict)
                }
                
            })
        }
        
        
    }

}
