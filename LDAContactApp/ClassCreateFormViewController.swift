//
//  ClassCreateFormViewController.swift
//  LDAContactApp
//
//  Created by Mac on 4/17/17.
//  Copyright © 2017 LeDucAnh. All rights reserved.
//

import UIKit
import AVFoundation
import Eureka
import CoreLocation
import Whisper

class ClassCreateFormViewController:FormViewController,UIPickerViewDelegate
{
    
    
    
    var SubmitAddressToLoc : Bool =  false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupForm()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        
        self.navigationController?.isNavigationBarHidden = true

    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false

    }
    
    
    var LDAHeaderBlueTextColor = UIColor.init(colorLiteralRed: 47/255, green: 150/255, blue: 245/255, alpha: 1)
    
    var LDASubHeaderOrgangeTextcolor = UIColor.init(colorLiteralRed: 250/255, green: 150/255, blue: 42/255, alpha: 1)


    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        //  view.tintColor =
        // Text Color
        //UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
        // [header.textLabel setTextColor:[UIColor whiteColor]];
        
        // Another way to set the background color
        let header =  view as! UITableViewHeaderFooterView
        header.textLabel?.font =  UIFont.boldSystemFont(ofSize: 15.0)
        header.textLabel?.textColor =  LDAHeaderBlueTextColor

        
    }
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let strTitle = "YourTitle"
        let attString = NSAttributedString(string: strTitle, attributes: [NSForegroundColorAttributeName : UIColor.white])
        return attString
    }
    var DayPerWeekSec = Section("First Week  Info")
    var StudentSec = Section("Students ID")

    var minDay:TimeInterval?
    var dateRowArray = [DateTimeRow]()
    var studentRowArray = [IntRow]()
    

    func updateDayPerWeekSec(totalLine:Int)
    {
        print(DayPerWeekSec.count)
        
        
        if DayPerWeekSec.count < totalLine
        {
            var i  =  DayPerWeekSec.count
            
            while i < totalLine
            {
                
                
                let daterow =  DateTimeRow()
                    {
                        
                        $0.value = Date(); $0.title = "DateRow"
                        
                        $0.tag = "Day in Week" + String(i)
                        $0.cell.tag = i
                        if i  == 0
                        {
                            $0.title = "Start Day"
                            self.minDay = Date().timeIntervalSince1970
                        }
                        else
                        {
                         //   $0.minimumDate = Date(timeIntervalSince1970: self.minDay!)
                           // $0.maximumDate = Date(timeIntervalSince1970: self.minDay! + 86400 * 7)
                        }

                        
                    }.cellUpdate { cell, row in
                        cell.backgroundColor = UIColor.clear
                        cell.textLabel?.textColor = self.LDASubHeaderOrgangeTextcolor
                                                cell.textLabel?.font  = UIFont.boldSystemFont(ofSize: 14)
                        //cell.textField.textColor = UIColor.white
                        
                        if !cell.isFirstResponder
                        {
                            if cell.tag == 0
                            {
                                
                                self.minDay = row.value?.timeIntervalSince1970
                               // self.DayPerWeekSec.reload()
                                
                                for item in self.dateRowArray
                                {
                                    if item.cell.tag != 0
                                    {
                                        item.minimumDate = Date(timeIntervalSince1970: self.minDay!)
                                        item.maximumDate = Date(timeIntervalSince1970: self.minDay! + 86400 * 7)
                                    }
                                    else
                                    {
                                        
                                    }

                                }
                            }

                        }
                        
                }
                i += 1
                dateRowArray.append(daterow)
                DayPerWeekSec <<< daterow
                
            
            }
            
            
        }
        else
        {
            while DayPerWeekSec.count > totalLine
            {
                DayPerWeekSec.removeLast()
                dateRowArray.removeLast()
            }
        }
        DayPerWeekSec.reload()
        
    }
    
    
    func updateStudentInClass(totalLine:Int)
    {
        print(StudentSec.count)
        
        
        if StudentSec.count < totalLine
        {
            var i  =  StudentSec.count
            
            while i < totalLine
            {
                
                
                let studentRow =  IntRow()
                {
                    
                    $0.title = "Student : "
                    $0.tag = "StudentID" + String(i)
                    $0.cell.tag = i
                    $0.placeholder = "type student id"
                    $0.placeholderColor = UIColor.gray

                    if i  == 0
                    {
                        self.minDay = Date().timeIntervalSince1970
                    }
                    
                    
                    }.cellSetup { cell, _  in
                        cell.textField.keyboardType = .numberPad
                    }.cellUpdate { cell, row in
                        cell.backgroundColor = UIColor.clear
                        cell.textLabel?.textColor = self.LDASubHeaderOrgangeTextcolor
                        cell.textLabel?.font  = UIFont.boldSystemFont(ofSize: 14)
                        //cell.textField.textColor = UIColor.white
                        
                        
                        
                        
                        cell.backgroundColor = UIColor.clear
                        cell.textLabel?.textColor = self.LDASubHeaderOrgangeTextcolor
                        
                        cell.textField.textColor = self.LDASubHeaderOrgangeTextcolor
                        cell.textLabel?.font  = UIFont.boldSystemFont(ofSize: 14)
                        cell.textField.font =  UIFont.boldSystemFont(ofSize: 14)
                        
                        print(cell.textField.text)
                        cell.textField.text =  cell.textField.text?.elimateStringinSet(arr: [","])
                        if cell.textField.text != nil && cell.textField.text != ""
                        {
                            
                            
                            let string  = cell.textField.text?.elimateStringinSet(arr: [","])
                            print(string)
                            FirebaseLDACAUserAPI.shareInstance.getUserWithID(string!, completion: { (arr) in
                                
                                DispatchQueue.main.async {
                                    if arr.first?.role == UserRole.student.rawValue
                                    {
                                        cell.textLabel?.textColor = UIColor.green
                                        
                                        cell.textField.textColor = UIColor.green
                                    }
                                    else
                                    {
                                        cell.textLabel?.textColor = self.LDASubHeaderOrgangeTextcolor
                                        
                                        cell.textField.textColor = self.LDASubHeaderOrgangeTextcolor
                                        
                                    }
                                }
                            })
                            
                            
                            
                        }
                        else
                        {
                            DispatchQueue.main.async {
                                
                                
                                cell.textLabel?.textColor = self.LDASubHeaderOrgangeTextcolor
                                
                                cell.textField.textColor = self.LDASubHeaderOrgangeTextcolor
                                
                            }
                            
                        }

                        
                        
                }
                i += 1
                studentRowArray.append(studentRow)
                StudentSec <<< studentRow
                
                
            }
            
            
        }
        else
        {
            while StudentSec.count > totalLine
            {
                StudentSec.removeLast()
                studentRowArray.removeLast()
            }
        }
        StudentSec.reload()
        
    }

    func setupForm()
    {
        /*
         form = Section("Section1")
         <<< TextRow(){ row in
         row.title = "Text Row"
         row.placeholder = "Enter text here"
         }
         <<< PhoneRow(){
         $0.title = "Phone Row"
         $0.placeholder = "And numbers here"
         }
         +++ Section("Section2")
         <<< DateRow(){
         $0.title = "Date Row"
         $0.value = NSDate(timeIntervalSinceReferenceDate: 0) as Date
         }
         */
        //   let bgimageView = UIImageView(image: UIImage(named: "saigon-1024x614.jpeg"))
        let bgimageView = UIImageView(image: UIImage(named: "background.jpg"))
        
        bgimageView.contentMode = .scaleAspectFill
        bgimageView.frame = CGRect(x: 0, y: 0, width: EnglishSocietyConfigurateVaribles.SharedInstance.Screenwidth, height: EnglishSocietyConfigurateVaribles.SharedInstance.ScreenSize.height)
        tableView?.backgroundColor = UIColor.white
        self.view.addSubview(bgimageView)
        self.view.sendSubview(toBack: bgimageView)
        
        
    
        
        

        form =
            
            form +++ Section("Class Info")
            <<< NameRow() {
                $0.title =  "Class Name"
                $0.placeholder = "Enter Class Name Please"
                $0.tag = "ClassName"
                
                $0.placeholderColor = UIColor.gray
                }.cellUpdate { cell, row in
                    
                    cell.backgroundColor = UIColor.clear
                    cell.textLabel?.textColor = self.LDASubHeaderOrgangeTextcolor

                    cell.textField.textColor = self.LDASubHeaderOrgangeTextcolor
                    cell.textLabel?.font  = UIFont.boldSystemFont(ofSize: 14)
                    cell.textField.font =  UIFont.boldSystemFont(ofSize: 14)

                    
            }
            <<< IntRow(){ row in
                row.title = "Teacher ID"
                row.placeholder = "Enter Teacher Code"
                row.tag = "ClassTeacherID"
                row.placeholderColor = UIColor.gray

                }.cellSetup { cell, _  in
                    cell.textField.keyboardType = .numberPad
                }.cellUpdate { cell, row in
                    cell.backgroundColor = UIColor.clear
                    cell.textLabel?.textColor = self.LDASubHeaderOrgangeTextcolor
                    
                    cell.textField.textColor = self.LDASubHeaderOrgangeTextcolor
                    cell.textLabel?.font  = UIFont.boldSystemFont(ofSize: 14)
                    cell.textField.font =  UIFont.boldSystemFont(ofSize: 14)
                    
                    
                    
                    if cell.textField.text != nil && cell.textField.text != ""
                    {
                     
                        FirebaseLDACAUserAPI.shareInstance.getUserWithID(cell.textField.text!, completion: { (arr) in
                            
                                        DispatchQueue.main.async {
                             if arr.first?.role == UserRole.teacher.rawValue
                                {
                                    cell.textLabel?.textColor = UIColor.green
                                    
                                    cell.textField.textColor = UIColor.green
                                }
                            else
                             {
                                cell.textLabel?.textColor = self.LDASubHeaderOrgangeTextcolor
                                
                                cell.textField.textColor = self.LDASubHeaderOrgangeTextcolor
                                
                                            }
                            }
                        })
                        

                        
                    }
                    else
                    {
                        DispatchQueue.main.async {

                        
                        cell.textLabel?.textColor = self.LDASubHeaderOrgangeTextcolor
                        
                        cell.textField.textColor = self.LDASubHeaderOrgangeTextcolor
                        
                        }

                    }
            }
            <<< NameRow() {
                $0.title =  "Room"
                $0.placeholder = "Which room"
                $0.tag = "RoomCode"
                
                $0.placeholderColor = UIColor.gray
                }.cellUpdate { cell, row in
                    cell.backgroundColor = UIColor.clear
                    cell.textLabel?.textColor = self.LDASubHeaderOrgangeTextcolor

                    cell.textField.textColor = self.LDASubHeaderOrgangeTextcolor

                    cell.textLabel?.font  = UIFont.boldSystemFont(ofSize: 14)
                    cell.textField.font =  UIFont.boldSystemFont(ofSize: 14)
                    

                    
            }
            
            
            +++ Section("Week Info")
            <<< IntRow() {
                $0.title = "Weeks"
                $0.placeholder = "How Many Week"
                $0.placeholderColor =  UIColor.gray
                $0.tag = "Week"
                
                }.cellSetup { cell, _  in
                    cell.textField.keyboardType = .numberPad
                }                .cellUpdate { cell, row in
                    cell.backgroundColor = UIColor.clear
                    cell.textLabel?.textColor = UIColor.white
                    //  cell.textField.textColor = UIColor.gray
                    
                }.cellUpdate { cell, row in
                    cell.backgroundColor = UIColor.clear
                    cell.textLabel?.textColor = self.LDASubHeaderOrgangeTextcolor

                    cell.textField.textColor = self.LDASubHeaderOrgangeTextcolor
                    cell.textLabel?.font  = UIFont.boldSystemFont(ofSize: 14)
                    cell.textField.font =  UIFont.boldSystemFont(ofSize: 14)
                    

                    
                    
                    
                    
            }
            
            
            

            <<< IntRow() {
                $0.title = "Days a Week"
                $0.placeholder = "How Many Day for a Week ?"
                $0.placeholderColor =  UIColor.gray
                $0.tag = "DayAWeek"
                
                }.cellSetup { cell, _  in
                    cell.textField.keyboardType = .numberPad
                }                .cellUpdate { cell, row in
                    
                }.cellUpdate { cell, row in
                    cell.backgroundColor = UIColor.clear
                    cell.textLabel?.textColor = self.LDASubHeaderOrgangeTextcolor

                    cell.textField.textColor = self.LDASubHeaderOrgangeTextcolor
                    cell.textLabel?.font  = UIFont.boldSystemFont(ofSize: 14)
                    cell.textField.font =  UIFont.boldSystemFont(ofSize: 14)
                    
                    
                    
                    
                        if cell.textField.text != nil && cell.textField.text != ""
                        {
                            
                            
                            if Int(cell.textField.text!)! <= 7
                            {
                                if  Int(cell.textField.text!)! != self.dateRowArray.count {
                            
                                
                                    self.updateDayPerWeekSec(totalLine: Int(cell.textField.text!)!)
                                }
                            }
                     
                            else{
                                LDAActionResultHandler.sharedInstance.handleAction(title: "Days in week must be less then or equal to 7", returnCase: .fail)
                                
                                cell.textField.text = "7"
                                
                            }
                    
                    }
                    
                    
            }
            
            <<< IntRow() {
                $0.title = "Student Number"
                $0.placeholder = "How many Student"
                $0.placeholderColor =  UIColor.gray
                $0.tag = "Students"
                
                }.cellSetup { cell, _  in
                    cell.textField.keyboardType = .numberPad
                }                .cellUpdate { cell, row in
                    
                }.cellUpdate { cell, row in
                    cell.backgroundColor = UIColor.clear
                    cell.textLabel?.textColor = self.LDASubHeaderOrgangeTextcolor
                    
                    cell.textField.textColor = self.LDASubHeaderOrgangeTextcolor
                    cell.textLabel?.font  = UIFont.boldSystemFont(ofSize: 14)
                    cell.textField.font =  UIFont.boldSystemFont(ofSize: 14)
                    
                    
                    
                    
                    if cell.textField.text != nil && cell.textField.text != ""
                    {
                        
                        
                        if Int(cell.textField.text!)! <= 40
                        {
                            if  Int(cell.textField.text!)! != self.studentRowArray.count {
                                
                                self.updateStudentInClass(totalLine: Int(cell.textField.text!)!)
                       
                            }
                        }
                            
                        else{
                            LDAActionResultHandler.sharedInstance.handleAction(title: "Days in week must be less then or equal to 40", returnCase: .fail)
                            
                            cell.textField.text = "40"
                            
                        }
                        
                    }
                    
                    
            }


   

            
            
            
        
            
            
            //    self.form += [self.DayPerWeekSec]
            +++ self.DayPerWeekSec
            +++ self.StudentSec
            +++ Section("Finish")
            <<< ButtonRow()
                {
                    $0.title = "Finish"
                    
                    $0.baseCell.backgroundColor = self.LDASubHeaderOrgangeTextcolor
                    $0.baseCell.textLabel?.textColor = UIColor.white

                    $0.baseCell.tintColor = UIColor.white

                    
                    
                }.onCellSelection { cell, row in
                    
                  
                    
                    
                    let classcourse = LDACAClass(registerForm: self.form)
                    
                    self.checkClass(classcourse: classcourse)
                    if !classcourse.IsNill()
                    {
                    let enddate = classcourse.calculateEndDay()
                        print(enddate.convertToLocalDate())
                        print(enddate.localTime)
                        print(Date(timeIntervalSince1970: enddate.convertToLocalDate()))
                        
                        
                        // Prepare the popup assets
                        let title = "Successfully Create Class"
                        
                       let startDay =  Date(timeIntervalSince1970: classcourse.classDaysArray.first!).localTime
                        
                        let message = "Check your Info \nStartDay :" + startDay + "\nWeeks : " + "\(classcourse.classWeekDuration) \n" + "End Day : " + enddate.localTime
                        
                        //+  "\n"
                        let popup = PopupDialog(title: title, message: message, image: nil)
                        
                        
                        // Create third button
                        let okButton = DefaultButton(title: "Thanks") {
                            
                            FirebaseClassAPI.sharedInstance.updateClassCourse(classcourse, completion: { (success) in
                                
                                if success
                                {
                                    LDAActionResultHandler.sharedInstance.handleAction(title : "Successfully performed task")
                                    
                                }else
                                {
                                    
                                }
                                
                                
                            })
                        }
                        
                        // Add buttons to dialog
                        popup.addButtons([okButton])
                        
                        // Present dialog
                        self.present(popup, animated: true, completion: nil)
                        //self.present(popup, animated: animated, completion: nil)

                    }
                    
                    
                    /*
                     firebase.auth().onAuthStateChanged(function(user) {
                     if (user) {
                     // User is signed in.
                     } else {
                     // No user is signed in.
                     }
                     });
                     
                     */
                    
                    
                }
                .cellUpdate { cell, row in
                    cell.textLabel?.text = "FINISH"
                    cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15.0)
                    
            }
            +++ Section("EXIT")
            <<< ButtonRow()
                {
                    $0.title = "EXIT"
                    
                    $0.baseCell.backgroundColor = EnglishSocietyConfigurateVaribles.SharedInstance.ESGymRed
                    $0.baseCell.textLabel?.textColor = UIColor.white
                    $0.baseCell.tintColor = UIColor.white
                    $0.baseCell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15.0)
                    
                }.onCellSelection { cell, row in
                    
                    self.performSegueToReturnBack()
                  //  self.dismiss(animated: true, completion: nil)
                    //check if registration form is validate
        }
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        self.view.backgroundColor = UIColor.clear
        
        
        
        
        
        
    }
    func checkClass(classcourse:LDACAClass)
    {
        if classcourse.classTeacherID == nil
        {
            var murmur = Murmur(title: "Teacher ID is not validated")
            murmur.titleColor = UIColor.white
            murmur.font = UIFont.systemFont(ofSize: 15.0)
            murmur.backgroundColor = EnglishSocietyConfigurateVaribles.SharedInstance.ESGymRed
            // Show and hide a message after delay
            Whisper.show(whistle: murmur, action: .show(0.5))
            
            // Present a permanent status bar message
            Whisper.show(whistle: murmur, action: .present)
            
            // Hide a message
            Whisper.hide(whistleAfter: 3)
            
            
        }

    }
    
    
    
}
