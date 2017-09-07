//
//  LDACANotification.swift
//  LDAContactApp
//
//  Created by Mac on 5/16/17.
//  Copyright © 2017 LeDucAnh. All rights reserved.
//

//MARK : APPNOTIFICATION
//MARK : CLASSNOTIFICATION

import UIKit
import Firebase
public enum LDACANotificationAccessType:Int
{
    case publicType//every one can view
    case classType//all attendance in class an view
    case roleType//specific type of user can view
    case limitUserType//limitUser with ID can view
}
public enum LDACANotificationType:String
{
    case ClassNotification = "ClassNotifications"
    case AppNotification = "AppNotifications"
}

public enum LDACAFirebasePostRespondAction:Int
{
    case pending
    case seen
    case Decline
    case Accept
    

}


public struct LDACAReceiver
{
    var id :String?
    var respondAction : LDACAFirebasePostRespondAction?
    init(key:String,value:Any)
    {
        
        self.id = key
        self.respondAction = LDACAFirebasePostRespondAction(rawValue: value as! Int)
    }
}
open class LDACANotification: NSObject {
    
    //MARK: Properties
    //var owner: MessageOwner
    var parent :String!
    var type: MessageType
    var content: Any
    var timestamp: Int
    var isRead: Bool
    var image: UIImage?
    
    var embedURL : String?
    var accessType : LDACANotificationAccessType?
    private var toID: String?
     var fromID: String?
    var receiversArr = [LDACAReceiver]()
    var favorite : Bool? = false
    var seen : Bool? = false
    var sendUser : LDACAUser?
    
    //private variable
    var belongtoClass : LDACAClass?
    var belongtoclassId :String?
    var currentUserRespondState : LDACAFirebasePostRespondAction?
    
    
    var photoURL  : String?
    var videoURL  : String?
    

