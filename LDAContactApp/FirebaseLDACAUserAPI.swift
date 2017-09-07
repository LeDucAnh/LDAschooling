//
//  FirebaseLDACAUserAPI.swift
//  LDAContactApp
//
//  Created by Mac on 4/14/17.
//  Copyright © 2017 LeDucAnh. All rights reserved.
//

import UIKit
import Firebase

extension String
{
    
    func checkemptyString(string:String)->Bool
    {
        if string.characters.count == 0
        {
            return false
        }
        return true

    }
  
    func checkValidFirebaseChildString(string:String)->Bool
    {
        
        
        if !string.checkemptyString(string: string)
        {
            return false
        }
          let exceptionChar = [".","$","#","[","]"]
        for char in exceptionChar
        {
            if string.contains(char)
            
            {
                return false
            }
        }
       return true
    }
}


class FirebaseLDACAUserAPI: NSObject {
    let studentREF = FIRDatabase.database().reference(withPath: "LDACAUsers")
    
    static var shareInstance = FirebaseLDACAUserAPI()
    let apiURL = "https://contactapp-fd758.firebaseio.com"
    let LDACAUserByRoleref  =  FIRDatabase.database().reference(fromURL: "https://contactapp-fd758.firebaseio.com").child("LDACAUsersByRole")

    /*
    have to implement this function
    func searchClassWithNameValue(value:String,_ completion:@escaping (_ classes: [LDACAClass])->Void)
    {
        
        
        var newItems: [LDACAClass] = []
        //  FirebaseConcurrencyAPI.SharedInstance.requestFirebaseWith(Collection: "Classes", value: value, onFields: supportField) { (snapshot) in
        
        
        let endvalue = value + "\u{f8ff}"
        
        
        let requestREf = classRef.queryOrdered(byChild: "className").queryStarting(atValue: value).queryEnding(atValue: endvalue )
        
        
        // ResQuery = regRef.queryOrdered(byChild: "TourDateIntervalSince1970").queryEnding(atValue: lastObject.TourDateIntervalSince1970).queryLimited(toLast: 2)
        requestREf.observeSingleEvent(of: .value, with:
            {
                (snapshot) in
                
                
                for item in snapshot.children {
                    // 4
                    
                    
                    print(snapshot.key)
                    
                    print(snapshot.value)
                    print(snapshot.ref.parent)
                    print(snapshot.ref.parent?.key)
                    
                    
                    let newclass = LDACAClass(snapshot: item as! FIRDataSnapshot, parent: (item as AnyObject).key)
                    newItems.append(newclass)
                    newclass.getStudentIDForSelf()
                }
                
                completion(newItems)
                
                
        })
        
        
        
        // }
    }
    

 */
    
    func returnConversationUserWithUserFromCurrentUser(completion:@escaping (_ user : [LDACAUser])->Void)
        
    {
        
        
        var users = [LDACAUser]()

        Conversation.showConversations { (conversations) in
            conversations.sorted{ $0.lastMessage.timestamp > $1.lastMessage.timestamp }
            
        
            
            var bool = false
            if users.count == 0
            {
                bool = true
            }
            
            for conversation  in   conversations
            {
                users.append(conversation.user)
                
            }
            
            if bool
            {
            completion(users)
            }

        }

        
    }
    //MARK : CHECK USER WITH ROLE
    
    
    func registerForUserDataChange(user:LDACAUser,completion:@escaping (_ user : LDACAUser)->Void)
    {
        let ref  =  FIRDatabase.database().reference(fromURL: apiURL)
        
        
        let studentpRef  =  ref.child("LDACAUsers").child(String(Int(user.roleID!)))

        studentpRef.observe(.childChanged, with: { (FIRDataSnapshot) in
            
            
            print(FIRDataSnapshot)
            print(FIRDataSnapshot.key)
            print(FIRDataSnapshot.value)
            
            
            user.setValuewith(Key: FIRDataSnapshot.key, value: FIRDataSnapshot.value, { (Bool) in
                
                completion(user)

            })

        })
        
    }
    func getLDACAUserForCurrentFirebaseUser(user:User,completion:@escaping (_ users: [LDACAUser])->Void)
    {
        let ref  =  FIRDatabase.database().reference(fromURL: apiURL)
        let studentRef  =  ref.child("LDACAUsers")
        
        
        print(user.RoleID)
        let ResQuery = studentRef.queryOrdered(byChild: "roleID").queryEqual(toValue: user.RoleID)
        
            ResQuery.observeSingleEvent(of: .value, with:
                {
                    (snapshot) in
                    
                    // ResQuery.observe(.value, with: { snapshot in
                    // 2
                    
                    // 3
                    var newItems: [LDACAUser] = []
                    
                    for item in snapshot.children {
                        // 4
                        let post = LDACAUser(snapshot: item as! FIRDataSnapshot)
                        //  let registration = HSUTourRegistration(snapshot: item as! FIRDataSnapshot)
                        
                        if user.role.rawValue == post.role
                            {
                                
                        newItems.append(post)
                        }
                        
                    }
                    
                    // 5
                    
                    completion(newItems)
                    
        })

    }
    
