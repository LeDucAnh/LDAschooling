//
//  LDAUIHelpers.swift
//  LDAContactApp
//
//  Created by Mac on 4/11/17.
//  Copyright © 2017 LeDucAnh. All rights reserved.
//

import UIKit

class LDAUIHelpers: NSObject {
    static var sharedInstance = LDAUIHelpers()
    func setupVCforLDA(vc:UIViewController)
    {
        vc.navigationController?.navigationBar.isTranslucent  =  false
        vc.navigationController?.navigationBar.tintColor = EnglishSocietyConfigurateVaribles.SharedInstance.ESGymRed
                vc.tabBarController?.tabBar.tintColor = EnglishSocietyConfigurateVaribles.SharedInstance.ESGymRed

        let font = UIFont.boldSystemFont(ofSize: 15.0)
        
        
        vc.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: font]
        
        
       
        
        
        vc.navigationController?.navigationBar.barTintColor = UIColor.white
        vc.tabBarController?.tabBar.barTintColor = UIColor.white
        
        UIApplication.shared.statusBarStyle = .lightContent

    }
}