    var  notificationType : LDACANotificationType!
    //MARK: Methods
    init(withSnapshotValue: [String: Any])
    {
        
        
        self.type = .text
        self.content = ""
        self.timestamp = 0
        self.isRead = false
        self.image = UIImage()
        
        if let photoURL = withSnapshotValue["photoURL"]
        {            self.photoURL = photoURL as! String

            //self.type = (type as! String) as! MessageType
        }
        if let videoURL = withSnapshotValue["videoURL"]
        {            self.videoURL = videoURL as! String
            
            //self.type = (type as! String) as! MessageType
        }


        if let type = withSnapshotValue["type"]
        {
            //self.type = (type as! String) as! MessageType
        }
        if let embedURL = withSnapshotValue["embedURL"]
        {
            self.embedURL = embedURL as! String
        }

        if let content = withSnapshotValue["content"]
        {
            self.content = content as! String
        }
        if let timestamp = withSnapshotValue["timestamp"]
        {
            self.timestamp = timestamp as! Int
        }
        if let fromID = withSnapshotValue["fromID"]
        {
            self.fromID = fromID as! String
        }
        
        
        
        if let fromID = withSnapshotValue["fromID"]
        {
            
             for item in withSnapshotValue
             {
                
                if let value =  item.value as? Int
                {
                    if value  == LDACAFirebasePostRespondAction.pending.rawValue || value  == LDACAFirebasePostRespondAction.seen.rawValue || value == LDACAFirebasePostRespondAction.Accept.rawValue ||  value == LDACAFirebasePostRespondAction.Decline.rawValue
                    {
                    let receiver  = LDACAReceiver(key: item.key, value: item.value)
                        
                        if Int(receiver.id!)! == Int((FirebaseAuthAPI.shareInstance.currentLDACAUSer?.roleID)!)
                        {
                                    self.currentUserRespondState = receiver.respondAction
                        }
                    self.receiversArr.append(receiver)
                    
                    }
                }
            }
        }
        
        
        
        
        
        

    }
    
    
    func deletePhoto()
    {
        if self.photoURL != nil
        {
            
            let path = "Photo/" + self.parent + ".jpg"
            let imagesRef = FIRStorage.storage().reference().child(path)
            
            imagesRef.delete(completion: { (error) in
                
                
            })
        }
        

    }
    func deleteVideo()
    {
        if self.videoURL != nil
        {
            
            let filetype =  self.videoURL?.components(separatedBy: ".").last

            let path = "video/" + self.parent + ".MOV"
            let imagesRef = FIRStorage.storage().reference().child(path)
            
            imagesRef.delete(completion: { (error) in
                
                
            })
        }
        
        
    }

    
    func deleteClassNotification(completion: @escaping (Bool) -> Swift.Void)
    {
        self.deletePhoto()
        self.deleteVideo()
        print(self)
        FIRDatabase.database().reference().child(LDACANotificationType.ClassNotification.rawValue).child(self.belongtoclassId!).child(self.parent).removeValue { (error, ref) in
            
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
    
    
    class func updateRespondAction(forClassNoti:LDACANotification,withAction:LDACAFirebasePostRespondAction,completion: @escaping (LDACANotification) -> Swift.Void)
    {
        
        
        print(forClassNoti.belongtoClass?.parent)
        
        print(FirebaseAuthAPI.shareInstance.currentLDACAUSer?.roleID)
        print(forClassNoti.parent)
        FIRDatabase.database().reference().child(LDACANotificationType.ClassNotification.rawValue).child((forClassNoti.belongtoclassId)!).child(forClassNoti.parent).child(String(Int((FirebaseAuthAPI.shareInstance.currentLDACAUSer?.roleID)!))).setValue(withAction.rawValue)
        
        
    }
    
    ///Classnoti

    
        class func registerNotiDataChange(forUserID: String, ClassID:String,notiType:LDACANotificationType, completion: @escaping (LDACANotification) -> Swift.Void)
    {
        

        
        
        FIRDatabase.database().reference().child(notiType.rawValue).child(ClassID).queryOrdered(byChild: forUserID).queryStarting(atValue: LDACAFirebasePostRespondAction.pending.rawValue).queryEnding(atValue: LDACAFirebasePostRespondAction.Accept.rawValue).observe(.childChanged, with: { (snapshot) in
            if snapshot.exists() {
                
                
                let data = snapshot.value as! [String: Any]
                
                
                
                
                let noti =  LDACANotification(withSnapshotValue: data)
                print(noti)
                
                noti.notificationType = LDACANotificationType.ClassNotification
                print(snapshot.ref.key)
                print(snapshot.ref.parent?.key)
                noti.belongtoclassId = snapshot.ref.parent?.key
                noti.parent = snapshot.key
                FirebaseLDACAUserAPI.shareInstance.getUserWithID(noti.fromID!, completion: { (arr) in
                    
                    noti.sendUser = arr.first
                    completion(noti)
                })
                

            }
        })
    
    
    }
    
    
    
    class func registerNotiDataAdded(forUserID: String, ClassID:String,notiType:LDACANotificationType, completion: @escaping (LDACANotification) -> Swift.Void)
    {
        
        FIRDatabase.database().reference().child(notiType.rawValue).child(ClassID).queryOrdered(byChild: forUserID).queryStarting(atValue: LDACAFirebasePostRespondAction.pending.rawValue).queryEnding(atValue: LDACAFirebasePostRespondAction.Accept.rawValue).observe(.childAdded, with: { (snapshot) in
            if snapshot.exists() {
                
                
                let data = snapshot.value as! [String: Any]
                
                
                
                
                let noti =  LDACANotification(withSnapshotValue: data)
                    print(noti)
                noti.notificationType = LDACANotificationType.ClassNotification
                    print(snapshot.ref.key)
                print(snapshot.ref.parent?.key)
                noti.belongtoclassId = snapshot.ref.parent?.key
                noti.parent = snapshot.key
                
                 if noti.returnReceiverForID(idString: String(Int((FirebaseAuthAPI.shareInstance.currentLDACAUSer?.roleID)!))).respondAction?.rawValue == 0
                
                 {
                LDACANotification.updateRespondAction(forClassNoti: noti, withAction: .seen, completion: { (LDACANotification) in
                    
                    
                })
                }
                
                    FirebaseLDACAUserAPI.shareInstance.getUserWithID(noti.fromID!, completion: { (arr) in
                        
                        noti.sendUser = arr.first
                        completion(noti)
                    })

                
                
                
            
            }

        })
    }
    
    func returnReceiverForID(idString:String)-> LDACAReceiver
    {
        for receiver  in self.receiversArr
        {
            if receiver.id == idString
            {
                return receiver
            }
        }
        return LDACAReceiver(key: "nil", value: -1)
    }
    /*
    class func downloadAllMessages(forUserID: String, completion: @escaping (LDACANotification) -> Swift.Void) {
        
        print(String(Int((FirebaseAuthAPI.shareInstance.currentLDACAUSer?.roleID)!)))
        print(forUserID)
        
        if let currentUserID = String(Int((FirebaseAuthAPI.shareInstance.currentLDACAUSer?.roleID!)!)) as? String  {
            print(currentUserID.description)
            FIRDatabase.database().reference().child("LDACAUsers").child(currentUserID.description).child("notifications").child(forUserID.description).observe(.value, with: { (snapshot) in
                if snapshot.exists() {
                    let data = snapshot.value as! [String: String]
                    let location = data["location"]!
                    FIRDatabase.database().reference().child("notifications").child(location).observe(.childAdded, with: { (snap) in
                        if snap.exists() {
                            let receivedMessage = snap.value as! [String: Any]
                            let messageType = receivedMessage["type"] as! String
                            var type = MessageType.text
                            switch messageType {
                            case "photo":
                                type = .photo
                            case "location":
                                type = .location
                            default: break
                            }
                            let content = receivedMessage["content"] as! String
                            let fromID = receivedMessage["fromID"] as! String
                            let timestamp = receivedMessage["timestamp"] as! Int
                            if fromID == currentUserID {
                                //we has problem right here
                                
                                let message = LDACANotification.init(type: type, content: content, owner: .receiver, timestamp: timestamp, isRead: true, classID: "")
                                completion(message)
                            } else {
                                let message = LDACANotification.init(type: type, content: content, owner: .sender, timestamp: timestamp, isRead: true, classID: "")
                                completion(message)
                            }
                        }
                    })
                }
            })
        }
        
    }
 */
    
    func downloadImage(indexpathRow: Int, completion: @escaping (Bool, Int) -> Swift.Void)  {
        if self.type == .photo {
            let imageLink = self.content as! String
            let imageURL = URL.init(string: imageLink)
            URLSession.shared.dataTask(with: imageURL!, completionHandler: { (data, response, error) in
                if error == nil {
                    self.image = UIImage.init(data: data!)
                    completion(true, indexpathRow)
                }
            }).resume()
        }
    }
    
    class func markMessagesRead(forUserID: String)  {
        if let currentUserID = String(Int((FirebaseAuthAPI.shareInstance.currentLDACAUSer?.roleID!)!)) as? String {
            FIRDatabase.database().reference().child("LDACAUsers").child(currentUserID.description).child("notifications").child(forUserID.description).observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.exists() {
                    let data = snapshot.value as! [String: String]
                    let location = data["location"]!
                    FIRDatabase.database().reference().child("notifications").child(location).observeSingleEvent(of: .value, with: { (snap) in
                        if snap.exists() {
                            for item in snap.children {
                                let receivedMessage = (item as! FIRDataSnapshot).value as! [String: Any]
                                let fromID = receivedMessage["fromID"] as! String
                                if fromID != currentUserID {
                                    FIRDatabase.database().reference().child("notifications").child(location).child((item as! FIRDataSnapshot).key).child("isRead").setValue(true)
                                }
                            }
                        }
                    })
                }
            })
        }
    }
    
