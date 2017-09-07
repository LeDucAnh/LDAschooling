//
//  FirebaseConcurrencyAPI.swift
//  LDAContactApp
//
//  Created by Mac on 6/6/17.
//  Copyright © 2017 LeDucAnh. All rights reserved.
//
import UIKit
import Firebase



class FirebaseConcurrencyAPI: NSObject {
    
    let apiURL = "https://contactapp-fd758.firebaseio.com"
    
    static var SharedInstance = FirebaseConcurrencyAPI()
    func requestFirebaseWith(Collection:String,value:String,onFields:[String],_ completion:@escaping (_ snapshot:FIRDataSnapshot)->Void)
    {
        
        
        let ref  =  FIRDatabase.database().reference(fromURL: apiURL)
        
        
        for item in onFields
        {
    
      let requestREf =       ref.child(Collection).queryOrdered(byChild: item).queryStarting(atValue: value)
        
        

        // ResQuery = regRef.queryOrdered(byChild: "TourDateIntervalSince1970").queryEnding(atValue: lastObject.TourDateIntervalSince1970).queryLimited(toLast: 2)
            requestREf.observeSingleEvent(of: .value, with:
            {
                (snapshot) in
                
                    completion(snapshot)
            })
        }

    }
}
