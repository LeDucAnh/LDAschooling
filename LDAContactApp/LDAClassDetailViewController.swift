//
//  LDACalssDetailViewController.swift
//  LDAContactApp
//
//  Created by Mac on 4/25/17.
//  Copyright © 2017 LeDucAnh. All rights reserved.
//

import UIKit

public enum LDAClassDetailFunctionViewOptions : Int
{    case calendar

    case student
    case notification
    case request
}
class LDAClassDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    /// Tells the delegate that the JTAppleCalendar is about to display
    /// a date-cell. This is the point of customization for your date cells
    /// - Parameters:
    ///     - calendar: The JTAppleCalendar view giving this information.
    ///     - date: The date attached to the cell.
    ///     - cellState: The month the date-cell belongs to.
    ///     - indexPath: use this value when dequeing cells
    @IBOutlet weak var LDAClassDetailControlView: UIView!
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell =  calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "calendarCell", for: indexPath) as! LDACalendarCollectionViewCell
        //  cell.backgroundColor = EnglishSocietyConfigurateVaribles.SharedInstance.ESGymOrange
        // cell.layer.cornerRadius = 8.0
        //cell.layer.masksToBounds = true
        
        
        for checkdate in self.classDayArr
        {
            if  Calendar.current.isDate(checkdate, inSameDayAs:date)
            {
            cell.calendarDateLabel.textColor = UIColor.white
                cell.calendarSelectedView.isHidden = false

            }
        }
        
        
        
        cell.calendarDateLabel.text = cellState.text
        
        
        
                return cell
    }
    @IBOutlet weak var optionbutton: UIButton!

    let selectedMonthColor = UIColor.white
    let outsideMonthColor = UIColor(rgb: 0x584a66)
    
    var classmodel:LDACAClass?
    var classDayArr = [Date]()
    let formatter = DateFormatter()
    var currentDisplayView : UIView?
    
    var  optionView : LDAHorizontalScrollOptionView?
    @IBOutlet weak var classAttendancesTableView: UITableView!
    let classAttendancesSearchViewController = LDASearchTableViewControllerView()
    let searchbar = UISearchBar()
    
    @IBOutlet weak var classCalendar: LDAShowOnlyCalendarView!
    var classNotificationVC = LDACAClassNotificationViewController()
    
    var classRequestVC  :LDACARequestTableViewController!
    
    var classStudentArr = [LDACAUser]()
    var classStudentidStringArr = [Int]()
    var classStudentidStringOriginalArr = [Int]()
    
    
    
    
    func setupReturnAction()
    {
        classNotificationVC.registercellReturnAction { (DIYTableViewCell,actionType,value) in
            
            if actionType.rawValue == DIYTableViewCellActionReturnType.DetailButtonTapped.rawValue
            {
                let detailVC = LDACANotificationDetailViewController()
                detailVC.notification = DIYTableViewCell.currentPost
                self.present(detailVC, animated: false, completion: nil)
                


            }
            if actionType.rawValue == DIYTableViewCellActionReturnType.URLWebViewTapped.rawValue
            {
                
                
                
                let webVC = SwiftModalWebVC(urlString: value["url"] as! String, theme: .dark)
                //webVC.webViewDelegate =  self
                self.present(webVC, animated: false, completion: nil)
                webVC.webViewDelegate.registerFordidSelectaWord(callbackAction: { (word) in
                    
                    
                    ESVocabularyOptionView.sharedInstante.show(word: word)
                    
                })


            }

            
        }

    }
        override func viewDidLoad() {
        super.viewDidLoad()
            
            self.view.layoutIfNeeded()
            
            self.view.layoutSubviews()
            


            //tableViewSetup
            
            self.currentDisplayView = self.classCalendar
            self.classNotificationVC.view.frame = self.classCalendar.frame
            print(self.classNotificationVC.view.frame)
            print(self.classCalendar.frame)
            self.classNotificationVC.view.isHidden = true
            self.view.addSubview(self.classNotificationVC.view)
            
            self.classNotificationVC.zyThumbnailTableVC.refreshView()
            
            
            classRequestVC = LDACARequestTableViewController(classmodel : self.classmodel!)
            
            self.classRequestVC.view.frame = self.classCalendar.frame
            self.classRequestVC.view.isHidden = true
            self.view.addSubview(self.classRequestVC.view)
           
            
            
            self.classAttendancesTableView.register(LDAUserIDTableViewCell.self, forCellReuseIdentifier: "Cell")
            
            self.classAttendancesTableView.register(UINib(nibName: "LDAUserIDTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
            var param1 = WCLShineParams()
            param1.bigShineColor = UIColor(rgb: (153,152,38))
            param1.smallShineColor = UIColor(rgb: (102,102,102))
            let height:CGFloat = 30.0
            
            /*
            let button = WCLShineButton(frame: .init(x: 0, y: 0 , width: height, height: height), params: param1)
            button.isSelected = true
            
            button.fillColor = UIColor(rgb: (153,152,38))
            button.color = UIColor(rgb: (170,170,170))
            
            
            button.addTarget(self, action: #selector(action), for: .touchUpInside)
            self.view.addSubview(button)
            
 */
            self.classAttendancesTableView.delegate =  self
            self.classAttendancesTableView.dataSource =  self
            
        
            self.classStudentidStringArr = (self.classmodel?.classStudentIDArr)!
            
            classStudentidStringArr.sort {
                return
                $0 < $1
            }
            
            self.classStudentidStringOriginalArr =  classStudentidStringArr
            
            self.setupOptionView()
            //self.classCalendar.frame = CGRect(x: 0, y: 40, width: EnglishSocietyConfigurateVaribles.SharedInstance.ScreenSize.width, height: EnglishSocietyConfigurateVaribles.SharedInstance.ScreenSize.width)
        // Do any additional setup after loading the view.
            
            
            

               // dataList = [LDACANotification]() as NSArray
                /*             */
                
            self.setupDatasource()
            self.setupReturnAction()
            self.setupBarButtons()
            
            
            LDAKeyboardHanlder.shareInstance.register(viewController: self, backgroundviews: [self.LDAClassDetailControlView])
            
            self.classAttendancesSearchViewController.registerSearchBarActionReturn { (searchString) in
                
                if searchString == ""
                {
                    //return to normal
                    
                    self.classStudentidStringArr =  self.classStudentidStringOriginalArr
                    
                }
                else
                {
                    //display search
               //     self.classStudentidStringOriginalArr
            
                    
                   self.classStudentidStringArr = self.classStudentidStringOriginalArr.filter(
                        {
                            String($0).contains(searchString)
                    })
                    
                    /*
                    if let i = self.classStudentidStringOriginalArr.index(where: { String($0).contains(searchString) }) {

                        self.classStudentidStringArr = [self.classStudentidStringOriginalArr[i]]
                        
                        
                    }else
                    {
                        self.classStudentidStringArr = []

                        
                    }
*/
                }
                self.classAttendancesTableView.reloadData()
            }
            

            
            self.classAttendancesTableView.removeFromSuperview()
            classAttendancesSearchViewController.setupWith(SearchBar: self.searchbar, tableView: self.classAttendancesTableView)
    
            self.view.addSubview(classAttendancesSearchViewController)
           // self.classAttendancesSearchViewController.frame =  self.classCalendar.frame
        self.classAttendancesSearchViewController.anchor(self.optionView?.bottomAnchor, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: -1, heightConstant: -1)
            
            self.view.layoutIfNeeded()
            
            self.view.layoutSubviews()
            
            
            
            self.setupCalendar()
            
            self.view.bringSubview(toFront: classCalendar)

            self.classAttendancesSearchViewController.isHidden =  true
            self.classRequestVC.view.isHidden =  true
            
            self.classNotificationVC.view.isHidden = true
            
            // self.animateWithLDAHorizontalScrollOptionCellTag(tag: 0)
            

    }
    func setupCalendar()
    {
        
        
        
        
        for scheduleDay in (self.classmodel?.generateDaysWithWeekDurationAndDaysInWeekArr())!
        
        {
            let date = Date(timeIntervalSince1970: scheduleDay)
            self.classDayArr.append(date)
        }
        
        
        
        
        classCalendar.DayArray = self.classDayArr
        self.classCalendar.calendarCollectionView.scrollToDate(classDayArr.first!)
        
        
        self.classCalendar.registerForDidSelectCellAction { (JTAppleCalendarView, Date, JTAppleCell, CellState) in
            
            
            var bool = false
            for item in self.classDayArr
            {
                if   Calendar.current.isDate(item, inSameDayAs: Date)
                {
                    bool = true
                    
                }
                
                
            }
            if bool == true
            {
                //good to go 
                let optionAlert = SCLAlertView()
                optionAlert.addButton("Absent")
                {
                    
                    let request = LDACAClassRequest()
                    request.dateTime = Date.timeIntervalSince1970
                            self.configureSendRequestForm(WithDate: Date)
                }
                optionAlert.showTitle("Request", subTitle: "Choose one request", style: .edit)
                


            }
        }
    }
    func configureSendRequestForm(WithDate:Date)
    {
        let sendVC = LDACAClassRequestSendFormViewController()
        
        let request = LDACAClassRequest()
        request.dateTime = WithDate.timeIntervalSince1970
      
        request.requestType = LDACAClassRequestType.absent.rawValue
        request.timestamp =  Int(Date().timeIntervalSince1970)
        request.fromID = String(Int((FirebaseAuthAPI.shareInstance.currentLDACAUSer?.roleID)!))
        
        
        sendVC.request = request

        
        let popup = PopupDialog(viewController: sendVC, buttonAlignment: .horizontal, transitionStyle: .bounceDown, gestureDismissal: true)
        // Create buttons
        let buttonTwo = DefaultButton(title: "Post Request!") {
            //seen
            
            
              request.content = sendVC.requestTextField.text!
//request.classID =  self.classmodel?.parent
            request.uploadToClass(classID: (self.classmodel?.parent)!, { (Bool) in
                if Bool
                {
                    LDAActionResultHandler.sharedInstance.handleAction(title : "uploaded Request")
                    
                    
                }
            })
        }

        let buttonOne = CancelButton(title: "CANCEL") {
            print("You canceled the car dialog.")
        }
        
        
        
        // Add buttons to dialog
        // Alternatively, you can use popup.addButton(buttonOne)
        // to add a single button
        popup.addButtons([buttonTwo,buttonOne])
        self.present(popup, animated: true, completion: nil)
        
        
    }
    func setupBarButtons()
    {
        self.optionbutton.setImage( UIImage(named: "options")?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.optionbutton.imageView?.tintColor = UIColor.green
       // self.BackButton.setImage(UIImage(named: "back")?.withRenderingMode(.alwaysTemplate), for: .normal)
       // self.BackButton.imageView?.tintColor = UIColor.white
        

    }
    func setupDatasource()
    {
        
     //   print(String(Int((FirebaseAuthAPI.shareInstance.currentLDACAUSer?.roleID)!)))
       // print ((classmodel?.parent)!)
        LDACANotification.registerNotiDataAdded(forUserID: (String(Int((FirebaseAuthAPI.shareInstance.currentLDACAUSer?.roleID)!))), ClassID: (classmodel?.parent)!, notiType: .ClassNotification) { (LDACANotification) in
            
            LDACANotification.belongtoClass =  self.classmodel
            self.classNotificationVC.addNewNoti(noti: LDACANotification)
        }
        
        LDACANotification.registerNotiDataChange(forUserID: (String(Int((FirebaseAuthAPI.shareInstance.currentLDACAUSer?.roleID)!))), ClassID: (classmodel?.parent)!, notiType: .ClassNotification) { (LDACANotification) in
            
            LDACANotification.belongtoClass =  self.classmodel
            self.classNotificationVC.updateNoti(noti: LDACANotification)
             
        }
        
 

        

       
        
    }
    override func viewDidAppear(_ animated: Bool) {
        
        self.optionView?.setSelectedAtIndex(index: 0)
   
    }
    func animateWithLDAHorizontalScrollOptionCellTag (tag:Int)
    {
        
        if LDAClassDetailFunctionViewOptions(rawValue: tag) == LDAClassDetailFunctionViewOptions.calendar
            
        {
            LDATransition.sharedInstance.scaleAnimation(fView: self.currentDisplayView!, sView: self.classCalendar, superView: self.view)
            
            
            self.currentDisplayView = self.classCalendar
            
        }
        if LDAClassDetailFunctionViewOptions(rawValue: tag) == LDAClassDetailFunctionViewOptions.student
            
            
        {
            LDATransition.sharedInstance.scaleAnimation(fView: self.currentDisplayView!, sView: self.classAttendancesSearchViewController, superView: self.view)
            
            self.currentDisplayView = self.classAttendancesSearchViewController
        }
        
        
        if LDAClassDetailFunctionViewOptions(rawValue: tag) == LDAClassDetailFunctionViewOptions.notification
            
            
        {
            
            
            print(String(describing: FirebaseAuthAPI.shareInstance.currentLDACAUSer?.roleID))
            LDATransition.sharedInstance.scaleAnimation(fView: self.currentDisplayView!, sView: self.classNotificationVC.view, superView: self.view)
            
            self.currentDisplayView = self.classNotificationVC.view
            
        }
        if LDAClassDetailFunctionViewOptions(rawValue: tag) == LDAClassDetailFunctionViewOptions.request
            
            
        {
            
            
            print(String(describing: FirebaseAuthAPI.shareInstance.currentLDACAUSer?.roleID))
            LDATransition.sharedInstance.scaleAnimation(fView: self.currentDisplayView!, sView: self.classRequestVC.view, superView: self.view)
            
            self.currentDisplayView = self.classRequestVC.view
            
        }


        
    }
    func setupOptionView()
    
    {
        
     optionView  = LDAHorizontalScrollOptionView(view, titleValues: ["Calendar","Students","Notifications","Request"], atYValue: 0, withHeight: 45, displayItem: 3)
        
        optionView?.translatesAutoresizingMaskIntoConstraints =  false
        self.classCalendar.translatesAutoresizingMaskIntoConstraints =  false
        
        var newConstraint = NSLayoutConstraint(item: self.LDAClassDetailControlView, attribute: .bottom,
                                               relatedBy: .equal, toItem: optionView, attribute: .top,
                                               multiplier: 1, constant: 2)
        
        
        
     //   newConstraint = NSLayoutConstraint(item: self.LDAClassDetailControlView, attribute: .height,
                                  //         relatedBy: .equal, toItem: LDAClassDetailControlView, attribute: .height,
                                    //       multiplier: 1, constant: 60)

        self.view.addConstraint(newConstraint)
        newConstraint = NSLayoutConstraint(item: optionView, attribute: .width,
                                           relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,
                                           multiplier: 1, constant: EnglishSocietyConfigurateVaribles.SharedInstance.ScreenSize.width)

        self.view.addConstraint(newConstraint)
        newConstraint = NSLayoutConstraint(item: optionView, attribute: .height,
                                           relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,
                                           multiplier: 1, constant: 45)
        self.view.addConstraint(newConstraint)
        newConstraint = NSLayoutConstraint(item: optionView, attribute: .bottom,
                                           relatedBy: .equal, toItem: self.classAttendancesTableView, attribute: .top,
                                           multiplier: 1, constant: 0)
        self.view.addConstraint(newConstraint)

        newConstraint = NSLayoutConstraint(item: optionView, attribute: .bottom,
                                           relatedBy: .equal, toItem: self.classCalendar, attribute: .top,
                                           multiplier: 1, constant: 0)
        self.view.addConstraint(newConstraint)
        
        
        
        
        
        self.classCalendar.backgroundColor = UIColor.brown

        self.view.layoutIfNeeded()
        
        
        
        print(optionView?.frame)
        print(self.LDAClassDetailControlView.frame)
        optionView?.backgroundColor = EnglishSocietyConfigurateVaribles.SharedInstance.ESBlue
        optionView?.textColor = UIColor.white
        optionView?.selectedColor = UIColor.black
        self.view.addSubview(optionView!)
        var i = 0
        optionView?.registerForCellSelected { (LDAHorizontalScrollOptionCell) in
            
            //closure handle
            self.animateWithLDAHorizontalScrollOptionCellTag(tag: LDAHorizontalScrollOptionCell.tag)
            
        }
        
        /*
        var view1 = UIView(frame: CGRect(x: 0, y: 200, width: 320, height: 200))
        
        
        var view2 = UIView(frame: CGRect(x: 0, y: 400, width: 320, height: 200))
        
        
        self.view.addSubview(view1)
        self.view.addSubview(view2)
        
        view1.backgroundColor = UIColor.gray
        view2.backgroundColor = UIColor.brown
        
        optionView.registerForCellSelected { (cell) in
            
            print(cell.tag)
            
            LDATransition.sharedInstance.scaleAnimation(fView: view2, sView: view2)
        }
        */

    }
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    //func student Tableview Datasource
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classStudentidStringArr.count
    }
    
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! LDAUserIDTableViewCell
        
        cell.UserIDTtileLabel.text = String(self.classStudentidStringArr[indexPath.row])
        cell.UserIDTtileLabel.textColor  = UIColor.white
        cell.UserIDTtileLabel?.backgroundColor = EnglishSocietyConfigurateVaribles.SharedInstance.randColor()
        
        
        let image  = UIImage(named: "forwardArrow.png")?.withRenderingMode(.alwaysTemplate)
        cell.UserDetailButton.setImage(image, for: .normal)
        cell.UserDetailButton.imageView?.tintColor = EnglishSocietyConfigurateVaribles.SharedInstance.ESGymRed
        cell.captureDetailButtontouchAction {
            
            
            self.pushtoChatVC(id: String(self.classStudentidStringArr[indexPath.row]))
            
            
            //do something in here
        }
 
        /*
        cell.textLabel?.text = String(self.classStudentidStringArr[indexPath.row])
        
        cell.textLabel?.translatesAutoresizingMaskIntoConstraints = true
        cell.textLabel?.frame.size = CGSize(width: cell.frame.size.height, height: cell.frame.size.height)
        cell.textLabel?.backgroundColor = EnglishSocietyConfigurateVaribles.SharedInstance.randColor()
        
 */
      //  cell.textLabel?.text = String(describing: self.classStudentArr[indexPath.row].studentID)
        return cell
    }
    /*
    @objc private func action() {
        print("点击")
        
       // ESAnimation.shareInstance.cloneViewToFrontAndBlurBackground(view: self.classCalendar, widthOffset: 0, height: self.classCalendar.frame.size.height - 4)
        
        
      
         ESAnimation.shareInstance.bringViewToFrontAndBlurBackground(view: self.classCalendar.view, widthOffset: 2, height: self.classCalendar.view.frame.size.height - 4)
  

    }
*/
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
func handleOptionControlButtonTapped()
{
    // Prepare the popup assets
    let title = "Options"
    let message = "What you want to perform"
    
    // Create the dialog
    let popup = PopupDialog(title: title, message: message)
    
    // Create buttons
    let buttonOne = CancelButton(title: "CANCEL") {
        print("You canceled the car dialog.")
    }
    
    let buttonTwo = DefaultButton(title: "Post notification") {
        //seen
        let uploadnotiVC = LDACAClassPostNotificationViewController()
        uploadnotiVC.view.backgroundColor = UIColor.white
        uploadnotiVC.viewerIDStringArr = self.classStudentidStringArr
        uploadnotiVC.classID = self.classmodel?.parent
        // uploadnotiVC.initAllSelectedID()
        self.present(uploadnotiVC, animated: true, completion: nil)
        
    }
    


    
    
    let buttonThree = DefaultButton(title: "Contact Teacher", height: 60) {
        
        
        
        self.pushtoChatVC(id: self.classmodel!.classTeacherID!.description)
        
    }
    
    
    
    // Add buttons to dialog
    // Alternatively, you can use popup.addButton(buttonOne)
    // to add a single button
    
    popup.addButtons([buttonOne, buttonTwo, buttonThree ])
    
    // Present dialog
    self.present(popup, animated: true, completion: nil)
    

    
    }
    func pushtoChatVC(id:String)
    {
        print(self.classmodel!.classTeacherID!.description)
        print(id)
        FirebaseLDACAUserAPI.shareInstance.getUserWithID((id), completion: { (array) in
            
            
            /*
             let storyboard = UIStoryboard(name: "Main", bundle: nil)
             let controller = storyboard.instantiateViewController(withIdentifier: "Chat") as! ChatVC
             controller.currentUser = array.first
             
             */
            let controller = LDACASingleChatViewController()
            controller.WithUser = array.first
            
            
            
            
            
            let ChatNavigationNavController = UINavigationController()
            
            ChatNavigationNavController.viewControllers = [controller]
            
            ChatNavigationNavController.setNavigationBarHidden(true, animated: false)
            
            self.present(ChatNavigationNavController, animated: true, completion: nil)
            
            
            
            
            
        })
        

    }
    @IBAction func classDetailAddButtonDidTap(_ sender: Any) {
        
        self.handleOptionControlButtonTapped()
        
    }
    @IBAction func classDetailVCCloseButtonDidTouch(_ sender: Any) {
        self.dismiss(animated: true , completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