    func downloadLastMessage(forLocation: String, completion: @escaping (Void) -> Swift.Void) {
        if let currentUserID = FIRAuth.auth()?.currentUser?.uid {
            FIRDatabase.database().reference().child("notifications").child(forLocation).observe(.value, with: { (snapshot) in
                if snapshot.exists() {
                    for snap in snapshot.children {
                        let receivedMessage = (snap as! FIRDataSnapshot).value as! [String: Any]
                        self.content = receivedMessage["content"]!
                        self.timestamp = receivedMessage["timestamp"] as! Int
                        let messageType = receivedMessage["type"] as! String
                        let fromID = receivedMessage["fromID"] as! String
                        self.isRead = receivedMessage["isRead"] as! Bool
                        var type = MessageType.text
                        switch messageType {
                        case "text":
                            type = .text
                        case "photo":
                            type = .photo
                        case "location":
                            type = .location
                        default: break
                        }
                        self.type = type
                        if currentUserID == fromID {
                       //     self.owner = .receiver
                        } else {
                         //   self.owner = .sender
                        }
                        completion()
                    }
                }
            })
        }
    }
    func editRecieverAsLDACANotificationAccessType(values :  [String: Any],accessType:LDACANotificationAccessType)
    {
        
    }
    
    class func composeNotificationWithNoti(notification:LDACANotification) -> [String : Any]
    {
        if let currentUserID = String(Int((FirebaseAuthAPI.shareInstance.currentLDACAUSer?.roleID)!)) as? String  {
            
            var values = ["type": "location", "content": notification.content, "fromID": currentUserID, "timestamp": notification.timestamp]
            if notification.embedURL != nil
            {
                values["embedURL"] = notification.embedURL
            }
            
            
            
            return values
        }
        return [String : Any]()
    }
    func updateNotification(key:String, _ value:Any, completion: @escaping (Bool) -> Swift.Void)
    
