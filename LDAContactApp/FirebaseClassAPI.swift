//
//  FirebaseClassCourseAPI.swift
//  LDAContactApp
//
//  Created by Mac on 4/19/17.
//  Copyright © 2017 LeDucAnh. All rights reserved.
//

import UIKit
import Firebase

public enum StudentStatus:Int
{
    case working
    case pending
    
    case banned

}
class FirebaseClassStudents
{
    var studentID:String?
    var studentStatus:StudentStatus?
    
   static let studentListRef =  FIRDatabase.database().reference(withPath: "ClassStudents")
    
    class func searchForClassIDInWithStudentIn(userID:String,completion: @escaping (_ classesID:[String]) -> Swift.Void)
        
    {
        var arr =  [String]()
        
        let ResQuery = studentListRef.queryOrdered(byChild: userID).queryEqual(toValue: 0)
        
        

        
        ResQuery.observeSingleEvent(of: .value, with: { (snapshot) in
            
            
                for item in snapshot.children
                {
                    arr.append((item as! FIRDataSnapshot).key)
  
                    


                }
            
            completion(arr)

        })
        
        
    }
    
    
    
    class func updateClassStudentsWithStudentIDArr(classID:String,sArr:[Int], completion: @escaping (_ result:Bool)-> Swift.Void)
    {
        
        for item in sArr
        {
            
            let newStudent = FirebaseClassStudents()
            newStudent.studentID = String(item)
            newStudent.studentStatus = .working
            
            studentListRef.child(classID).updateChildValues(newStudent.toAnyObject()) { (Error, FIRDatabaseReference) in
            
                if Error  == nil
                {
                    completion(true)
                }
                else
                {
                    completion(false)
                }
            
            }
            

            
        }
        
    }
    class func getStudentWithClassID(classID:String, completion: @escaping (_ studentIDArr:[Int]) -> Swift.Void)
        
    {
        let ref =     FirebaseClassStudents.studentListRef.child(classID)
        
        print(classID)
       // let ResQuery2 =  classRef.child("-KiQMMxSiGGW8NaSqW74").child("classStudentIDArr").child("2")
        
        ref.observe(.value, with: { (snapshot) in
            
            print(snapshot)

            print(snapshot.value)
           if  let snapshotValue = snapshot.value as? [String: AnyObject]


           {
                var intArr = [Int]()
                for item in snapshotValue
                {
                    print(item.key)
                    intArr.append(Int(item.key)!)
                }
                completion(intArr)
            
            }
            
        })
    }
    func toAnyObject() ->  [String : Any] {
        return [
            studentID!:studentStatus?.rawValue,
        
        ]
    }


}
class FirebaseClassAPI: NSObject {

    
    let apiURL = "https://contactapp-fd758.firebaseio.com"
    
    let classRef = FIRDatabase.database().reference(withPath: "Classes")

    static var sharedInstance = FirebaseClassAPI()
    
    let supportField = ["className","classRoomCode"]
    
    func fetchClassValueFor(user:LDACAUser,value: String,_ completion:@escaping (_ value: [Any],_ classIDsArr: [String])->Void)
    {
        self.fetchClassIDFor(user: user) { (classIDsArr) in
            
            
            
            var returnValues = [Any]()

            for classID in classIDsArr
            {
                
                
        self.classRef.child(classID).child(value).observeSingleEvent(of: .value, with: { (FIRDataSnapshot) in
                    
                    print(FIRDataSnapshot.value)
                    returnValues.append(FIRDataSnapshot.value)
                    if returnValues.count == classIDsArr.count
                    {
                        completion(returnValues,classIDsArr)
                    }
                    
                })
                
            }
        }
    }
    
    func fetchClassIDFor(user:LDACAUser,_ completion:@escaping (_ classesID: [String])->Void)
    {
        
        FirebaseClassStudents.searchForClassIDInWithStudentIn(userID:  String(Int(user.roleID!))) { (classIDsArr) in
            
            completion(classIDsArr)
            
            
            
        }
    }
    
    
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
    
    func updateClassCourse(_ classcourse:LDACAClass,completion:@escaping (_ DidSignIn:Bool)->Void)
    {
        
        
        let ref  =  FIRDatabase.database().reference(fromURL: apiURL)
        let usersRef  =  ref.child("Classes")
        let userref = usersRef.childByAutoId()
        
        
        
        let values  = classcourse.toAnyObject() as! [String : Any]
        
        

                userref.updateChildValues(values) { (Error, FIRDatabaseReference) in
                    
                    //update user
                    if Error == nil
                    {
                        //successfully updated user
                        
                      FirebaseClassStudents.updateClassStudentsWithStudentIDArr(classID: FIRDatabaseReference.key, sArr: classcourse.classStudentIDArr, completion: { (result) in
                        
                        
                        if result{
                            completion(true)
                        }
                        else
                        {
                            completion(false)
                        }
                        
                      })
            //     FirebaseClassStudents.updateClassStudentsWithStudentIDArr(classID: FIRDatabaseReference.key, sArr: classcourse.classStudentIDArr, completion: (Bool) -> Void)
                        

                    
                        
                    }
                    else
                    {
                        completion(false)
                        
                    }
        }
        
                
        
            
            
        
        
    }
    
    
    func registerForClassChange(_ completion:@escaping (_ class: [LDACAClass])->Void)
    {
        let ResQuery = classRef.queryOrdered(byChild: "timestamp").queryLimited(toLast: 2)
        
        ResQuery.observe(.childChanged, with:
            {
                snapshot in
                
                // 3
                var newItems: [LDACAClass] = []
                // for item in snapshot.children {
                // 4
                
                
                let newclass = LDACAClass(snapshot: snapshot, parent: snapshot.key)

                newItems.append(newclass)
                
                newclass.getStudentIDForSelf()

                //}
                
                // 5
                
                completion(newItems)
                
        })

    }
    