    func getUserWithID(_ id:String,completion:@escaping (_ students: [LDACAUser])->Void)
        
        {
        
        let ref  =  FIRDatabase.database().reference(fromURL: apiURL)
        let studentRef  =  ref.child("LDACAUsers")
        
            
           print((id))
        let ResQuery = studentRef.queryOrdered(byChild: "roleID").queryEqual(toValue:Int(id))
        
        
        // ResQuery = regRef.queryOrdered(byChild: "TourDateIntervalSince1970").queryEnding(atValue: lastObject.TourDateIntervalSince1970).queryLimited(toLast: 2)
        ResQuery.observeSingleEvent(of: .value, with:
        {
        (snapshot) in
        
        // ResQuery.observe(.value, with: { snapshot in
        // 2
        
        // 3
        var newItems: [LDACAUser] = []
        
        for item in snapshot.children {
        // 4
        let post = LDACAUser(snapshot: item as! FIRDataSnapshot)
        //  let registration = HSUTourRegistration(snapshot: item as! FIRDataSnapshot)
            
                newItems.append(post)
            
        
        
        }
        
        // 5
        
        completion(newItems)
        
        })
        
        
        
    }
    
    
    func GetLastedUserWithSingleEventWithRoleID(_ lastObject:LDACAUser  = LDACAUser(),queryRole : UserRoleInString ,completion:@escaping (_ userIDs: [Int])->Void)
    {
        
        
        if lastObject.roleID == LDACAUser_NoneRoleID
        {
            lastObject.roleID = 99999999999
        }
       let ResQuery =   self.LDACAUserByRoleref.child(queryRole.rawValue).queryOrdered(byChild: "L").queryEnding(atValue: lastObject.roleID! - 1).queryLimited(toLast: 2)
       
        ResQuery.observeSingleEvent(of: .value, with:
        {
        (snapshot) in
        
        // ResQuery.observe(.value, with: { snapshot in
        // 2
        
        // 3
        var newItems: [Int] = []
        
        for item in snapshot.children {
        // 4
            
            print(item)
            
            let snapshotValue = (item as! FIRDataSnapshot).value as! [String: AnyObject]
            print(snapshotValue["L"])
            print(snapshotValue)
            newItems.append(snapshotValue["L"] as! Int)
        
        
        }
        
        // 5
        
        completion(newItems)
        
        })

    }
 
        func GetLastedUserWithSingleEvent(_ lastObject:LDACAUser  = LDACAUser(),completion:@escaping (_ students: [LDACAUser])->Void)
        
    {
        
        if lastObject.roleID == LDACAUser_NoneRoleID
        {
            lastObject.roleID = 99999999999
        }
        let ref  =  FIRDatabase.database().reference(fromURL: apiURL)
        let studentRef  =  ref.child("LDACAUsers")
        
        let ResQuery = studentRef.queryOrdered(byChild: "roleID").queryEnding(atValue: lastObject.roleID! - 1).queryLimited(toLast: 2)
        
    
        // ResQuery = regRef.queryOrdered(byChild: "TourDateIntervalSince1970").queryEnding(atValue: lastObject.TourDateIntervalSince1970).queryLimited(toLast: 2)
        ResQuery.observeSingleEvent(of: .value, with:
            {
                (snapshot) in
                
                // ResQuery.observe(.value, with: { snapshot in
                // 2
                
                // 3
                var newItems: [LDACAUser] = []
                
                for item in snapshot.children {
                    // 4
                    let post = LDACAUser(snapshot: item as! FIRDataSnapshot)
                    //  let registration = HSUTourRegistration(snapshot: item as! FIRDataSnapshot)
                    newItems.append(post)
                    
                    
                }
                
                // 5
                
                completion(newItems)
                
        })
        
        
        
    }
    

