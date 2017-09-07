//
//  LDACAImportVC.swift
//  LDAContactApp
//
//  Created by Mac on 4/13/17.
//  Copyright © 2017 LeDucAnh. All rights reserved.
//

import UIKit
import Eureka

class LDACAAdminAddUserForm:FormViewController
{
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
    }
    init(offsizeToScreen:CGFloat) {
        
        super.init(nibName: nil, bundle: nil)
        print(self.view.frame)
        
        
      let width =   EnglishSocietyConfigurateVaribles.SharedInstance.ScreenSize.width - offsizeToScreen
        

                self.setupForm()
        print(self.view.frame)
        self.view.frame = CGRect(x: 0, y: 0, width:   width, height: width)
        self.view.layoutIfNeeded()
        self.view.layoutSubviews()

        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var LDAHeaderBlueTextColor = UIColor.init(colorLiteralRed: 47/255, green: 150/255, blue: 245/255, alpha: 1)
    
    var LDASubHeaderOrgangeTextcolor = UIColor.init(colorLiteralRed: 250/255, green: 150/255, blue: 42/255, alpha: 1)

    func setupForm()
    {
        
        form =
            
            form +++ Section("User Info")
            <<< NameRow() {
                $0.title =  "First Name"
                $0.placeholder = "Enter Class Name Please"
                $0.tag = "FirstName"
                
                $0.placeholderColor = UIColor.gray
                }.cellUpdate { cell, row in
                    
                    cell.backgroundColor = UIColor.clear
                    cell.textLabel?.textColor = self.LDASubHeaderOrgangeTextcolor
                    
                    cell.textField.textColor = self.LDASubHeaderOrgangeTextcolor
                    cell.textLabel?.font  = UIFont.boldSystemFont(ofSize: 14)
                    cell.textField.font =  UIFont.boldSystemFont(ofSize: 14)
                    
                    
            }
            <<< NameRow() {
                $0.title =  "Last Name"
                $0.placeholder = "Enter Last/Middle Name Please"
                $0.tag = "LastName"
                
                $0.placeholderColor = UIColor.gray
                }.cellUpdate { cell, row in
                    
                    cell.backgroundColor = UIColor.clear
                    cell.textLabel?.textColor = self.LDASubHeaderOrgangeTextcolor
                    
                    cell.textField.textColor = self.LDASubHeaderOrgangeTextcolor
                    cell.textLabel?.font  = UIFont.boldSystemFont(ofSize: 14)
                    cell.textField.font =  UIFont.boldSystemFont(ofSize: 14)
                    
                    
            }

            /*
            <<< IntRow(){ row in
                row.title = "Role ID"
                row.placeholder = "student(1),teacher(2),staff(3),admin(4)"
                row.tag = "RoleID"
                row.placeholderColor = UIColor.gray
                
                }.cellSetup { cell, _  in
                    cell.textField.keyboardType = .numberPad
                }.cellUpdate { cell, row in
                    cell.backgroundColor = UIColor.clear
                    cell.textLabel?.textColor = self.LDASubHeaderOrgangeTextcolor
                    
                    cell.textField.textColor = self.LDASubHeaderOrgangeTextcolor
                    cell.textLabel?.font  = UIFont.boldSystemFont(ofSize: 14)
                    cell.textField.font =  UIFont.boldSystemFont(ofSize: 14)
                        
                        

            }
    
 */
            <<< IntRow(){ row in
                row.title = "User ID"
                row.placeholder = "Enter User ID"
                row.tag = "UserID"
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
                                if arr.count  == 0
                                {
                                    
                                    LDAActionResultHandler.sharedInstance.handleAction(title: "This ID is good to go", returnCase: LDAActionResultHandlerType.success)
                                    cell.textLabel?.textColor = UIColor.green
                                    
                                    cell.textField.textColor = UIColor.green
                                }
                                else
                                {
                                    
                                    LDAActionResultHandler.sharedInstance.handleAction(title: "There is a user With this id", returnCase: LDAActionResultHandlerType.fail)
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
            <<<  DateTimeRow()
                {
                    
                    $0.value = Date(); $0.title = "Birth Day"
                    $0.tag = "BirthDay"

                    
                    
                }.cellUpdate { cell, row in
                    cell.backgroundColor = UIColor.clear
                    cell.textLabel?.textColor = self.LDASubHeaderOrgangeTextcolor
                    cell.textLabel?.font  = UIFont.boldSystemFont(ofSize: 14)
                    //cell.textField.textColor = UIColor.white
                    
                    
            }
            
            +++ Section("Role picker")
            
            /*
            <<< PickerRow<String>("Picker Row") { (row : PickerRow<String>) -> Void in
                
                row.options = []
                for i in 1...10{
                    row.options.append("option \(i)")
                }
            }
            
             */
            <<< PickerInputRow<String>("Picker Input Row"){
                $0.title = "Pick a Role"
                
                $0.tag = "RolePicker"
            
                $0.options = []
                for i in 1...3{
                    if i == 1
                    {
                        $0.options.append("Student \(i)")

                    }
                    if i == 2
                    {
                        $0.options.append("Teacher \(i)")
                        
                    }
                    if i == 3
                    {
                        $0.options.append("Staff \(i)")
                        
                    }

                }
                $0.value = $0.options.first
            }

            
            +++ Section("Finish")
            <<< ButtonRow()
                {
                    $0.title = "Finish"
                    
                    $0.baseCell.backgroundColor = self.LDASubHeaderOrgangeTextcolor
                    $0.baseCell.textLabel?.textColor = UIColor.white
                    
                    $0.baseCell.tintColor = UIColor.white
                    
                    
                    
                }.onCellSelection { cell, row in
                    
                    let user  =  LDACAUser(registerForm: self.form)
                    FirebaseLDACAUserAPI.shareInstance.updateLDACAUser(user, completion: { (Bool) in
                        if Bool ==  true
                        {
                            LDAActionResultHandler.sharedInstance.handleAction(title: "Successfully created user", returnCase: LDAActionResultHandlerType.success)
                        }
                        else
                        {
                            
                            LDAActionResultHandler.sharedInstance.handleAction(title: "Fail to created user", returnCase: LDAActionResultHandlerType.fail)
                            
                        }
                        
                    })


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
                    
                    self.dismiss(animated: true, completion: nil)
                    //  self.dismiss(animated: true, completion: nil)
                    //check if registration form is validate
            }
        

        

 
        

    }
}


class LDACAAdminViewController: UIViewController,LDAOptionButtonViewDelegate {
    @IBOutlet weak var AdminVCAdduserUsingExcelFile: LDAOptionButtonView!

    @IBOutlet weak var AdminVCMangeUserButton: LDAOptionButtonView!
    @IBOutlet weak var AdminVCStudentToClassButton: LDAOptionButtonView!
    @IBOutlet weak var AdminVCStudentButton: LDAOptionButtonView!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.tabBarController?.tabBar.barTintColor = UIColor.white
        
    }
    func LDAOptionButtonViewDidTouch(sender:LDAOptionButtonView)
    {
        
        //righthere
        
        if sender == AdminVCMangeUserButton
        {
            self.performSegue(withIdentifier: "toMangeUesrVC", sender: nil)
            
        }
        
        if sender == AdminVCStudentButton
        {
            
            /*     
             
             let importAlertView = SCLAlertView()
             let urlTextField = importAlertView.addTextField("URL :")
             urlTextField.text  = "https://drive.google.com/file/d/0B-GGRDa6SAXUS0xnVkNSVkRBZzA/view?usp=sharing"
             urlTextField.text  = "https://firebasestorage.googleapis.com/v0/b/contactapp-fd758.appspot.com/o/import.xlsx?alt=media&token=62e42027-9675-4d70-961a-e28a9a9c8285"
             
             */
            // Create a custom view controller
            
            

            
            let importVC = LDACAAdminAddUserForm(offsizeToScreen: 20)
            // Create the dialog
          
            self.present(importVC, animated: true, completion: nil)

            
            importVC.view.frame =  CGRect(x: 0, y: 0, width: 300 , height: 300)
            print(importVC.view.frame)

            
            
            
            
            
            
        }
        if sender == AdminVCAdduserUsingExcelFile
        {
            //user import
                        let importVC2 = LDACAImportViewController(nibName: "LDACAImportViewController", bundle: nil)
            
            
            
                let popup = PopupDialog(viewController: importVC2, buttonAlignment: .horizontal, transitionStyle: .bounceDown, gestureDismissal: true)
                
                print(popup.viewController.view.frame)
                print(popup.view.frame)
                // Create first button
                let buttonOne = CancelButton(title: "CANCEL", height: 45) {
                    //   self.label.text = "You canceled the rating dialog"
                }
                
                // Create second button
                let buttonTwo = DefaultButton(title: "Submit", height: 45) {
                    //  https://www.dropbox.com/s/rlp3mmhx4jqgz8r/Untitled%20spreadsheet.xlsx?dl=1
                    
                    
                    //https://drive.google.com/file/d/0B-GGRDa6SAXUUkNUZS0tQ0QtdGM/view?usp=sharing
                    //https://drive.google.com/file/d/0B-GGRDa6SAXUUkNUZS0tQ0QtdGM/view?usp=sharing
                    //https://drive.google.com/open?id=0B-GGRDa6SAXUUkNUZS0tQ0QtdGM
                    //let importLocalPath: String = Bundle.main.path(forResource: "import", ofType: "xlsx")!
                    let importLocalPath: String =  Bundle.main.bundlePath + "/import.xlsx"
                    
                    
                    
                    //this one is add user to app
                    // "https://www.dropbox.com/s/snl2zwx18k70g34/teacher.xlsx?dl=1"
                    
                    if let url =  URL(string: importVC2.LDACADownloadURLTextField.text!)
                    {

                Downloader.load(url: url, to: URL(fileURLWithPath: importLocalPath), completion: {
                        
                        

                    
                     let spreadsheet: BRAOfficeDocumentPackage = BRAOfficeDocumentPackage.open(importLocalPath)
                     let sheet: BRASheet = spreadsheet.workbook.sheets[0] as! BRASheet
                     let worksheet: BRAWorksheet = spreadsheet.workbook.worksheets[0] as! BRAWorksheet
                     var cell: BRACell = worksheet.cell(forCellReference: "A1")
                     
                     print(cell.floatValue())
                     let total = Int(cell.floatValue()) + 2
                     
                     var index = 3
                     
                    
                     while   index <= total
                     {
                     let model =  LDACAUser(Worksheet: worksheet, index: index)
                     index += 1
                     FirebaseLDACAUserAPI.shareInstance.updateLDACAUser(model, completion: { (Bool) in
                     
                     
                     })
                     
                     }
 
                        })
                    }
                    
                    
                    
                    
                    
                }
                
                // Add buttons to dialog
                popup.addButtons([buttonOne, buttonTwo])
                
                // Present dialog
                self.present(popup, animated: true, completion: nil)
            importVC2.LDACAStructureImageView.image = UIImage(named: "userimportdes")


        }
        if sender == AdminVCStudentToClassButton
        {
            
            //student import 
            /*
            let vc = LDACAImportViewController(nibName: "LDACAImportViewController", bundle: nil)
            
            let popup = PopupDialog(viewController: vc, buttonAlignment: .horizontal, transitionStyle: .bounceDown, gestureDismissal: true, completion: nil)
            let submitButton = DefaultButton(title: "Thanks") {
                
            }
            let cancelButton = CancelButton(title: "Close", action: { 
            
                
                
            })
            popup.addButtons([submitButton,cancelButton])
            self.present(popup, animated: true, completion: nil)
            */
            
            // Create a custom view controller
            let importVC = LDACAImportViewController(nibName: "LDACAImportViewController", bundle: nil)
            
            // Create the dialog
            let popup = PopupDialog(viewController: importVC, buttonAlignment: .horizontal, transitionStyle: .bounceDown, gestureDismissal: true)
            
            
            // Create first button
            let buttonOne = CancelButton(title: "CANCEL", height: 45) {
             //   self.label.text = "You canceled the rating dialog"
            }
            
            // Create second button
            let buttonTwo = DefaultButton(title: "Submit", height: 45) {
                //this is the link
                
                //  https://www.dropbox.com/s/rlp3mmhx4jqgz8r/Untitled%20spreadsheet.xlsx?dl=1
                
                
                
               
                let importLocalPath: String =  Bundle.main.bundlePath + "/import1.xlsx"
                
                
                if let url =  URL(string: importVC.LDACADownloadURLTextField.text!)
                {
                    Downloader.load(url: url, to: URL(fileURLWithPath: importLocalPath), completion: {
                       
                        
                      
                    let spreadsheet: BRAOfficeDocumentPackage = BRAOfficeDocumentPackage.open(importLocalPath)
                        let sheet: BRASheet = spreadsheet.workbook.sheets[0] as! BRASheet
                        let worksheet: BRAWorksheet = spreadsheet.workbook.worksheets[0] as! BRAWorksheet

                        
                            FirebaseClassAPI.sharedInstance.uploaadClassStudentAndTeacherFromExcell(sheet: worksheet)
 

                    
                    })
                }
            
            }
            
            // Add buttons to dialog
            popup.addButtons([buttonOne, buttonTwo])
            
            // Present dialog
            self.present(popup, animated: true, completion: nil)
            importVC.LDACAStructureImageView.image = UIImage(named: "studentclassimportdes")

        }
        
        
    }
    
    func handleStudentButtonTapped()
    {
    }
    override func viewDidAppear(_ animated: Bool) {
     
        
        

    }
    override func viewDidLoad() {
        super.viewDidLoad()
                self.AdminVCStudentToClassButton.delegate =  self
        self.AdminVCStudentButton.delegate =  self
        self.AdminVCMangeUserButton.delegate = self
        self.AdminVCAdduserUsingExcelFile.delegate =  self
        
        AdminVCStudentButton.imageView.image = UIImage(named: "userCreate")
        AdminVCMangeUserButton.imageView.image = UIImage(named: "userGroup")
        AdminVCStudentToClassButton.imageView.image = UIImage(named: "userExcel")
        
        
        AdminVCAdduserUsingExcelFile.imageView.image = UIImage(named: "userExcel")
        
        // self.meaningVC.tableView.delegate
    }
}
extension String {
    
    func slice(from: String, to: String) -> String? {
        
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                substring(with: substringFrom..<substringTo)
            }
        }
    }
}
struct GoogleDriveValidateStringElement
{
    var startStr:String
    var endStr:String
    init(start: String, end: String) {
       
    
        self.startStr = start
        self.endStr = end
    }
    

}
class GoogleDriveImportHelper {
    
    
   static var prefix = "https://drive.google.com/uc?id="
    static var suffix = "&export=download"
    static var googleDownloadURL:String = "https://drive.google.com/uc?id=GOOGLEDOWNLOADURLID&export=download"
  static var googleReplaceElementArr = [GoogleDriveValidateStringElement(start: "https://drive.google.com/file/d/", end: "/view?usp=sharing"),GoogleDriveValidateStringElement(start: "https://drive.google.com/open?id=", end: ""),GoogleDriveValidateStringElement(start: "https://docs.google.com/spreadsheets/d/", end: "edit?usp=sharing")]
    class func fortmatGoogleDriveString( string:String)->String
    {
        
