//
//  LDACATeacher.swift
//  LDAContactApp
//
//  Created by Mac on 4/21/17.
//  Copyright © 2017 LeDucAnh. All rights reserved.
//

import UIKit
import Firebase
class LDACATeacher: NSObject {
    //unsaved
    var parent:String?
    //
    
    var email: String
    
    var name :String
    var profileImageURL:String
    var password:String
    var firstName:String
    var lastName:String
    //since 1970
    var BirthDay:Double?
    
    var enrollYear:Float
    var teacherID:Float?
    override init() {
        self.email = ""
        name = ""
        profileImageURL = ""
        password = ""
        lastName = ""
        firstName = ""
        enrollYear = 1900
    }
    
    init(snapshot: FIRDataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        let   ref = snapshot.ref
        
        
        
        
        
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
        
        
        
        
        
        if let teacherID = snapshotValue["teacherID"] as? Float
        {
            self.teacherID = teacherID
        }
        
        
        if let lastName = snapshotValue["lastName"]
        {
            self.lastName = (lastName as! String)
        }
        
        if let enrollYear = snapshotValue["enrollYear"]
        {
            self.enrollYear = (Float(enrollYear as! Double))
        }
        
        
        
        
        
    }
    
    /*
    init(worksheet:BRAWorksheet,index :Int) {
        
        self.email = ""
        name = ""
        profileImageURL = ""
        password = ""
        firstName = ""
        self.lastName = ""
        
        
        
        var cell = worksheet.cell(forCellReference: "A" + String(index))
        self.firstName = (cell?.stringValue())!
        
        cell = worksheet.cell(forCellReference: "B" + String(index))
        self.teacherID = cell?.floatValue()
        
        cell = worksheet.cell(forCellReference: "C" + String(index))
        self.enrollYear = (cell?.floatValue())!
        
        cell = worksheet.cell(forCellReference: "D" + String(index))
        self.BirthDay = ExcelHelpers.convertfromExcelDate(exceldate: Double((cell?.floatValue())!)).timeIntervalSince1970
        
        cell = worksheet.cell(forCellReference: "E" + String(index))
        self.lastName = (cell?.stringValue())!
        
        
        
        
    }*/
    
    func toAnyObject() -> Any {
        return [
            "name": name,
            "email":email,
            "profileImageURL":profileImageURL,
            
            "password":password,
            "firstName":firstName,
            "lastName":lastName,
            "BirthDay":BirthDay,
            "enrollYear":enrollYear,
            "teacherID":teacherID
        ]
    }

}
