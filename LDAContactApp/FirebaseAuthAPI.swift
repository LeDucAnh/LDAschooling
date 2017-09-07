//
//  FirebaseAuthAPI.swift
//  HSUFreeWalkingtour
//
//  Created by Mac on 11/28/16.
//  Copyright © 2016 LeDucAnh. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
//import GoogleMobileAds
//import FBSDKShareKit
import FirebaseAuth
import Firebase

class FirebaseAuthAPI: NSObject {

    var currentUser:User?
    var currentLDACAUSer :LDACAUser?
    {
        didSet {
           NotificationCenter.default.post(name: Notification.Name("notididreceivecurrentLDACAUSer"), object: nil)
        }

    }
    let apiURL = "htxtps://contactapp-fd758.firebaseio.com"
    static let shareInstance = FirebaseAuthAPI()

    /*registerForUserDataChange*/
    var LDACAUserDataDidChangeAction:(()->Void)!


    func registerForLDACAUserChange(action:@escaping ()->Void)
    {
        if let value = FirebaseAuthAPI.shareInstance.currentLDACAUSer
        {
            
        }
        else
        {
            return
        }
        
        LDACAUserDataDidChangeAction  = action
        FirebaseLDACAUserAPI.shareInstance.registerForUserDataChange(user: FirebaseAuthAPI.shareInstance.currentLDACAUSer!) { (user) in
           
            FirebaseAuthAPI.shareInstance.currentLDACAUSer! = user
            self.LDACAUserDataDidChangeAction()
            
        }
    }
    