        if string.contains("https://drive.google.com/uc?id=") && string.contains("&export=download")
        {
            
            return string
        }
        
        var id = "nil"
        
        
        
        //findid
        for item in self.googleReplaceElementArr
        {
            
            
            
            if string.contains(item.startStr) &&  string.contains(item.endStr)
            {
            id = string.slice(from: item.startStr, to: item.endStr)!

            if id != nil{
                //found the id 
                break
            }
            }
             if string.contains(item.startStr)
             {
                id = string.replacingOccurrences(of: item.startStr, with: "")
            }
            if string.contains(item.endStr)
            {
                id = string.replacingOccurrences(of: item.endStr, with: "")
            }
          
        }
        
        
    
        
        return googleDownloadURL.replacingOccurrences(of: "GOOGLEDOWNLOADURLID", with: id)
    }

}
class Downloader {
    static var sharedInstance = Downloader()
    
    class func load(url: URL, to localUrl: URL, completion: @escaping () -> ()) {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        let request = try! URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData)
        
        let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
            if let tempLocalUrl = tempLocalUrl, error == nil {
                // Success
                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    print("Success: \(statusCode)")
                }
                
                do {
                    
                   do
                    {
                    try FileManager.default.removeItem(at: localUrl)
                    }
                   catch{
                    print("file exist then replace")
                    }
                    
                    try FileManager.default.copyItem(at: tempLocalUrl, to: localUrl)
                    completion()
                } catch (let writeError) {
                    print("error writing file \(localUrl) : \(writeError)")
                }
                
            } else {
                print("Failure: %@", error?.localizedDescription);
            }
        }
        task.resume()
    }
}

