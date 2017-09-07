//
//  LDACAUser.swift
//  LDAContactApp
//
//  Created by Mac on 4/12/17.
//  Copyright © 2017 LeDucAnh. All rights reserved.
//

import UIKit
import Firebase

import Eureka
extension UIImage {
    func downloadedFrom(url: URL,_ completion:@escaping (_ image:UIImage)->Void) {

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { () -> Void in
                    completion(image)
            }
            }.resume()
    }
}

class ExcelHelpers : NSObject
{
    class func convertfromExcelDate(exceldate:Double) -> Date
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        let someDateTime = formatter.date(from: "12/31/1899")
        
        return Date(timeInterval: exceldate * 86400, since: someDateTime!) as Date
        

    }
}
public var LDACAUser_NoneRoleID:Float = -1.0
class LDACAUser: NSObject {
    
    //unsaved
    var profileimage : UIImage?
    var parent:String?
    //
    
    var email: String

    var name :String
    var profileImageURL:String
    var password:String!
    var firstName:String!
    var lastName:String!
    //since 1970
    var BirthDay:Double?
    
    var role:Int?

    
    var enrollYear:Float
    var roleID:Float?
    override init() {
        self.email = ""
        name = ""
        profileImageURL = ""
        password = ""
        lastName = ""
        firstName = ""
        enrollYear = 1900
        self.roleID = LDACAUser_NoneRoleID
    }
    
    init(registerForm:Form) {
        
        self.email = ""
        name = ""
        profileImageURL = ""
        password = ""
        lastName = ""
        firstName = ""
        enrollYear = 1900
        self.roleID = LDACAUser_NoneRoleID

        for row in registerForm.allRows
        {
            
            if row.tag == "RoleID"
            {
                
                
                    self.role = Int(((row as! IntRow).cell.textField.text?.replacingOccurrences(of: ".", with: ""))!)
                
            }
            if row.tag == "RolePicker"
            {
                
                print(((row as! PickerInputRow<String>).value)!)
            // self.role = Int(((row as! IntRow).cell.textField.text?.replacingOccurrences(of: ".", with: ""))!)
                
                
                let id = Int(((row as! PickerInputRow<String>).value?.components(separatedBy: " ").last)!)
                print(id)
                self.role = id
                
            }

            if row.tag == "UserID"
            {
                
                if (row as! IntRow).cell.textField.textColor == UIColor.green
                {
                    
                    
                    self.roleID = Float(Int(((row as! IntRow).cell.textField.text?.replacingOccurrences(of: ".", with: ""))!)!)
                }
                
            }

            if row.tag == "FirstName"
            {
                
                
                print((row.baseCell as! NameCell).textField.text)
                
                self.firstName = (row.baseCell as! NameCell).textField.text
            }
            if row.tag == "LastName"
            {
                
                
                print((row.baseCell as! NameCell).textField.text)
                
                self.lastName = (row.baseCell as! NameCell).textField.text
            }

            if row.tag == "BirthDay"
            {
                    
                    
                    //use this to get a string
                    print((row as! DateTimeRow).value?.localTime)
                    
                    //use this to get the date to localtime value
                    print(Date(timeIntervalSince1970: Date.convertToLocalDate(timeInterval: ((row as! DateTimeRow).value?.timeIntervalSince1970)!)))
                    self.BirthDay = ((row as! DateTimeRow).value?.timeIntervalSince1970)!
                
            }
            
            
        }
        
        
    }

    func  setValuewith(Key:String,value : Any,_ completion:@escaping (_ result:Bool)->Void)
    {
        if Key == "profileImageURL"
        {
            self.profileImageURL =  value as! String
            
            self.profileimage?.downloadedFrom(url: URL(string:self.profileImageURL)!, { (image) in
                
                self.profileimage = image
                
                completion(true)
            })
        }
        
        if Key == "role"
        {
            self.role =  value as! Int
            

            completion(true)
            
            
        }

        
        
        
        
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
        if let ProImg = snapshotValue["profileImageURL"]
        {
            self.profileImageURL = ProImg as! String
        }

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
        
        
     
        
        
        if let studentkey = snapshotValue["roleID"] as? Float
        {
            self.roleID = studentkey
        }
        
        
        if let lastName = snapshotValue["lastName"]
        {
            self.lastName = (lastName as! String)
        }
        if let password = snapshotValue["password"]
        {
            self.password = (password as! String)
        }
        
        
        if let enrollYear = snapshotValue["enrollYear"]
        {
            self.enrollYear = (Float(enrollYear as! NSNumber))
        }
        
        if let role = snapshotValue["role"]
        {
            self.role = UserRole(rawValue: role as! Int).map { $0.rawValue }
        }
        

        
        
        
        
    }
    

     init(Worksheet:BRAWorksheet,index :Int) {

        self.email = ""
        name = ""
        profileImageURL = ""
        password = ""
        firstName = ""
        self.lastName = ""

        
        
        var cell = Worksheet.cell(forCellReference: "A" + String(index))
        self.firstName = (cell?.stringValue())!
        
        cell = Worksheet.cell(forCellReference: "B" + String(index))
        self.roleID = cell?.floatValue()
        
        cell = Worksheet.cell(forCellReference: "C" + String(index))
        self.enrollYear = (cell?.floatValue())!

        cell = Worksheet.cell(forCellReference: "D" + String(index))
        self.BirthDay = ExcelHelpers.convertfromExcelDate(exceldate: Double((cell?.floatValue())!)).timeIntervalSince1970
        
        cell = Worksheet.cell(forCellReference: "E" + String(index))
        self.lastName = (cell?.stringValue())!
       
        
        
        cell = Worksheet.cell(forCellReference: "F" + String(index))
        self.role = Int((cell?.floatValue())!)

     
        
    }
    


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
            "roleID":roleID,
            "role":role
        ]
    }

    /*var uid: String
     var email: String
     
     var name :String
     var profileImageURL:String
     var password:String
     var firstName:String
     var lastName:String
     var BirthDay:Date?
     var enrollYear:Float
     var roleID:Float?
*/
}
