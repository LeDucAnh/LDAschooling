//
//  LDACARequest.swift
//  LDAContactApp
//
//  Created by Mac on 6/10/17.
//  Copyright © 2017 LeDucAnh. All rights reserved.
//

import UIKit
import Firebase
public enum LDACAClassRequestType : Int{
    case absent
}
public var LDACAClassRequestTypeStringArr = ["Absent Form"]

public var LDACAClassRequestTypeStringDescriptionArr = ["Tell us why you absent"]






class LDACAClassRequest: NSObject {

    
        //MARK: Properties
        //var owner: MessageOwner
        var parent :String!
        var dateTime : Double!
        var classID : String?

        var fromID :String?
        var content: String?
        var timestamp: Int
        var requestType : Int?

        
        
        
        
        
        //private variable
    var sendUser : LDACAUser?
    

        var belongtoClass : LDACAClass?
        var belongtoclassId :String?
        var currentTeacherRespondState : LDACAFirebasePostRespondAction?
        //MARK: Methods
        
    func toAnyObject() ->  [String : Any] {
        return [
           "fromID":fromID,
           "content":content,
           "timestamp":timestamp,
           "requestType":requestType,
           "dateTime":dateTime
            
            
        ]
        
    }
  static  let classRef = FIRDatabase.database().reference(withPath: "Classes")

    class  func GetLastedRequestWithSingleEvent(classID: String ,_ lastObject:LDACAClassRequest  = LDACAClassRequest(),isInitialLoad:Bool,completion:@escaping (_ arr: [LDACAClassRequest])->Void)
        
    {
        
        
        let ref  =  classRef.child(classID).child("Requests")
        
        
        
        
        
        let datetime = 99999999
        
        var   ResQuery = ref.queryOrdered(byChild: "timestamp").queryEnding(atValue: datetime).queryLimited(toLast: 1)
        
        

        
        
        
        if isInitialLoad ==  false
        {
            ResQuery = ref.queryOrdered(byChild: "timestamp").queryEnding(atValue: lastObject.dateTime! - 1).queryLimited(toLast: 2)

        }
        
        // ResQuery = regRef.queryOrdered(byChild: "TourDateIntervalSince1970").queryEnding(atValue: lastObject.TourDateIntervalSince1970).queryLimited(toLast: 2)
        ResQuery.observeSingleEvent(of: .value, with:
            {
                (snapshot) in
                
                // ResQuery.observe(.value, with: { snapshot in
                // 2
                
                // 3
                print(snapshot)
                var requests = [LDACAClassRequest]()
                for item in snapshot.children {
                    print(item)
                    
                    let data =  (item as! FIRDataSnapshot).value as! [String: Any]
                    
                    
                  
                    
                    let noti =  LDACAClassRequest(withSnapshotValue: data)
                    print(noti)
                    
                    requests.append(noti)
                    
                    
                }
                completion(requests)
                
        })
        
        
        
    }

    
    class  func registerAddedRequest(classID: String, _ completion:@escaping (_ request: [LDACAClassRequest])->Void)
    {
        
        
        
        
        classRef.child(classID).child("Requests").observe(.childAdded, with: { (snapshot) in
            if snapshot.exists() {
                
                var requests = [LDACAClassRequest]()
                let data = snapshot.value as! [String: Any]

                
                    
                    
                    let noti =  LDACAClassRequest(withSnapshotValue: data)
                    print(noti)
                    
                    requests.append(noti)
                    
                    
                
                completion(requests)
                
                
            }
        })
        
        
    }


    func uploadToClass(classID:String ,_ completion:@escaping (_ result:Bool)->Void)
        {

                
        LDACAClassRequest.classRef.child(classID).child("Requests").childByAutoId().updateChildValues(self.toAnyObject(), withCompletionBlock: { (Error, FIRDatabaseReference) in
                
            if Error == nil
            {
                completion(true)
            }
            else
            {
                completion(false)
            }
        
        
        })

                    
            
        }
    override init() {
        self.content = ""
        self.timestamp = 0
    }

        init(withSnapshotValue: [String: Any])
        {
            
            
            
            
            self.content = ""
            self.timestamp = 0
            self.classID = ""
            
            if let content = withSnapshotValue["content"]
            {
                self.content = content as! String
            }
            if let timestamp = withSnapshotValue["timestamp"]
            {
                self.timestamp = timestamp as! Int
            }
            if let requestType = withSnapshotValue["requestType"]
            {
                self.requestType = requestType as! Int
            }

            if let fromID = withSnapshotValue["fromID"]
            {
                self.fromID = fromID as! String
            }
            
            if let currentTeacherRespondState = withSnapshotValue["TeacherRes"]
            {
                self.currentTeacherRespondState = LDACAFirebasePostRespondAction(rawValue: currentTeacherRespondState as! Int)
            }
            
            
            if let dateTime = withSnapshotValue["dateTime"]
            {
                self.dateTime = dateTime as! Double
            }
            

            
            
        }
        
        
        
        
        class func updateRespondAction(forClassNoti:LDACANotification,withAction:LDACAFirebasePostRespondAction,completion: @escaping (LDACANotification) -> Swift.Void)
        {
            
            
            
        }
    
    

}