    {
        let newNotiRef = FIRDatabase.database().reference().child(LDACANotificationType.ClassNotification.rawValue).child(self.belongtoclassId!).child(self.parent).child(key)
        newNotiRef.setValue(value, withCompletionBlock: { (error, _) in
            
            
            if error == nil {
                completion(true)
                
               // completion(true,newNotiRef.key)
            } else {
              //  completion(false,"")
                
                completion(false)
            }
        })
        

    }
    class func sendClass(notification: LDACANotification, istoAll :Bool, toID: [String],accessType:LDACANotificationAccessType, withValues: [String: Any],classId: String, completion: @escaping (Bool,String) -> Swift.Void)  {
        
        var withValues = withValues
        withValues.updateValue(classId, forKey: "classID")
        self.send(notification: notification, istoAll: istoAll, toID: toID, accessType: accessType, withValues: withValues) { (Bool,key) in
            
            completion(Bool,key)
        }
        
    }
    class func send(notification: LDACANotification, istoAll :Bool, toID: [String],accessType:LDACANotificationAccessType,withValues: [String: Any], completion: @escaping (Bool,String) -> Swift.Void)  {
        
        print(FirebaseAuthAPI.shareInstance.currentLDACAUSer?.parent)
        if let currentUserID = String(Int((FirebaseAuthAPI.shareInstance.currentLDACAUSer?.roleID)!)) as? String  {
            switch notification.type {
            case .location:
                
                
                let values = [ "content": notification.content, "fromID": currentUserID, "toID": toID, "timestamp": notification.timestamp]
                
                if accessType == .classType
                {
                 //   LDACANotification.updateNotification(withValues: withValues, toID, isToAll: true, completion: { (status) in
                  //  completion(status)
                    //})
                }
            case .photo:
                let imageData = UIImageJPEGRepresentation((notification.content as! UIImage), 0.5)
                let child = UUID().uuidString
                FIRStorage.storage().reference().child("messagePics").child(child).put(imageData!, metadata: nil, completion: { (metadata, error) in
                    if error == nil {
                        let path = metadata?.downloadURL()?.absoluteString
                        let values = ["type": "photo", "content": path!, "fromID": currentUserID, "toID": toID, "timestamp": notification.timestamp] as [String : Any]
                        if accessType == .classType
                        {

                        //    LDACANotification.updateNotification(withValues: withValues, toID, isToAll: istoAll, completion: { (status) in
                          //  completion(status)
                            //    })
                        }
                    }
                })
            case .text:
                let values = ["type": "text", "content": notification.content, "fromID": currentUserID, "toID": toID, "timestamp": notification.timestamp]
             //   if accessType == .classType
              //  {

                LDACANotification.updateNotification(withValues: withValues, toID, isToAll: istoAll, completion: { (status,key) in
                    completion(status,key)
                })
                //}
                
            case .video : break
            }
        }
    }
    class func updateNotification( withValues: [String: Any], _ toID: [String],isToAll :Bool, completion: @escaping (Bool,String) -> Swift.Void)
    {
        
        var withValues = withValues
        let formid =  withValues["fromID"] as! String
        withValues.updateValue(LDACAFirebasePostRespondAction.pending.rawValue, forKey: formid)
        
        if isToAll == true
        {
           withValues.updateValue(true, forKey: "isToAll")
        }
        else
        {
            
        }
        
        for item in toID{
            // withValues.updateValue(LDACAFirebasePostRespondAction.pending.rawValue, forKey: "unread")
            withValues.updateValue(LDACAFirebasePostRespondAction.pending.rawValue, forKey: item)
        }

