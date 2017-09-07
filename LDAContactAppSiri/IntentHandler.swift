//
//  IntentHandler.swift
//  LDAContactAppSiri
//
//  Created by Mac on 6/7/17.
//  Copyright © 2017 LeDucAnh. All rights reserved.
//

import Intents
import Foundation

// As an example, this class is set up to handle Message intents.
// You will want to replace this or add other intents as appropriate.
// The intents you wish to handle must be declared in the extension's Info.plist.

// You can test your example integration by saying things to Siri like:
// "Send a message using <myApp>"
// "<myApp> John saying hello"
// "Search for messages in <myApp>"

class IntentHandler: INExtension, INSendMessageIntentHandling, INSearchForMessagesIntentHandling, INSetMessageAttributeIntentHandling {
    let wormhole = MMWormhole(applicationGroupIdentifier: "group.LeDucAnh.LDAContactApp", optionalDirectory: "sirikitexample")
    
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        return self
    }
    
    // MARK: - INSendMessageIntentHandling
    
    // Implement resolution methods to provide additional information about your intent (optional).
    
    /*func resolveRecipients(forSendMessage intent: INSendMessageIntent, with completion: @escaping ([INPersonResolutionResult]) -> Void) {
     
     
     if let recipients = intent.recipients {
     
     // If no recipients were provided we'll need to prompt for a value.
     if recipients.count == 0 {
     completion([INPersonResolutionResult.needsValue()])
     return
     }
     
     var resolutionResults = [INPersonResolutionResult]()
     for recipient in recipients {
     let matchingContacts = [recipient] // Implement your contact matching logic here to create an array of matching contacts
     switch matchingContacts.count {
     case 2  ... Int.max:
     // We need Siri's help to ask user to pick one from the matches.
     resolutionResults += [INPersonResolutionResult.disambiguation(with: matchingContacts)]
     
     case 1:
     // We have exactly one matching contact
     resolutionResults += [INPersonResolutionResult.success(with: recipient)]
     
     case 0:
     // We have no contacts matching the description provided
     resolutionResults += [INPersonResolutionResult.unsupported()]
     
     default:
     break
     
     }
     }
     completion(resolutionResults)
     }
     }
     */
    func makeArr()->[INPerson]
        
    {
        var matchingContacts = [INPerson]()
        
        if let arr =  UserDefaults(suiteName: "group.LeDucAnh.LDAContactApp")?.stringArray(forKey: "Conversations")
        {
            for item  in arr
                
                
            {
                let person = INPerson(personHandle: INPersonHandle(value: item, type: .unknown), nameComponents: nil, displayName: item, image: nil, contactIdentifier: "", customIdentifier: "")
                
                matchingContacts.append(person)
                
            }
        }
        
        
        
        //   let person3 = INPerson(personHandle: INPersonHandle(value: "David", type: .unknown), nameComponents: nil, displayName: "David", image: nil, contactIdentifier: "", customIdentifier: "")
        
        
        
        
        // let person2 = INPerson(personHandle: INPersonHandle(value: "John 3", type: .unknown), nameComponents: nil, displayName: "John 3" , image: nil, contactIdentifier: "", customIdentifier: "")
        
        // Implement your contact matching logic here to create an array of matching contacts
        
        return matchingContacts
        
        
    }
    
    func resolveRecipients(forSendMessage intent: INSendMessageIntent, with completion: @escaping ([INPersonResolutionResult]) -> Void) {
        
        
        print(intent)
        /*
         if (intent.content?.contains("teacher"))!
         {         var resolutionResults = [INPersonResolutionResult]()
         
         let person = INPerson(personHandle: INPersonHandle(value: "Teacher", type: .unknown), nameComponents: nil, displayName: "teacher", image: nil, contactIdentifier: "", customIdentifier: "")
         
         
         
         resolutionResults += [INPersonResolutionResult.success(with: person)]
         
         
         
         
         completion(resolutionResults)
         
         }
         */
        if let recipients = intent.recipients {
            
            // If no recipients were provided we'll need to prompt for a value.
            
            
            var resolutionResults = [INPersonResolutionResult]()
            
            
            if recipients.count == 0 {
                //  completion([INPersonResolutionResult.needsValue()])
                // return
                let matchingContacts = self.makeArr()
                resolutionResults += [INPersonResolutionResult.disambiguation(with: matchingContacts)]
                completion(resolutionResults)
                
            }
            
            
            
            
            
            
            
            for recipient in recipients {
                
                
                var matchingContacts = [INPerson]()
                for item in self.makeArr()
                {
                    if item.displayName.lowercased() == recipient.displayName.lowercased()
                    {
                        matchingContacts.append(item)
                    }
                }
                // Implement your contact matching logic here to create an array of matching contacts
                
                
                switch matchingContacts.count {
                case 2  ... Int.max:
                    // We need Siri's help to ask user to pick one from the matches.
                    resolutionResults += [INPersonResolutionResult.disambiguation(with: matchingContacts)]
                    
                case 1:
                    // We have exactly one matching contact
                    resolutionResults += [INPersonResolutionResult.success(with: recipient)]
                    
                case 0:
                    // We have no contacts matching the description provided
                    let matchingContacts = self.makeArr()
                    resolutionResults += [INPersonResolutionResult.disambiguation(with: matchingContacts)]
                    
                default:
                    break
                    
                }
            }
            if recipients.count == 0
            {
                let matchingContacts = self.makeArr()
                resolutionResults += [INPersonResolutionResult.disambiguation(with: matchingContacts)]
            }
            
            completion(resolutionResults)
        }
    }
    
    
    func resolveContent(forSendMessage intent: INSendMessageIntent, with completion: @escaping (INStringResolutionResult) -> Void) {
        
        
        
        if let text = intent.content, !text.isEmpty {
            completion(INStringResolutionResult.success(with: text))
        } else {
            completion(INStringResolutionResult.needsValue())
        }
    }
    
    // Once resolution is completed, perform validation on the intent and provide confirmation (optional).
    
    func confirm(sendMessage intent: INSendMessageIntent, completion: @escaping (INSendMessageIntentResponse) -> Void) {
        // Verify user is authenticated and your app is ready to send a message.
        
        
        let userActivity = NSUserActivity(activityType: NSStringFromClass(INSendMessageIntent.self))
        let response = INSendMessageIntentResponse(code: .ready, userActivity: userActivity)
        completion(response)
    }
    
    // Handle the completed intent (required).
    
    func handle(sendMessage intent: INSendMessageIntent, completion: @escaping (INSendMessageIntentResponse) -> Void) {
        // Implement your application logic to send a message here.
        print("Message intent is being handled.")
        
        
        
        var dict = Dictionary<String, Any>()
        dict.updateValue((intent.recipients?.first?.displayName)!, forKey: "recipient")
        dict.updateValue(intent.content!, forKey: "content")
        var i = 0
        for item in self.makeArr()
        {
            
            if item.displayName == intent.recipients?.first?.displayName
            {
                
               dict.updateValue(i, forKey: "positioninArr")
                
                
            }
            i += 1
            
        }
        
        if let coding = dict as? NSCoding
        {
            
        wormhole.passMessageObject(coding , identifier: "intent.content")
       
        }


        
        print(intent.content)
        let userActivity = NSUserActivity(activityType: NSStringFromClass(INSendMessageIntent.self))
        let response = INSendMessageIntentResponse(code: .success, userActivity: userActivity)
        completion(response)
    }
    
    // Implement handlers for each intent you wish to handle.  As an example for messages, you may wish to also handle searchForMessages and setMessageAttributes.
    
    // MARK: - INSearchForMessagesIntentHandling
    
    func handle(searchForMessages intent: INSearchForMessagesIntent, completion: @escaping (INSearchForMessagesIntentResponse) -> Void) {
        // Implement your application logic to find a message that matches the information in the intent.
        
        let userActivity = NSUserActivity(activityType: NSStringFromClass(INSearchForMessagesIntent.self))
        let response = INSearchForMessagesIntentResponse(code: .success, userActivity: userActivity)
        // Initialize with found message's attributes
        response.messages = [INMessage(
            identifier: "identifier",
            content: "I am so excited about SiriKit!",
            dateSent: Date(),
            sender: INPerson(personHandle: INPersonHandle(value: "sarah@example.com", type: .emailAddress), nameComponents: nil, displayName: "Sarah", image: nil,  contactIdentifier: nil, customIdentifier: nil),
            recipients: [INPerson(personHandle: INPersonHandle(value: "+1-415-555-5555", type: .phoneNumber), nameComponents: nil, displayName: "John", image: nil,  contactIdentifier: nil, customIdentifier: nil)]
            )]
        completion(response)
    }
    
    // MARK: - INSetMessageAttributeIntentHandling
    
    func handle(setMessageAttribute intent: INSetMessageAttributeIntent, completion: @escaping (INSetMessageAttributeIntentResponse) -> Void) {
        // Implement your application logic to set the message attribute here.
        
        let userActivity = NSUserActivity(activityType: NSStringFromClass(INSetMessageAttributeIntent.self))
        let response = INSetMessageAttributeIntentResponse(code: .success, userActivity: userActivity)
        completion(response)
    }
}