    func getLastedObjects(_ lastobject : LDACAClass,_ completion:@escaping (_ class: [LDACAClass])->Void)
    {
        /*
        
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
*/
        
        
        // classRef.queryOrdered(byChild: "classDaysArray")
        let ResQuery = classRef.queryOrdered(byChild: "timestamp").queryEnding(atValue: lastobject.timestamp! - 1).queryLimited(toLast: 2)
        ResQuery.observeSingleEvent(of: .value, with: { (snapshot) in
            var newItems: [LDACAClass] = []
            
            


            
            print(snapshot.children)
            
            for item in snapshot.children  {
            // 4
            
            
            print(snapshot.key)
            
            print(snapshot.value)
            print(snapshot.ref.parent)
            print(snapshot.ref.parent?.key)
            
            
            let newclass = LDACAClass(snapshot: item as! FIRDataSnapshot, parent: (item as AnyObject).key)
            newItems.append(newclass)
            newclass.getStudentIDForSelf()
            }
            
            // 5
            
            completion(newItems)

            
        })
        

    }
    
    func registerForAddedClass(_ completion:@escaping (_ class: [LDACAClass])->Void)
    {
        // ResQuery.observe(.value, with: { snapshot in
        // let ResQuery = regRef.queryLimited(toLast:2)
       // classRef.queryOrdered(byChild: "classDaysArray")
        let ResQuery = classRef.queryOrdered(byChild: "timestamp").queryLimited(toLast: 1)
        
        
        ResQuery.observe(.childAdded, with:
            {
                snapshot in
                
                // 3
                var newItems: [LDACAClass] = []
                // for item in snapshot.children {
                // 4
                
                
                print(snapshot.key)
                
                print(snapshot.value)
                print(snapshot.ref.parent)
                print(snapshot.ref.parent?.key)
                

                let newclass = LDACAClass(snapshot: snapshot, parent: snapshot.key)
                newItems.append(newclass)
                newclass.getStudentIDForSelf()
                //}
                
                // 5
                
                completion(newItems)
        })
        
    }
    func checkIfUserDataExist(uidString:String,completion:@escaping (_ result:Bool)->Void)
    {
        let ref  =  FIRDatabase.database().reference(fromURL:apiURL)
        let usersRef  =  ref.child("Users").child(uidString)
        
        
        usersRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            
            
            
            if snapshot.exists(){
                completion(true)
            }
            else
            {
                completion(false)
            }
        })
        
        
    }
    

    func uploaadClassStudentAndTeacherFromExcell(sheet:BRAWorksheet)
    {
        
     let classesWithTeacherAndStudentOnly =   LDACAClass.returnClassWithTeacherAndStudentIDFrom(sheet: sheet)
        
        for updateclass in classesWithTeacherAndStudentOnly
        {
            
         let query =    self.classRef.queryOrdered(byChild: "className").queryEqual(toValue: updateclass.className)
            query.observeSingleEvent(of: .value, with: { (snapshot) in
                
                if snapshot.exists(){
                    print(snapshot.value)
                    print(updateclass.className)
                    print(snapshot.ref.parent?.key)
                    let snapshotValue = snapshot.value as! [String: AnyObject]
                                        print(snapshotValue.keys.first)
                    let parent =  snapshotValue.keys.first

                    
                    
                    let xclass = LDACAClass(snapshot: snapshot, parent: parent!)
                    
                    print(xclass.parent)
                    print(snapshot.key)
                    if let parent = (xclass.parent) as? String
                    {
                        //https://www.dropbox.com/s/rlp3mmhx4jqgz8r/Untitled%20spreadsheet.xlsx?dl=0
                        
                     if   snapshot.key != ""
                     {
                       // let values  = updateclass.toAnyObjectWithTeacherIDAndStudent()
                        
                        //self.classRef.child(parent).updateChildValues(values as! [AnyHashable : Any])

                        FirebaseClassStudents.updateClassStudentsWithStudentIDArr(classID: xclass.parent!, sArr: updateclass.classStudentIDArr, completion: {
                            (result) in
                        })
                                            }
                    }
                    
                    
                 //   completion(true)
                }
                else
                {
                  //  completion(false)
                }

                
            })
            
        }
    }



}