        withValues.removeValue(forKey: "toID")
        
        
        if withValues["classID"] != nil
        {
            let classID = withValues["classID"] as! String
            withValues.removeValue(forKey: "classID")
            
            
            print(withValues)
            print(LDACANotificationType.ClassNotification.rawValue)
            print(classID)
            
            let newNotiRef = FIRDatabase.database().reference().child(LDACANotificationType.ClassNotification.rawValue).child(classID).childByAutoId()
            newNotiRef.setValue(withValues, withCompletionBlock: { (error, _) in
               
                
                if error == nil {
                    
                    
                    completion(true,newNotiRef.key)
                } else {
                    completion(false,"")
                }
            })

        }
        else
        {

        }
        
        
        /*
        if let currentUserID = String(Int((FirebaseAuthAPI.shareInstance.currentLDACAUSer?.roleID)!)) as? String {
            //-------------------------
            
            FIRDatabase.database().reference().child("LDACAUsers").child(currentUserID).child(LDACANotificationType.ClassNotification.rawValue).child(classID).observeSingleEvent(of: .value, with: { (snapshot) in
                
                if snapshot.exists() {
                    //if notification did exist then save to that location
                    
                    let data = snapshot.value as! [String: String]
                    let location = data["location"]!
                    FIRDatabase.database().reference().child(LDACANotificationType.ClassNotification.rawValue).child(location).childByAutoId().setValue(withValues, withCompletionBlock: { (error, _) in
                        if error == nil {
                            completion(true)
                        } else {
                            completion(false)
                        }
                    })
                } else {
                    
                    //if notification did not exist then create random key
                    FIRDatabase.database().reference().child(LDACANotificationType.ClassNotification.rawValue).childByAutoId().childByAutoId().setValue(withValues, withCompletionBlock: { (error, reference) in
                        let data = ["location": reference.parent!.key]
                        FIRDatabase.database().reference().child("LDACAUsers").child(currentUserID).child(LDACANotificationType.ClassNotification.rawValue).child(classID).updateChildValues(data)
                        
                        //update receiver
                        
                        for item in toID
                        {
                            
                        
                            FIRDatabase.database().reference().child("LDACAUsers").child(item).child(LDACANotificationType.ClassNotification.rawValue).child(classID).updateChildValues(data)
                        }
                        completion(true)

                    })
                        
                }
            })
            
            
            //------
        }
 */

        
    }
    
    
    
    
    //MARK: Inits
    init(type: MessageType, content: Any, owner: MessageOwner, timestamp: Int, isRead: Bool , classID  : String) {
        self.type = type
        self.content = content
       // self.owner = owner
        self.timestamp = timestamp
        self.isRead = isRead
    }
    override init()
    {
        
         
        self.type = .text
        self.content = ""
        self.timestamp = 0
        self.isRead = false

    }
    
    
    
    //MARK : APPNOTIFICATION
    