    func setupFirebase()
    {
        
        
        //Set Siri 
        SiriHandler.sharedInstance.setConverstionToSiriExtension()
        FirebaseAuthAPI.shareInstance.registerForLDACAUserChange { 
            
        }
    }
    func loginWithEmail(email:String,password:String,completion:@escaping (_ user:User,_ uid:String,_ success :Bool,_ errString:String)->Void)
    {
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if error == nil{
                
                
                self.saveLDACAUserToFirebaseAuth(completion: { (User) in
                    completion(User, (FIRAuth.auth()?.currentUser?.uid)!,true,"")
                    
   

                })
                
            }
            else
            {

            completion(User(uid: "", email: ""),"",false,error.debugDescription)
            }
        
        })
    }
    func saveLDACAUserToFirebaseAuth(completion:@escaping (_ user:User)->Void)
    {
        
        if FirebaseAuthAPI.shareInstance.currentLDACAUSer == nil && FirebaseAuthAPI.shareInstance.currentLDACAUSer?.roleID == nil && FirebaseAuthAPI.shareInstance.currentUser == nil
        {

        print(FIRAuth.auth()?.currentUser?.uid)
        self.getUserWithUserUIDKeys([(FIRAuth.auth()?.currentUser?.uid)!], completion: { (dict) in
            
            
            let user =  dict[(FIRAuth.auth()?.currentUser?.uid)!] as! User
            FirebaseAuthAPI.shareInstance.currentUser = user
            print(FirebaseAuthAPI.shareInstance.currentUser?.RoleID)
                FirebaseLDACAUserAPI.shareInstance.getLDACAUserForCurrentFirebaseUser(user: FirebaseAuthAPI.shareInstance.currentUser!) { (resultArr) in
                    if resultArr.count == 1
                    {
                        FirebaseAuthAPI.shareInstance.currentLDACAUSer = resultArr.first
                        completion(user)
                        
                    }
                    
                    
                }
            

            
            })
        }
        else
        {
            self.getUserWithUserUIDKeys([(FIRAuth.auth()?.currentUser?.uid)!], completion: { (dict) in
                
                
                let user =  dict[(FIRAuth.auth()?.currentUser?.uid)!] as! User
                FirebaseAuthAPI.shareInstance.currentUser = user
            completion(user)
            
            })

        }
        
    }
    func createUserWithEmail(LDACAuser:User,completion:@escaping (_ success:Bool,_ uid:String)->Void)
    {
        // 1
        let emailField = LDACAuser.email
        let passwordField = LDACAuser.password
        // 2
        FIRAuth.auth()!.createUser(withEmail: emailField,
                                   password: passwordField) { user, error in
                                    if error == nil {
                                        // 3
                                       //     completion(true,"")
                                        
                                        
                                        
                                        
                                        let userFBInfoDict = NSDictionary()
                                        self.updateUserToDatabse(LDACAuser, uidString: (user?.uid)!, completion: { (IsSuccessfull) in
                                            
                                            if IsSuccessfull
                                            {
                                                
                                                completion(true,(user?.uid)!)
                                            }
                                            else
                                            {
                                                completion(false,"")
                                                
                                            }
                                            
                                        })
                                        

                                        
                                    }
                                    print(error)
        
        
        
        
        
        }

    }
    func getUserSnapShotwithUID(uidString:String,completion:@escaping (_ snapshot:FIRDataSnapshot)->Void)
    {
        let ref  =  FIRDatabase.database().reference(fromURL:apiURL)
        let usersRef  =  ref.child("Users").child(uidString)
        
        
        usersRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
           
            completion(snapshot)
        })
    }
    
    func userWithUserUID(uidString:String,completion:@escaping (_ result:User)->Void)
    {
    
        self.getUserSnapShotwithUID(uidString: uidString) { (FIRDataSnapshot) in
            
            let user = User(snapshot: FIRDataSnapshot)
            
            completion(user)
        }
    }
    
    func checkIfUserDataExist(uidString:String,completion:@escaping (_ result:Bool)->Void)
    {
        self.getUserSnapShotwithUID(uidString: uidString) { (FIRDataSnapshot) in
            
                if FIRDataSnapshot.exists()
                {
                        completion(true)
                }
            else
                {
                    completion(false)
                }
        }

        
    }
    func performLoginAction(_ userFBInfoDict:NSDictionary,completion:@escaping (_ DidSignIn:Bool,_ uid:String)->Void)

    {
        //firebasefb
        
        let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        FIRAuth.auth()?.signIn(with: credential) { (user, error) in
            // handle logged in user
            
            if error != nil {
                print("Login failed. \(error)")
                completion(false,"")
                return
                
                let alertView = SCLAlertView()
                
                alertView.addButton("OK") {
                    
                }
                alertView.appearance.showCloseButton = false
                alertView.showTitle("Fail", subTitle: "Fail to Login", style: .error)
                
                
                
            }
            
            guard let uid = user?.uid else
            {
                return
            }
            
            
            
            let user = FIRAuth.auth()?.currentUser
            
            if let user = user {
                let changeRequest = user.profileChangeRequest()
                
                changeRequest.displayName = FirebaseAuthAPI.shareInstance.currentUser?.name
                
                
                if FirebaseAuthAPI.shareInstance.currentUser?.profileImageURL != nil{
                    
                changeRequest.photoURL =
                    URL(string: (FirebaseAuthAPI.shareInstance.currentUser?.profileImageURL)!)
                
                }
                changeRequest.commitChanges { error in
                    if error != nil {
                        // An error happened.
                        completion(false,"")

                    } else {
                        
                        
                        
                        
                        FirebaseAuthAPI.shareInstance.currentUser = User(FbDict: userFBInfoDict)
                        self.saveLDACAUserToFirebaseAuth(completion: { (User) in
                             })

//thislineofcode
                        self.checkIfUserDataExist(uidString: user.uid, completion: { (Bool) in
                           
                            if !Bool
                            {
                                self.updateUserToDatabse(User(FbDict: userFBInfoDict), uidString: uid, completion: { (IsSuccessfull) in
                                    
                                    if IsSuccessfull
                                        
                                        
                                    {
                                        
                                        
                                        
                                        completion(true,uid)
                                    }
                                    else
                                    {
                                        completion(false,"")
                                        
                                    }
                                    
                                })
                                

                            }
                            else
                            {
                        
                                completion(true,uid)
                            }
                        
                        })
                        
                        
                        
                        
                        
                    }
                }
                
                
                
                
                
            }
        }
        
        
        
        
        
        
        
        //    self.updateLoginUserProfileView()
        
        

    }
    func getUserWithUserUIDKeys(_ UIDkeys:[String],completion:@escaping (_ Dict:Dictionary<String, User>)->Void)
    {
        
        //UIDkey need to be unique
        var array = [User]()
        var dict = Dictionary<String, User>()
        for key in UIDkeys
        {
            if key != ""
            {
            
            let ref  =  FIRDatabase.database().reference(fromURL:apiURL)
                
            let usersRef  =  ref.child("Users").child(key)
            
            /*
            usersRef.observeSingleEvent(of: FIRDataEventType.value, with: { (FIRDataSnapshot) in
                
                
            })
             */
            usersRef.observe(FIRDataEventType.value, with: { (snapshot) in
               // let user = snapshot.value as! [String : String]
         
                    let user =   User(snapshot: snapshot)
                    array.append(user)
                dict[key] = user
            
                
                    if dict.count == UIDkeys.count
                    {
                      //      completion(array)
                        completion(dict)
                    }
            })
            }

        }
        
    }
    func updateUserEscortRegistration(_ Description:String,phonenumber:String,uidString:String,completion:@escaping (_ DidSignIn:Bool)->Void)
    {
        
        let ref  =  FIRDatabase.database().reference(fromURL: apiURL)
        let usersRef  =  ref.child("Users").child(uidString)
        let values  = ["EscDescription":Description as NSString,"EsContactNumb":phonenumber as NSString,"ESState" : 0] as [String : Any]
        
        
        usersRef.updateChildValues(values) { (Error, FIRDatabaseReference) in
            
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

    }
    func updateUserToDatabse(_ user : User,uidString:String,completion:@escaping (_ DidSignIn:Bool)->Void)

    {
        
        
        let ref  =  FIRDatabase.database().reference(fromURL:apiURL)
        let usersRef  =  ref.child("Users").child(uidString)
        //let values  = ["Email":user.email as! NSString,"name":user.name as! NSString, "FBID":user.FBID as! NSString,"profileImageURL":user.profileImageURL as! NSString]
        //this line of code
         let values  = user.toAnyObject()
        usersRef.updateChildValues(values as! [AnyHashable : Any] ) { (Error, FIRDatabaseReference) in
            
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
        
    }
    

}
