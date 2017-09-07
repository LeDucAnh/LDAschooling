//
//  AddFileManager.swift
//  LDAContactApp
//
//  Created by Mac on 6/3/17.
//  Copyright © 2017 LeDucAnh. All rights reserved.
//

import Foundation
import React

@objc(AddFileManager)

class AddFileManager: NSObject {
    var bridge: RCTBridge!
    
    static var ShareInstance = AddFileManager()
    var didUploadFileReturnAction:((_ url:String)->Void)!
    
    func registerForUploadFileReturnAction(action:@escaping (_ url:String)->Void)
        
    {
        self.didUploadFileReturnAction = action
    }
    
    
    var dismissReturnAction : (()->Void)!

    func registerForDismissReturnAction(action:@escaping ()->Void)
        
    {
        AddFileManager.ShareInstance.dismissReturnAction = action
    }
    
 


    @objc func dismissPresentedViewController() {
        
        print("Exit Done")
        AddFileManager.ShareInstance.dismissReturnAction()
    }
 
    
    

    @objc func didCompleUploadFileWithFileURL(_ url: NSString) {
        DispatchQueue.main.async {
            print("this is fucking bullshit")
            
            print(url)
            AddFileManager.ShareInstance.didUploadFileReturnAction(url as String)
            
            
        }
    }
    

}

