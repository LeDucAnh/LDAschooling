
import Foundation
import UIKit
import Firebase

class Conversation {
    
    //MARK: Properties
    let user: LDACAUser
    var lastMessage: Message
    
    //MARK: Methods
    class func showConversations(completion: @escaping ([Conversation]) -> Swift.Void) {
        if let currentUserID = String(Int((FirebaseAuthAPI.shareInstance.currentLDACAUSer?.roleID)!)) as? String {
            var conversations = [Conversation]()
            FIRDatabase.database().reference().child("LDACAUsers").child(currentUserID).child("conversations").observe(.childAdded, with: { (snapshot) in
                if snapshot.exists() {
                    let fromID = snapshot.key
                    let values = snapshot.value as! [String: String]
                    let location = values["location"]!
                    
                    
                  FirebaseLDACAUserAPI.shareInstance.getUserWithID(fromID, completion: { (users) in
                    let emptyMessage = Message.init(type: .text, content: "loading", owner: .sender, timestamp: 0, isRead: true)
                    
                    
                    let conversation = Conversation(user: users.first!, lastMessage: emptyMessage)
                    conversations.append(conversation)
                    conversation.lastMessage.downloadLastMessage(forLocation: location, completion: { (_) in
                        completion(conversations)
                        

                  })
                    })
                }
            })
        }
    }
                    /*
                    User.info(forUserID: fromID, completion: { (user) in
                        let emptyMessage = Message.init(type: .text, content: "loading", owner: .sender, timestamp: 0, isRead: true)
                        let conversation = Conversation.init(user: user, lastMessage: emptyMessage)
                        conversations.append(conversation)
                        conversation.lastMessage.downloadLastMessage(forLocation: location, completion: { (_) in
                            completion(conversations)
                        })
                    })
                        */
                    
                    
    
    
    //MARK: Inits
    init(user: LDACAUser, lastMessage: Message) {
        self.user = user
        self.lastMessage = lastMessage
    }
}

