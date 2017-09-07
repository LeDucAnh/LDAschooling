/*
 * Copyright (c) 2015 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
//
//  HSUTourRegistration.swift
//  HSUFreeWalkingtour
//
//  Created by Mac on 11/16/16.
//  Copyright © 2016 LeDucAnh. All rights reserved.
//



import Foundation
import Firebase

public enum EsCortRegistrationState:Int {
    case userApproved = 1, userPending = 0, userDenied = -1,teacherApproved = 11 ,teacherPending =  10,teacherDenied = -11
    
    var EsCortRegistrationState: Int {
        switch self {
        case .userApproved:
            return 1
        case .userPending:
            return 0
        case .userDenied:
            return -1
            
            
        case .teacherApproved:
            return 11
        case .teacherPending:
            return 10
        case .teacherDenied:
            return -11
        }
        
    }
    
}

public enum UserRole: Int {
    case none //0
    case student //1
    case teacher // 2
    case staff//3
    case admin//4
}

public enum UserRoleInString: String {
    case none  = "0"//0
    case student = "1"//1
    case teacher = "2"// 2
    case staff = "3"
    case admin = "4"
   
    static func UserRoleInstring(fromInt:Int)->UserRoleInString
    {
        var qRole = UserRoleInString.none
        
        
        
        if fromInt == UserRole.teacher.rawValue
        {
            qRole = UserRoleInString.teacher
        }
        if fromInt == UserRole.student.rawValue
        {
            qRole = UserRoleInString.student
        }
        if fromInt == UserRole.staff.rawValue
        {
            qRole = UserRoleInString.staff
        }
        if fromInt == UserRole.admin.rawValue
        {
            qRole = UserRoleInString.admin
        }
        return qRole
        
        
    }

}

struct User {
    var parent :String?
    var email: String
    var FBID : String
    var name :String
    var profileImageURL:String
    var password:String
    var firstName:String
    var RoleID:Float
    
    var role:UserRole = .none
  init(authData: FIRUser) {
  //  uid = authData.uid
    email = authData.email!
    FBID = ""
    name = ""
    profileImageURL = ""
    password = ""
    
    
    firstName = ""
    RoleID = -1
  }
  
  init(uid: String, email: String) {
    //self.uid = uid
    self.email = email
    FBID = ""
    name = ""
    profileImageURL = ""
    password = ""
    firstName = ""
    RoleID = -1

  }
    
    init(password: String, email: String) {
   //     self.uid = ""
        self.password = password
        self.email = email
        FBID = ""
        name = ""
        profileImageURL = ""
        firstName = ""
        RoleID = -1

    }
    
     func isNull()->Bool
    {
    if self.password == "" && self.name == "" && self.FBID == "" && self.profileImageURL == ""
    {
        return true
        }
        return false
    }
    init(snapshot: FIRDataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
     let   ref = snapshot.ref
        
        
        
        
        
        self.profileImageURL = ""
        self.name = ""

        self.FBID = ""
        
        self.email = ""
        
       // self.uid = ""
        RoleID = -1


        self.password = ""
        
        self.firstName = ""
        if let name = snapshotValue["name"]
        {
            self.name = name as! String
        }
        if let email = snapshotValue["email"]
        {
            self.email = email as! String
        }
        
        if let FBID = snapshotValue["FBID"]
        {
            self.FBID = FBID as! String
        }
        if let profileImageURL = snapshotValue["profileImageURL"]
        {
            self.profileImageURL = profileImageURL as! String
        }
      
        
        if let uid = snapshotValue["uid"]
        {
        //    self.uid = (ref.parent?.key)!
        }
        

        
        if let studentkey = snapshotValue["RoleID"]
        {
            self.RoleID = studentkey as! Float
        }
        
        if let role =  snapshotValue["role"]
        {
            self.role = UserRole(rawValue: role as! Int)!
        }

        
        
    }
    
    func toAnyObject() -> Any {
        return [
            "name": name,
            "email":email,
            "FBID":FBID,
            // "TourPickLat":TourPickLat,
            "profileImageURL":profileImageURL,
         //   "uid":uid,
            "password":password,
            "RoleID":RoleID,
            "role": role.rawValue
            
            
            
            
        ]
    }

    //sign in using fb sdk
    init(FbDict: NSDictionary) {
        
        self.password = ""
        RoleID = -1

       // self.uid = ""
        if(FbDict.object(forKey: "email") != nil)
        {
            self.email = (FbDict.object(forKey: "email") as? String)!
        }
        else
        {    self.email = ""
            
        }
        if(FbDict.object(forKey: "name") != nil)
        {
            
            self.name = (FbDict.object(forKey: "name") as? String)!
        }
        else
        {
            self.name = ""
        }
        if(FbDict.object(forKey: "id") != nil)
        {
            
            self.FBID = (FbDict.object(forKey: "id") as? String)!
        }
        else
        {
            self.FBID = ""
        }
        if(FbDict.object(forKey: "first_name") != nil)
        {
            
            self.firstName = (FbDict.object(forKey: "first_name") as? String)!
            
        }
        else
        {
            self.firstName = ""
        }
        // self.FBUserGeoPoint = PFGeoPoint()
        
        print(FbDict.object(forKey: "picture"))
        let dict:NSDictionary  =  FbDict.object(forKey: "picture") as! NSDictionary
        print(dict.object(forKey:  "data"))
        // print((FbDict.object(forKey: "picture") as AnyObject).object(ForKey:"data"))
        // print(((FbDict.objectForKey("picture") as AnyObject).object(ForKey:"data")? as AnyObject).objectForKey("url"))
        if(((FbDict.object(forKey: "picture") as! NSDictionary).object(forKey: "data") as! NSDictionary).object(forKey: "url") != nil)
        {
            self.profileImageURL = (((FbDict.object(forKey: "picture") as! NSDictionary).object(forKey: "data") as! NSDictionary).object(forKey: "url") as? String)!
        }
        else
        {
            self.profileImageURL = ""
        }
        
        
        /*
         FbUserEmail = Email
         FbUserId = id
         FbUserName = Name
         FbUserPicture = PictureDict
         */
    }

    

    
  
}
