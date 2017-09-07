//
//  ClassCourse.swift
//  LDAContactApp
//
//  Created by Mac on 4/18/17.
//  Copyright © 2017 LeDucAnh. All rights reserved.
//

import UIKit
import Firebase
import Eureka


extension Date {
    var localTime: String {

        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm"
        
        return  formatter.string(from: self)
     //   return description(with: NSLocale.current)
        
    }
    
    /*
  static func dateFromString(string : String)->Date
    {
   
    let formatter = DateFormatter()
    formatter.dateFormat = "dd.MM.yyyy HH:mm"
   return formatter.date(from: string)!
    

    }
 */
    static func convertToLocalDate(timeInterval:TimeInterval)->TimeInterval
    {
        
        return timeInterval + 7 * 3600
        
    }
    func convertToLocalDate()->TimeInterval
    {
        
        
     return  self.timeIntervalSince1970   + 7 * 3600
    }
}




class LDACAClass: NSObject {
    
    
    
    class func returnClassWithTeacherAndStudentIDFrom(sheet:BRAWorksheet)->[LDACAClass]
    {
        var classesname = [String]()
        var total:Int =  Int((sheet.cell(forCellReference: "D1") as! BRACell).floatValue())
        
        var classArr = [LDACAClass]()
        var endClassRow = [Int]()
        var i = 1
        
        while i <= total
        {
            var cell: BRACell = sheet.cell(forCellReference: "A" + String(i))
            if let cname =  cell.stringValue()
            {
                if cname != ""
                {
                    //start scanning
                    print(cname)
                    classesname.append(cname)
                    endClassRow.append(i)
                    
                    let newclass = LDACAClass()
                    
                    let cellAddress = "B" + String(i)
                    
                    newclass.className = cell.stringValue()
                    newclass.classTeacherID = Int(sheet.cell(forCellReference:cellAddress).floatValue())
                    classArr.append(newclass)
                }
                
            }else
            {
                
            }
            
            
            
            let cellAddress = "C" + String(i)
            classArr.last?.classStudentIDArr.append(Int(sheet.cell(forCellReference:cellAddress).floatValue()))
            
            
                        i += 1
        }
        return classArr

    }
 
    //unsaved
    var parent:String?
    //
    

    var className :String?
    var classWeekDuration: Int?
    var classDaysArray = [Double]()
    var classRoomCode :String?
    
    var classStartDay :Double?
    var timestamp: Double?
    
    var classTeacherID : Int?
    var classStudentIDArr = [Int]()
    override init() {

    }
    func generateDaysWithWeekDurationAndDaysInWeekArr()->[Double]
    {
        
        
            var   classDayArr = [Double]()
        
        
            var i = 0
        
                while i < classWeekDuration!
                {
                    
                    
                        for day in classDaysArray
                        {
                            let newDay = day  + Double(i * 604800)
                            
                            classDayArr.append(newDay)
                        }
                    
                    
                    i += 1
                    
                }
        
        
        
        return classDayArr
        
    }
    func calculateEndDay()->Date
    {
        
        
        
        print( ((self.classDaysArray.last)! + Double(self.classWeekDuration! * 7 * 24 * 3600)))
        
        print(Double(self.classWeekDuration!) * 7 * 24 * 3600)
        print(self.classDaysArray.last!)
        let endTimeInterval = self.classDaysArray.last! + Double(self.classWeekDuration! * 7 * 24 * 3600)
       
        
       return  Date(timeIntervalSince1970: endTimeInterval)
    }
    func IsNill()->Bool
    {
        
        if self.classWeekDuration == nil
        {
            return true
        }
        if self.classDaysArray.count == 0
        {
            return true
        }
        if self.classRoomCode == nil
        {
            return true
        }
        if self.className == nil
        {
            return true
        }
        if self.classTeacherID == nil{
            return true
        }
        return false
    }
    init(registerForm:Form) {

        for row in registerForm.allRows
        {
            
            if row.tag == "ClassTeacherID"
            {
                
                if (row as! IntRow).cell.textField.textColor == UIColor.green
                {
                    
                
                    self.classTeacherID = Int(((row as! IntRow).cell.textField.text?.replacingOccurrences(of: ".", with: ""))!)
                }
                
            }
            if row.tag == "ClassName"
            {
                
                
                print((row.baseCell as! NameCell).textField.text)
                
                self.className = (row.baseCell as! NameCell).textField.text
            }
            if row.tag == "RoomCode"
            {
                
                classRoomCode = (row.baseCell as! NameCell).textField.text
            }
            if row.tag == "Week"
            {
                
                print((row as! IntRow).cell.textField.text)
               self.classWeekDuration =  Int((row as! IntRow).cell.textField.text!)
                
            }
            
            if let tag =  row.tag
                
            {
                if tag.contains("Day in Week")
                {
                    
                    
                    //use this to get a string
                     print((row as! DateTimeRow).value?.localTime)
               
                    //use this to get the date to localtime value
                    print(Date(timeIntervalSince1970: Date.convertToLocalDate(timeInterval: ((row as! DateTimeRow).value?.timeIntervalSince1970)!)))
                    self.classDaysArray.append(((row as! DateTimeRow).value?.timeIntervalSince1970)!)
                    
                    
                    if self.classDaysArray.count == 1
                    {
                    self.classStartDay  = self.classDaysArray.first
                    }

                }
                if tag.contains("StudentID")
                {
                    
                    self.classStudentIDArr.append(Int(((row as! IntRow).cell.textField.text?.replacingOccurrences(of: ".", with: ""))!)!)

                }
                
                
            }
        }
        
        self.timestamp = Date().timeIntervalSince1970
      
        
        
    }
    
