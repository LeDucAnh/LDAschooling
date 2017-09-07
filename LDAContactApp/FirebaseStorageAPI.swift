//
//  FirebaseStorageAPI.swift
//  HSUFreeWalkingtour
//
//  Created by Mac on 12/1/16.
//  Copyright © 2016 LeDucAnh. All rights reserved.
//

import UIKit
import Firebase
class FirebaseStorageAPI: NSObject {
//url reference
    
    
    // Get a reference to the storage service, using the default Firebase App
    let storage = FIRStorage.storage()
    // Create a storage reference from our storage service
   // let storageRef = storage.referenceForURL("gs://hsufreewalkingtour.appspot.com")
    static var shareInstance = FirebaseStorageAPI()
    
    func deleteFile(_ name:String)
    {
        
        let storageRef =  storage.reference()
        
        let path = "images/" + name + ".jpg"
        let imagesRef = storageRef.child(path)
        
        // Delete the file
        imagesRef.delete { error in
            if let error = error {
                // Uh-oh, an error occurred!
            } else {
                // File deleted successfully
            }
        }
    }
    
    func uploadFileToFirebase(_ data:Data,name:String,completion:@escaping (_ downloadURL:String)->Void)
    {

    let storageRef =  storage.reference()
        
    let path = "images/" + name + ".jpg"
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
}
