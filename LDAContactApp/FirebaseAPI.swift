//
//  FirebaseAPI.swift
//  HSUFreeWalkingtour
//
//  Created by Mac on 9/29/16.
//  Copyright © 2016 LeDucAnh. All rights reserved.
//

import UIKit
import Firebase

class FirebaseAPI: NSObject {
//
    let storage = FIRStorage.storage()
    

     let HSUuserref = FIRDatabase.database().reference(withPath: "users")
    
    let placeRef = FIRDatabase.database().reference(withPath: "Place")
  static let shareInstance = FirebaseAPI()
    let tourRegistrationRef  =  FIRDatabase.database().reference(withPath: "Registration")

    
    func uploadPhotoFileToFirebase(_ data:Data,name:String,completion:@escaping (_ downloadURL:String)->Void)
    {
        
        let storageRef =  storage.reference()
        
        let path = "Photo/" + name + ".jpg"
        let imagesRef = storageRef.child(path)
        
        
        
        
        
        
        // Upload the file to the path "images/rivers.jpg"
        let uploadTask = imagesRef.put(data, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                return
            }
            // Metadata contains file metadata such as size, content-type, and download URL.
            //  let downloadURL =
            completion((metadata.downloadURL()?.absoluteString)!)
        }
        
    }
    func uploadThumbFileToFirebase(_ data:Data,name:String,completion:@escaping (_ downloadURL:String)->Void)
    {
        
        let storageRef =  storage.reference()
        
        let path = "thumbnails/" + name + ".jpg"
        let imagesRef = storageRef.child(path)
        
        
        
        
        
        
        // Upload the file to the path "images/rivers.jpg"
        let uploadTask = imagesRef.put(data, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                return
            }
            // Metadata contains file metadata such as size, content-type, and download URL.
            //  let downloadURL =
            completion((metadata.downloadURL()?.absoluteString)!)
        }
        
    }
    func uploadVidFileFromLocal(_ fileURL:String,name:String,completion:@escaping (_ downloadURL:String)->Void)
    {
        // File located on disk
        let localFile = URL(string: fileURL)!
        
        // Create a reference to the file you want to upload
        let filetype =  fileURL.components(separatedBy: ".").last
        let path = "video/" + name + "." + filetype!
        
        
        
        
        let vidRef = storage.reference().child(path)
        
        // Upload the file to the path "images/rivers.jpg"
        let uploadTask = vidRef.putFile(localFile, metadata: nil) { metadata, error in
            if let error = error {
                // Uh-oh, an error occurred!
            } else {
                // Metadata contains file metadata such as size, content-type, and download URL.
                
                completion((metadata?.downloadURL()?.absoluteString)!)
            }
        }
        
        
    }

    
 //   let storageRef = FIRStorage.storage().reference(forURL: "gs://hsufreewalkingtour.appspot.com")
    func CheckifSigninOrnot(_ completion:@escaping (_ DidSignIn:Bool)->Void)
    {
        
        let user =   FIRAuth.auth()?.currentUser
        
        if ((user) != nil) {
            // User is signed in.
            completion(true)
        } else {
            // No user is signed in.
                completion(false)
            
            
        }
        
    }
    

    func getcurrentSignInUser(_ completion:@escaping (_ DidSignIn:Bool,_ user:FIRUser)->Void)
    {
        
       let user =   FIRAuth.auth()?.currentUser
        if ((user) != nil) {
            // User is signed in.
            completion(true,user!)
        } else {
            // No user is signed in.
        //    completion(false,nil)

            
        }

    }
    
}
