//
//  FbUser.swift
//  Feed Me
//
//  Created by DUCANH on 11/9/15.
//  Copyright © 2015 Ron Kliffer. All rights reserved.
//

import UIKit

import FBSDKLoginKit

class FbUser: NSObject {

  
  
  var FbUserEmail :String? = nil
  var FbUserFirstName :String? =  nil
  var FbUserId :String? = nil
  //let FbUserLastName :String
  var FbUserName :String? = nil
  var FbUserPicture :String? = nil
 // var FBUserGeoPoint: PFGeoPoint? = nil
  var FBUserAccessToken : FBSDKAccessToken? = nil
  
  
  /*
  init(dict:NSDictionary)
  {
    self.FbUserId = dict.objectForKey("") as! String
    
  }
  */
    /*
  override func hostToKinveyPropertyMapping() -> [AnyHashable: Any]! {
    return [
      "FbUserId" : KCSEntityKeyId, //the required _id field
      "FbUserName" : "name",
      "FbUserPicture" : "Pic",
      "FbUserEmail" : "Email",
     // "metadata" : KCSEntityKeyMetadata //optional _metadata field
    ]
  }
  init(ParseUserObject: PFObject)
  {
 
    if let email = ParseUserObject.object(forKey: "User_FB_Email") as? String
    {
    self.FbUserEmail = email
    }
    if let name = ParseUserObject.object(forKey: "User_Name") as? String
    {
      self.FbUserName = name
    }
    
    self.FBUserGeoPoint = ParseUserObject.object(forKey: "User_GeoPoint") as? PFGeoPoint
    self.FbUserId = ParseUserObject.object(forKey: "User_FB_ID") as? String
    self.FbUserPicture = ParseUserObject.object(forKey: "User_FB_ProfilePicture") as? String
    
  }
 */
  
  //sign in using fb sdk
  init(FbDict: NSDictionary) {
   
    
    if(FbDict.object(forKey: "email") != nil)
    {
    self.FbUserEmail = FbDict.object(forKey: "email") as? String
    }
    else
    {    self.FbUserEmail = ""
      
    }
    if(FbDict.object(forKey: "name") != nil)
    {

    self.FbUserName = FbDict.object(forKey: "name") as? String
    }
    else
    {
      self.FbUserName = ""
    }
    if(FbDict.object(forKey: "id") != nil)
    {

    self.FbUserId = FbDict.object(forKey: "id") as? String
    }
    else
    {
     self.FbUserId = ""
    }
    if(FbDict.object(forKey: "first_name") != nil)
    {

    self.FbUserFirstName = FbDict.object(forKey: "first_name") as? String
      
    }
    else
    {
      self.FbUserFirstName = ""
    }
 // self.FBUserGeoPoint = PFGeoPoint()
    
    print(FbDict.object(forKey: "picture"))
    let dict:NSDictionary  =  FbDict.object(forKey: "picture") as! NSDictionary
    print(dict.object(forKey:  "data"))
   // print((FbDict.object(forKey: "picture") as AnyObject).object(ForKey:"data"))
   // print(((FbDict.objectForKey("picture") as AnyObject).object(ForKey:"data")? as AnyObject).objectForKey("url"))
    if(((FbDict.object(forKey: "picture") as! NSDictionary).object(forKey: "data") as! NSDictionary).object(forKey: "url") != nil)
    {
    self.FbUserPicture = ((FbDict.object(forKey: "picture") as! NSDictionary).object(forKey: "data") as! NSDictionary).object(forKey: "url") as? String
    }
    else
    {
      self.FbUserPicture = ""
    }
        
   
    /*
    FbUserEmail = Email
    FbUserId = id
    FbUserName = Name
    FbUserPicture = PictureDict
*/
  }
  
  /*  name = "Ashish Kakkad";

  picture =     {
  data =         {
  "is_silhouette" = 0;
  url = "https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xfa1/v/t1.0-1/s200x200/22501_915701971820048_9046303472199214595_n.jpg?oh=f3b3564f1450c13332b3067a135cad5d&oe=55C71792&__gda__=1443571904_c4667dcb08d85682edfd77a90ee9c3ab";
  };
  };
  */
}