    func checkRegis(privatekey:String,roleID:String,completion:@escaping (_ success:Bool ,_ user : LDACAUser)->Void)
    {
        
        
        if !privatekey.checkValidFirebaseChildString(string: privatekey)
        {
            completion(false, LDACAUser())
        }
        else
        {
        let ref  =  FIRDatabase.database().reference(fromURL: apiURL)
        let usersRef  =  ref.child("LDACAUsers")
        
            usersRef.child(roleID).observeSingleEvent(of: FIRDataEventType.value, with: { (snapshot) in
        
        
        
               if let student  = LDACAUser(snapshot: snapshot) as? LDACAUser
               {
                
                //print(usersRef.child(privatekey).parent?.key)
                print(privatekey)
                print(student.roleID)
                print(roleID)
                
                if privatekey.characters.count >= 6
                {
                    
                    if student.password.lowercased().range(of:privatekey.lowercased()) != nil {
                     

                    completion(true, student)
                    }
                    else
                    {
                        completion(false, LDACAUser())

                    }
                }
                
                else
                {
                completion(false, LDACAUser())
                }
                
                }
        
            })
        }

    }
    func registerUserWithRoleID(roleID :String,privateKey:String,completion:@escaping (_ success:Bool)->Void)
    {
        self.checkRegis(privatekey: privateKey, roleID: roleID) { (success,user) in
        
            if success
            {
                
                FirebaseAuthAPI.shareInstance.currentUser?.role = UserRole(rawValue: user.role!)!
                FirebaseAuthAPI.shareInstance.currentUser?.RoleID = Float(Int(roleID)!)
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
    }
    func updateUserPassWord(password:String,completion:@escaping (_ success:Bool)->Void)
    {
        let ref  =  FIRDatabase.database().reference(fromURL: apiURL)
        let usersRef  =  ref.child("LDACAUsers").child(String(Int((FirebaseAuthAPI.shareInstance.currentLDACAUSer?.roleID)!)))
        
        
        usersRef.updateChildValues(["password":password]) { (error, ref) in
            
            if error == nil
            {
            completion(true)
            }
            else
            {
                completion(false)
            }
        }
    }
    func updatePassWord(userRef:FIRDatabaseReference,user:LDACAUser)
    {
       // print(String(Int((student.roleID)!)))
     
        let passwordRef = userRef.child(String(Int((user.roleID)!))).childByAutoId()
        
        
        passwordRef.updateChildValues(["pass":1]) { (Error, FIRDatabaseReference) in
            
            print(FIRDatabaseReference.key)
            
            
            user.password = FIRDatabaseReference.key
            userRef.updateChildValues(["password":user.password], withCompletionBlock: { (Error, FIRDatabaseReference) in
                
                if Error == nil
                {
                    passwordRef.removeValue(completionBlock: { (Error, FIRDatabaseReference) in
                        
                    })
                }
                
            })
        }
        

    }
    //MARK: PROFILEIMAGE UPDATE
    func updateUserProfileImageURL(user:LDACAUser,url:String,completion:@escaping (_ success:Bool)->Void)
    {
        
        
        let profileVAlue = ["profileImageURL":url]
        studentREF.child(String(Int(user.roleID!))).updateChildValues(profileVAlue) { (Error, FIRDatabaseReference) in
        
            if Error == nil
            {
                completion(true)
            }
            
        }
        
    }
    func updateuserByRole()
    {
        
    }

    func updateLDACAUser(_ student:LDACAUser,completion:@escaping (_ DidSignIn:Bool)->Void)
    {
     
        
        let ref  =  FIRDatabase.database().reference(fromURL: apiURL)
        let usersRef  =  ref.child("LDACAUsers")
           let userref = usersRef.child(String(Int((student.roleID)!)))
        print(student.roleID?.description)
        
        
        
    
    
            print(student.roleID)
            
            print()
            print(String(describing: Int(student.roleID!)))
            
            
          //checkif students contains student with id
        let query = usersRef.queryOrdered(byChild: "roleID").queryEqual(toValue:student.roleID!)
        query.observeSingleEvent(of:.value, with: { (snapshot) in
            
                // done checkif students contains student with id
          
            
           
            
              if  snapshot.children.allObjects.count == 0
              {
                
                let values  = student.toAnyObject() as! [String : Any]
                
                
                userref.updateChildValues(values) { (Error, FIRDatabaseReference) in
                    
                    //update user
                    if Error == nil
                    {
                        //successfully updated user
                        
                        self.updatePassWord(userRef: userref, user: student)
                        
                        let value = ["L":student.roleID]
                    
                        
                        //check if there is no object 
                        let query = self.LDACAUserByRoleref.child(String(Int((student.role)!))).queryOrdered(byChild: "L").queryEqual(toValue:student.roleID!)
                        query.observeSingleEvent(of:.value, with: { (snapshot) in
                            
                            // done checkif students contains student with id
                            
                            
                            
                            
                            if  snapshot.children.allObjects.count == 0
                            {
                                self.LDACAUserByRoleref.child(String(Int((student.role)!))).childByAutoId().updateChildValues(value)
                                
                            }
                            
                            
                            
                        })

                        
                        
                        
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

