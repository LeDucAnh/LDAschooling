//
//  LDACAUploadImageViewController.swift
//  LDAContactApp
//
//  Created by Mac on 6/2/17.
//  Copyright © 2017 LeDucAnh. All rights reserved.
//

import UIKit

import React

class LDACAUploadImageViewController: UIViewController {

    var reactNativeuploadVC: RCTRootView!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reactNativeuploadVC = MixerReactModule.sharedInstance.viewForModule(
            "Demo",
            initialProperties: ["UserID": "abc"])
        self.view.addSubview(reactNativeuploadVC)
AddFileManager.ShareInstance.registerForDismissReturnAction { 
    
    self.dismiss(animated: true, completion: nil)
        }
        AddFileManager.ShareInstance.registerForUploadFileReturnAction { (urlString) in
            
            FirebaseLDACAUserAPI.shareInstance.updateUserProfileImageURL(user: FirebaseAuthAPI.shareInstance.currentLDACAUSer!, url: urlString, completion: { (Bool) in
                
                //
                
                
                
            })
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Layout React View
        reactNativeuploadVC.frame = self.view.bounds
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
