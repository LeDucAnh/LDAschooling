//
//  FirebaseTeacherAPI.swift
//  LDAContactApp
//
//  Created by Mac on 4/21/17.
//  Copyright © 2017 LeDucAnh. All rights reserved.
//

import UIKit
import Firebase
    class FirebaseTeacherAPI: NSObject {
        let teacherREF = FIRDatabase.database().reference(withPath: "LDACAUsers")
        
        static var shareInstance = FirebaseTeacherAPI()
        let apiURL = "https://contactapp-fd758.firebaseio.com"
        
        
        
        func registerForAddedTeacher(_ completion:@escaping (_ class: [LDACATeacher])->Void)
        {
            // ResQuery.observe(.value, with: { snapshot in
            // let ResQuery = regRef.queryLimited(toLast:2)
            // classRef.queryOrdered(byChild: "classDaysArray")
            let ref  =  FIRDatabase.database().reference(fromURL: apiURL)

            ref.child("LDACAUsers").observe(.childAdded, with:
                {
                    snapshot in
                    
                    // 3
                    var newItems: [LDACATeacher] = []
                    // for item in snapshot.children {
                    // 4
                    let newteacher = LDACATeacher(snapshot: snapshot )
                    newItems.append(newteacher)
                    //}
                    
                    // 5
                    
                    completion(newItems)
            })
            
        }

        func checkRegis(privatekey:String,teacherID:String,completion:@escaping (_ success:Bool)->Void)
        {
            
            
            if !privatekey.checkValidFirebaseChildString(string: privatekey)
            {
                completion(false)
            }
            else
            {
                let ref  =  FIRDatabase.database().reference(fromURL: apiURL)
                let usersRef  =  ref.child("LDACAUsers")
                
                usersRef.child(privatekey).observeSingleEvent(of: FIRDataEventType.value, with: { (snapshot) in
                    
                    
                    
                    if let teacher  = LDACATeacher(snapshot: snapshot) as? LDACATeacher
                    {
                        
                        //print(usersRef.child(privatekey).parent?.key)
                        print(privatekey)
                        print(teacher.teacherID)
                        print(teacherID)
                        if teacher.teacherID == Float(teacherID)
                        {
                            completion(true)
                        }
                        completion(false)
                        
                    }
                    
                })
            }
            
        }
        func registerUserWithTeacherID(teacherID :String,privateKey:String,completion:@escaping (_ success:Bool)->Void)
        {
            /*
            self.checkRegis(privatekey: privateKey, teacherID: teacherID) { (success) in
                
                if success
                {
                    
                    FirebaseAuthAPI.shareInstance.currentUser?.role = UserRole.teacher
                    FirebaseAuthAPI.shareInstance.currentUser?.RoleID = teacherID
                    FirebaseAuthAPI.shareInstance.updateUserToDatabse(FirebaseAuthAPI.shareInstance.currentUser!, uidString: (FIRAuth.auth()?.currentUser?.uid)!) { (Bool) in
                        
                        
                        if Bool
                        {
                            completion(true)
                        }else
                        {
                            completion(false)
                        }
                    }
                    
                }
                else
                {
                    completion(false)
                    
                    
                }
                
                
            }
 */
        }
        
        func updateTeacherUser(_ teacher:LDACATeacher,completion:@escaping (_ DidSignIn:Bool)->Void)
        {
            
            
            let ref  =  FIRDatabase.database().reference(fromURL: apiURL)
            let usersRef  =  ref.child("LDACAUsers")
            let userref = usersRef.childByAutoId()
            
            
            
            
            // print(teacher.teacherID)
            
            //print()
            print(String(describing: Int(teacher.teacherID!)))
            
            
            //checkif teachers contains teacher with id
            let query = usersRef.queryOrdered(byChild: "teacherID").queryEqual(toValue:teacher.teacherID!)
            query.observe(.value, with: { (snapshot) in
                
                // done checkif teachers contains teacher with id
                if  snapshot.children.allObjects.count == 0
                {
                    
                    let values  = teacher.toAnyObject() as! [String : Any]
                    
                    
                    userref.updateChildValues(values) { (Error, FIRDatabaseReference) in
                        
                        //update user
                        if Error == nil
                        {
                            //successfully updated user
                            
                            completion(true)
                        }
                        else
                        {
                            completion(false)
                            
                        }
                    }
                    
                    
                }else{
                    //their is a child
                    print("error")
                    
                    
                }
                
                
                
                
                
                
                
                
            })
            
            
        }
        
        
        
    }


