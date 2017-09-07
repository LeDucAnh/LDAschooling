//
//  SiriHandler.swift
//  LDAContactApp
//
//  Created by Mac on 6/7/17.
//  Copyright © 2017 LeDucAnh. All rights reserved.
//

import UIKit

class SiriHandler: NSObject {

    static var sharedInstance = SiriHandler()
    let wormhole = MMWormhole(applicationGroupIdentifier: "group.LeDucAnh.LDAContactApp", optionalDirectory: "sirikitexample")
    
    

    
    var currentUSerConversationUser = [LDACAUser]()
    var currentuserClass = [LDACAClass]()
    
    func sendAbsentFormToClass(selectedIndex :Int,_ message:Dictionary<String, Any>)
    {
        let (intentObject,bool) =  LDAIntentAbsentObject.shareInstance.getIntentObjectFrom(intentString: message["content"]! as! String)
        
        if bool
        {
            
            let receivedClass =  message["recipient"]
            let date =   intentObject.returnDate()
            
            

            
            //send absentform
            let request = LDACAClassRequest()
            
            request.dateTime = date.timeIntervalSince1970
            request.content = message["content"] as! String
            request.requestType = LDACAClassRequestType.absent.rawValue
            request.timestamp =  Int(Date().timeIntervalSince1970)
            request.fromID =  String(Int((FirebaseAuthAPI.shareInstance.currentLDACAUSer?.roleID)!))
            //request.classID =  self.classmodel?.parent
            
            
            request.uploadToClass(classID: (currentuserClass[selectedIndex].parent)!, { (Bool) in
                if Bool
                {
                    LDAActionResultHandler.sharedInstance.handleAction(title : "uploaded Request")
                    
                    
                }
            })
 
   
        }
    }

    
    
    func sendMessageToUSer(selectedIndex :Int,_ message:Dictionary<String, Any>)
    {
        
        let user  = currentUSerConversationUser[selectedIndex]
        
        let message = Message.init(type: .text, content: message["content"], owner: .sender, timestamp: Int(Date().timeIntervalSince1970), isRead: false)
        Message.send(message:message, toID:String(Int(user.roleID!)), completion: {(_) in
            
            
            
            
            
        })

        
    }
    func handleReceivedMessage(message:Dictionary<String, Any>)
    {

       if let position =  message["positioninArr"] as? Int
        
       {
        
        print(position)
            if position < self.currentUSerConversationUser.count
            {
                self.sendMessageToUSer(selectedIndex: position, message)
            
            }
            else{
                
                
                self.sendAbsentFormToClass(selectedIndex: self.currentUSerConversationUser.count - position, message)
            
            }
        
        

        }
    }
    func setConverstionToSiriExtension()
    {
    
        
        self.wormhole.listenForMessage(withIdentifier: "intent.content") { (messageObject) in
            if let message = messageObject as? Dictionary<String, Any> {
                // Do something
                print(message)
                
                
               self.handleReceivedMessage(message: message)
                
            }
            
            
        }
        
        
        var siriUserConversationNameArr = [String]()

        if let value =  FirebaseAuthAPI.shareInstance.currentLDACAUSer
        {
            
        }
        else
        {
            return
        }
        
        
        FirebaseClassAPI.sharedInstance.fetchClassValueFor(user: FirebaseAuthAPI.shareInstance.currentLDACAUSer!, value: "className") { (returnValues,classIDArr) in
            
            var i = 0
            for item in returnValues
            {
                let Class = LDACAClass()
                Class.className = item as! String
                Class.parent = classIDArr[i]
                i += 1
                
                
                
                self.currentuserClass.append(Class)
            }
            
            if FirebaseAuthAPI.shareInstance.currentUser?.RoleID != nil
            {
                
                FirebaseLDACAUserAPI.shareInstance.returnConversationUserWithUserFromCurrentUser { (arr) in

                    self.currentUSerConversationUser = arr
                    
                    
                    
                    ///-----
                    for item in self.currentUSerConversationUser{
                        
                        siriUserConversationNameArr.append((item.firstName + " " +  item.lastName))
                        
                    
                    }
                    for item in self.currentuserClass{
                        
                        siriUserConversationNameArr.append((item.className!))
                        
                        
                    }

                    
                    UserDefaults(suiteName: "group.LeDucAnh.LDAContactApp")?.set(siriUserConversationNameArr, forKey: "Conversations")
                }
            }

            
            
            
        }
        
       
        

    }
    
}