    func deleteAppNotification(roleID:Int,completion: @escaping (Bool) -> Swift.Void)
    {
        
        let currentUserRoleID =   roleID
      
        let string =  String(LDACANotification.returnNotiIdFromUserString(roleID:currentUserRoleID))

        
        print(self)
        self.deletePhoto()
        self.deleteVideo()
        FIRDatabase.database().reference().child(LDACANotificationType.AppNotification.rawValue).child(string).child(self.parent).removeValue { (error, ref) in
            
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
    
    class  func GetLastedAppNotificationWithSingleEvent(roleID:Int,_ lastObject:LDACANotification  ,isInitialLoad:Bool,completion:@escaping (_ arr: [LDACANotification])->Void)
        
    {
        
       let currentUserRoleID =  roleID
        let string =  String(self.returnNotiIdFromUserString(roleID:currentUserRoleID))

        
        
        
        print((String(Int((FirebaseAuthAPI.shareInstance.currentLDACAUSer?.role)!))))
        var ref:FIRDatabaseQuery  =  FIRDatabase.database().reference().child(LDACANotificationType.AppNotification.rawValue).child(string)
        
        
        
/*
        ref.child("-KmiFc2h1gC3QLyU8wqn").observeSingleEvent(of: .value, with: { (snapshot) in
            print(snapshot.value)
            
        })
 */
        let datetime:Int64 = 999999999999
        
        
        
        
        
        if isInitialLoad ==  false
        {
            //FIRDatabase.database().reference().child(LDACANotificationType.AppNotification.rawValue).child(String(Int(((FirebaseAuthAPI.shareInstance.currentLDACAUSer?.role)! - 1)))).queryLimited(toLast: 1)
            
      ref =       FIRDatabase.database().reference().child(LDACANotificationType.AppNotification.rawValue).child(string).queryOrdered(byChild: "timestamp").queryEnding(atValue: lastObject.timestamp - 1).queryLimited(toLast: 2)
            

    //        ref = ref.queryOrdered(byChild: "timestamp").queryEnding(atValue: lastObject.dateTime! - 1).queryLimited(toLast: 1)
            
        }
        else
        {
            ref =       FIRDatabase.database().reference().child(LDACANotificationType.AppNotification.rawValue).child(string).queryOrdered(byChild: "timestamp").queryEnding(atValue: datetime).queryLimited(toLast: 2)
            print(ref)
            
            
        
        }

        
        // ResQuery = regRef.queryOrdered(byChild: "TourDateIntervalSince1970").queryEnding(atValue: lastObject.TourDateIntervalSince1970).queryLimited(toLast: 2)
        ref.observeSingleEvent(of: .value, with:
            {
                (snapshot) in
                
                // ResQuery.observe(.value, with: { snapshot in
                // 2
                
                // 3
                
                print(snapshot)
                print(snapshot.value)
                var requests = [LDACANotification]()
                
                for item in snapshot.children {
                    print(item)
                    
                    let data =  (item as! FIRDataSnapshot).value as! [String: Any]
                    
                    
                    
                    
                    let noti =  LDACANotification(withSnapshotValue: data)
                    noti.notificationType = LDACANotificationType.AppNotification
                    print(noti.parent)
                    noti.parent = (item as! FIRDataSnapshot).key
                    print(noti.parent)
                    
                    if noti.fromID != nil
                    {
                    FirebaseLDACAUserAPI.shareInstance.getUserWithID(noti.fromID!, completion: { (arr) in
                        
                        noti.sendUser = arr.first
                       // completion(noti)
                        requests.append(noti)
                        
                        noti.markAppnotificationAsSeen(withRole: roleID)

                        if snapshot.children.allObjects.count == requests.count
                            {
                                
                                //            weakSelf?.items.sort{ $0.timestamp < $1.timestamp }
                                requests.sort{
                                    $0.timestamp > $1.timestamp
                                    
                                }
                                
                                
                                
                                
                        completion(requests)
                        }
                    })
                    }

                    
                }
                
                
        })
        
        
        
    }

    class func returnNotiIdFromUserString(roleID:Int) -> Int

    {
        
        if roleID == 1
        {
        return UserRoleNoti.student.rawValue
        }
        if roleID == 2
        {
           return UserRoleNoti.teacher.rawValue
        }
        if roleID == 3
        {
          return  UserRoleNoti.staff.rawValue
        }
        if roleID == 4
        {
          return  UserRoleNoti.allUser.rawValue
        }


        return -1
        
        
        
        
    }
    class func updateRespondAction(roleID:Int,forAppNoti:LDACANotification,withAction:LDACAFirebasePostRespondAction,completion: @escaping (LDACANotification) -> Swift.Void)
    {
        
                        if let currentUserRoleID = roleID as? Int {
        
        print(FirebaseAuthAPI.shareInstance.currentLDACAUSer?.roleID)
        print(forAppNoti.parent)
                        let string =  String(self.returnNotiIdFromUserString(roleID:currentUserRoleID))
        FIRDatabase.database().reference().child(LDACANotificationType.AppNotification.rawValue).child((string)).child(forAppNoti.parent).child(String(Int((FirebaseAuthAPI.shareInstance.currentLDACAUSer?.roleID)!))).setValue(withAction.rawValue)
        }
        
        
    }
    
    
    static var registerAppNotiRef : FIRDatabaseReference!
    
   static var registerAppNotiRefHandle: FIRDatabaseHandle!

    class func setupAppnotiRef(roleID :Int)
    {
        let forUserID =  String(Int((FirebaseAuthAPI.shareInstance.currentLDACAUSer?.roleID)!))
        let string =  String(self.returnNotiIdFromUserString(roleID:roleID))
        
        print(string)
        
        registerAppNotiRef =   FIRDatabase.database().reference().child(LDACANotificationType.AppNotification.rawValue).child((string))
    }
    
    class func registerAppNotiDataAdded(roleID :Int, completion: @escaping (LDACANotification) -> Swift.Void)
    {

        
        registerAppNotiRef.queryLimited(toLast: 1).observe(.childAdded, with: { (snapshot) in
            if snapshot.exists() {
                
                
                let data = snapshot.value as! [String: Any]
                
                
                
                
                let noti =  LDACANotification(withSnapshotValue: data)
                noti.notificationType = LDACANotificationType.AppNotification
                print(noti.parent)
                noti.parent = snapshot.key
                print(noti.parent)
                
                noti.markAppnotificationAsSeen(withRole: roleID)
                if noti.fromID != nil
                {
                FirebaseLDACAUserAPI.shareInstance.getUserWithID(noti.fromID!, completion: { (arr) in
                    
                    
                    
                    noti.sendUser = arr.first
                    completion(noti)
                })
                
                }
                
                
                
            }
        })

    }
    func markAppnotificationAsSeen(withRole:Int)
    {
        let currentRespondValue =  self.returnReceiverForID(idString: String(Int((FirebaseAuthAPI.shareInstance.currentLDACAUSer?.roleID)!))).respondAction?.rawValue
        if currentRespondValue == 0 || currentRespondValue == nil
        {
            LDACANotification.updateRespondAction(roleID:withRole,forAppNoti: self, withAction: .seen, completion: { (LDACANotification) in
                
                
            })
        }

        

    }
    
 

    class func registerAppNotiDataChange(roleID :Int, completion: @escaping (LDACANotification) -> Swift.Void)
    {
        
        let forUserID =  String(Int((FirebaseAuthAPI.shareInstance.currentLDACAUSer?.roleID)!))
        let string =  String(self.returnNotiIdFromUserString(roleID:roleID))
        
        print(string)
        


        
        
       registerAppNotiRef.queryOrdered(byChild: String(forUserID)).queryStarting(atValue: LDACAFirebasePostRespondAction.pending.rawValue).queryEnding(atValue: LDACAFirebasePostRespondAction.Accept.rawValue).observe(.childChanged, with: { (snapshot) in
            if snapshot.exists() {
                
                
                let data = snapshot.value as! [String: Any]
                
                
                
                
                let noti =  LDACANotification(withSnapshotValue: data)
                noti.notificationType = LDACANotificationType.AppNotification
                print(noti.parent)
                noti.parent = snapshot.key
                print(noti.parent)
                
                FirebaseLDACAUserAPI.shareInstance.getUserWithID(noti.fromID!, completion: { (arr) in
                    
                    noti.sendUser = arr.first
                    completion(noti)
                })
                
                
                
                
            }
        })
        
        
    }

    
    func updateAppNotification(role:String,key:String, _ value:Any, completion: @escaping (Bool) -> Swift.Void)
        
    {
        let newNotiRef = FIRDatabase.database().reference().child(LDACANotificationType.AppNotification.rawValue).child(role).child(self.parent).child(key)
        newNotiRef.setValue(value, withCompletionBlock: { (error, _) in
            
            
            if error == nil {
                completion(true)
                
                // completion(true,newNotiRef.key)
            } else {
                //  completion(false,"")
                
                completion(false)
            }
        })
        
        
    }

    class func sendApp(notification: LDACANotification, toRole: UserRoleNoti, withValues: [String: Any], completion: @escaping (Bool,String) -> Swift.Void)  {
                if let currentUserID = String(Int((FirebaseAuthAPI.shareInstance.currentLDACAUSer?.roleID)!)) as? String  {
        
                    
                    var value = withValues
                    
                   // value.updateValue(toRole.rawValue, forKey: "toRole")
                    
                    
                    let appNotiURL = FIRDatabase.database().reference().child(LDACANotificationType.AppNotification.rawValue).child(String(toRole.rawValue)).childByAutoId()
                    appNotiURL.setValue(value, withCompletionBlock: { (error, _) in
                        if error == nil {
                            
                            
                            completion(true,appNotiURL.key)
                        } else {
                            completion(false,"")
                        }
                    })

        
        
        
        }
        
        
    }

}
public enum UserRoleNoti: Int {

    case student //0
    case teacher //1
    case staff //2
    case allUser //3
}



/*
class Post: NSObject {
    var name: String = ""
    var avatar: String = ""
    var desc: String = ""
    var time: String = ""
    var content: String = ""
    var favorite: Bool = false
    var read: Bool = false
    
}
 */