    init(snapshot: FIRDataSnapshot,parent:String) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        let   ref = snapshot.ref
        print(snapshotValue.keys.first)
        self.parent =  snapshotValue.keys.first
        
        self.parent = parent
        /*
        
        
        self.profileImageURL = ""
        self.name = ""
        
        
        
        self.email = ""
        
        
        self.enrollYear = 1900
        
        self.password = ""
        
        self.lastName = ""
        self.firstName = ""
        if let firstName = snapshotValue["firstName"]
        {
            self.firstName = firstName as! String
        }
        if let email = snapshotValue["email"]
        {
            self.email = email as! String
        }
        
        if let BirthDay = snapshotValue["BirthDay"]
        {
            self.BirthDay = BirthDay as! Double
        }
        
        
        
        
        
        if let studentkey = snapshotValue["studentID"] as? Float
        {
            self.studentID = studentkey
        }
        
        
        if let lastName = snapshotValue["lastName"]
        {
            self.lastName = (lastName as! String)
        }
        
        if let enrollYear = snapshotValue["enrollYear"]
        {
            self.enrollYear = (Float(enrollYear as! Double))
        }
        
        
        */

        if let className = snapshotValue["className"]
        {
            self.className = (className as! String)
        }

        if let classRoomCode = snapshotValue["classRoomCode"]
        {
            self.classRoomCode = (classRoomCode as! String)
        }
        

        if let classStartDay = snapshotValue["classStartDay"]
        {
            self.classStartDay = (classStartDay as! Double)
        }
        if let timestamp = snapshotValue["timestamp"]
        {
            self.timestamp = (timestamp as! Double)
        }
        if let classWeekDuration = snapshotValue["classWeekDuration"]
        {
            self.classWeekDuration = (classWeekDuration as! Int)
        }
        if let classDaysArray = snapshotValue["classDaysArray"]
        {
            self.classDaysArray = (classDaysArray as! [Double])
        }

        /*
        if let classStudentIDArr = snapshotValue["classStudentIDArr"]
        {
            self.classStudentIDArr = (classStudentIDArr as! [Int])
        }
 */
        if let classTeacherID = snapshotValue["classTeacherID"]
        {
            self.classTeacherID = (classTeacherID as! Int)
        }
        


        
        

        
        
    }
    
    func getStudentIDForSelf()
    {
        FirebaseClassStudents.getStudentWithClassID(classID: self.parent!) { (result) in
            self.classStudentIDArr =  result
        }

    }
    
    func toAnyObject() ->  [String : Any] {
        return [
            "className": className,
       
            "classWeekDuration":classWeekDuration,
            "classDaysArray":classDaysArray,
            "classRoomCode":classRoomCode,
            "timestamp":timestamp,
            "classStartDay":classStartDay,
            "classStudentIDArr":classStudentIDArr,
            "classTeacherID":classTeacherID
        ]
    }


}
