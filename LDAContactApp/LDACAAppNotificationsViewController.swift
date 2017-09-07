//
//  LDACAAppNotificationsViewController.swift
//  LDAContactApp
//
//  Created by Mac on 6/15/17.
//  Copyright © 2017 LeDucAnh. All rights reserved.
//

import UIKit
public var UserRoleStringArray = ["none","student",
"teacher","staff","All"]

class LDACAAppNotificationsViewController :UIViewController
{
    
    var currentselectedRoleID  : Int!
    func resetDataSource ()
    {
        
        
        self.notificationVC.dataList.removeAllObjects()
        
self.notificationVC.zyThumbnailTableVC.reloadMainTableView()
         self.FinishLoadToEnd =  false
        self.readyToLoadMore = false

        
    }
    func reloadDataWithNew(role:Int)
    {
        
        self.resetDataSource()
        self.setupDataSourceWithRole(role: role)
        
    }
   // var currentRoleSelection =
    @IBAction func AppNotiRoleControlButtonDidTouch(_ sender: Any) {
       
        let optionAlert = SCLAlertView()
        optionAlert.addButton("Student ")
        {
            

            var ToRole = UserRoleNoti.student
            
            self.reloadDataWithNew(role:ToRole.rawValue + 1)
            
        }
        optionAlert.addButton("teacher ")
        {
            //2
            
                      var ToRole =  UserRoleNoti.teacher
            self.reloadDataWithNew(role:ToRole.rawValue + 1)

            
            
        }
        optionAlert.addButton("Staff ")
        {
            
            
            //3
            var ToRole =       UserRoleNoti.staff
            self.reloadDataWithNew(role:ToRole.rawValue + 1)

            
        }
        optionAlert.addButton("All ")
        {
            
            var ToRole = UserRoleNoti.allUser
            
            self.reloadDataWithNew(role:ToRole.rawValue + 1)

            //4
            
        }


        optionAlert.showTitle("Pick One", subTitle: "Choose one option to view notification", style: .info)


        
        
        self.reloadDada()
    }
    
    
    
    @IBOutlet weak var AppNotiRoleControlButton: UIButton!
    var notificationVC = LDACANotificationViewController()
    
    
    @IBAction func leftNavItemDidTouch(_ sender: Any) {
        self.reloadDada()
    }
    
    func notQualifiedRoleHandle()
    {
        
        
    }
    @IBAction func rightNavItemTapped(_ sender: Any) {
        
        
        if (FirebaseAuthAPI.shareInstance.currentLDACAUSer?.role)! < UserRole.staff.rawValue{
            
            LDAActionResultHandler.sharedInstance.notqualifiedRole(expectedRole: UserRole.staff.rawValue)
            return
        }
        
        
        let postNoti = LDACAAppNotificationPostViewController()
        
        
        postNoti.view.frame = CGRect(x: 0, y: 0, width: 300 , height: 300)
        print(postNoti.view.frame)
        
        let popup = PopupDialog(viewController: postNoti, buttonAlignment: .horizontal, transitionStyle: .bounceDown, gestureDismissal: true)
        
        popup.view.backgroundColor = UIColor.clear
        // Create first button
        
        
        let buttonOne = CancelButton(title: "CANCEL", height: 45) {
            //   self.label.text = "You canceled the rating dialog"
            
        }
        
        // Create second button
        let buttonTwo = DefaultButton(title: "Submit", height: 45) {
       
            
          var option =   postNoti.segmentedСontrol.selectedIndex
            let status = postNoti.PostNotiVC.inputTextField.text
            
    let noti = LDACANotification.init(type: .text, content: status, owner: .sender, timestamp: Int(Date().timeIntervalSince1970), isRead: false, classID: "")
            
            if postNoti.PostNotiVC.embedingURL != ""
            {
                noti.embedURL = postNoti.PostNotiVC.embedingURL
            }
            
      //      print(self.returnSelectValueFromCellStatusArr(statusArr: self.currentSelected, Arr: self.viewerIDStringArr))
            

        
            
            
            
            var ToRole = UserRoleNoti.student
          if option == 1
            {
             ToRole =    UserRoleNoti.teacher
            }
            if option == 2
            {
                ToRole =    UserRoleNoti.staff
            }

            
            if option == 3
            {
                ToRole =    UserRoleNoti.allUser
            }

            LDACANotification.sendApp(notification: noti, toRole: ToRole, withValues:  LDACANotification.composeNotificationWithNoti(notification: noti), completion: { (Bool,key) in
            
                
                if Bool{
                    
                    
                    
                    
                    
                    
                    
                    
                    //
                    if postNoti.PostNotiVC.uploadImage != nil
                    {
                        let thumbImageData = (UIImageJPEGRepresentation(postNoti.PostNotiVC.uploadImage!, 0.4)! as Data) as Data
                        FirebaseAPI.shareInstance.uploadPhotoFileToFirebase(thumbImageData, name: key, completion: { (downloadLink) in
                            
                            
                            noti.parent = key
                        
                            
                            noti.updateAppNotification(role: String(ToRole.rawValue), key: "photoURL",downloadLink, completion: {
                                (success) in
                                
                                if success
                                {
                                    LDAActionResultHandler.sharedInstance.handleAction(title: "Successfully upload photo", returnCase: .success)
                                }
                                else
                                {
                                    LDAActionResultHandler.sharedInstance.handleAction(title: "Fail to upload photo", returnCase: .fail)
                                }
                                
                            })
                            
                        })
                    }
                    if (postNoti.PostNotiVC.uploadvideoLocalURL != nil) && postNoti.PostNotiVC.uploadvideoLocalURL != ""
                    {
                        
                        FirebaseAPI.shareInstance.uploadVidFileFromLocal(postNoti.PostNotiVC.uploadvideoLocalURL!, name: key, completion: { (downloadlink) in
                            
                            
                            
                            noti.parent = key
                          
                            noti.updateAppNotification(role: String(ToRole.rawValue), key: "videoURL",downloadlink, completion: {
                                (success) in
                                
                                
                                if success
                                {
                                    
                                    LDAActionResultHandler.sharedInstance.handleAction(title: "Successfully upload video", returnCase: .success)
                                }
                                else{
                                    LDAActionResultHandler.sharedInstance.handleAction(title: "Fail to upload video", returnCase: .fail)
                                }
                                
                                
                                
                            })
                            
                            
                            
                        })
                        
                        
                        
                    }
                    
                    
                    LDAActionResultHandler.sharedInstance.handleAction(title: "Successfully update Notification")

                }
                else
                {
                    LDAActionResultHandler.sharedInstance.handleAction(title: "Fail to update Notification")

                }
        })
        
        }
        
        buttonOne.backgroundColor = UIColor.white
        buttonTwo.backgroundColor = UIColor.white
        popup.addButtons([buttonOne, buttonTwo])
        
        // Present dialog
        self.present(popup, animated: true, completion: nil)


        
    }
    
    
func handleMarkStatusreturnAction(_ notification: LDACANotification) {
    
        let post = notification
        //post.read = !post.read
        
        
        // Prepare the popup assets
        let title = "THIS IS THE DIALOG TITLE"
        let message = "This is the message section of the popup dialog default view"
        let image = UIImage(named: "pexels-photo-103290")
        
        // Create the dialog
        let popup = PopupDialog(title: title, message: message)
        
        // Create buttons
        let buttonOne = CancelButton(title: "CANCEL") {
            print("You canceled the car dialog.")
        }
        
        let buttonTwo = DefaultButton(title: "Pending") {
            //seen
            print("Ah, maybe next time :)")
            LDACANotification.updateRespondAction(roleID:self.currentselectedRoleID, forAppNoti: post, withAction: .seen) { (LDACANotification) in
                //
            }
            
        }
        
        let buttonThree = DefaultButton(title: "Decline", height: 60) {
            print("Ah, maybe next time :)")
            LDACANotification.updateRespondAction(roleID:self.currentselectedRoleID,forAppNoti: post, withAction: .Decline) { (LDACANotification) in
            }
            
        }
        let buttonFour = DefaultButton(title: "Accept", height: 60) {
            print("Ah, maybe next time :)")
            LDACANotification.updateRespondAction(roleID:self.currentselectedRoleID,forAppNoti: post, withAction: .Accept) { (LDACANotification) in
                
            }
            
        }
        
        
        // Add buttons to dialog
        // Alternatively, you can use popup.addButton(buttonOne)
        // to add a single button
        popup.addButtons([buttonOne, buttonTwo, buttonThree , buttonFour])
        
        // Present dialogaddnew
        self.present(popup, animated: true, completion: nil)
        
        
    }
    
    
        func addNewData(arr:[LDACANotification])
    {
        for notification in arr
        {
            
            self.notificationVC.addNewNoti(noti: notification)
        }
        setBadge()

        
    }
    
    func setBadge()
    {
        let tabItems = self.tabBarController?.tabBar.items as NSArray!
        
        // In this case we want to modify the badge number of the third tab:
        let tabItem = tabItems?[3] as! UITabBarItem
        
        // Now set the badge of the third tab
        tabItem.badgeValue = String(self.notificationVC.dataList.count)
    }
    override func viewDidLoad() {
        self.setupView()
        
       
        notificationVC.registertopViewDidClickShareBtn { (topview) in
            
            let indexPath = topview.indexPath
            
            
            let post = self.notificationVC.zyThumbnailTableVC.tableViewDataList[(indexPath?.row)!] as! LDACANotification
            
            
            
            post.deleteAppNotification(roleID: Int((self.currentselectedRoleID)!)) { (success) in
                if success
                {
                    LDAActionResultHandler.sharedInstance.handleAction(title: "Successfully delete object", returnCase: .success)
                    
                }
                else
                {
                    LDAActionResultHandler.sharedInstance.handleAction(title: "Fail to delete object", returnCase: .fail)
                    
                }
            }

        }
        notificationVC.registercellReturnAction { (DIYTableViewCell,actionType,value) in
            
            
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
        self.notificationVC.registerStatusButtonReturn { (noti) in
            
            self.handleMarkStatusreturnAction(noti)
        }
        
        
        self.notificationVC.zyThumbnailTableVC.willDisplayCellAction =
            {
            
            (_ indexPath: IndexPath) -> Void in
                if indexPath.row >=  self.notificationVC.dataList.count - 1
                {
                    if self.FinishLoadToEnd == false{
                        if self.readyToLoadMore ==  true
                        {
                        self.handleloadmoreData()
                       print("load more ")
                        }
                    }
                 
                }
                
        }

        

        
    }
    func handleloadmoreData()
    {
        let lastObject = self.notificationVC.dataList.lastObject as! LDACANotification
        
        
        LDACANotification.GetLastedAppNotificationWithSingleEvent(roleID: Int((self.currentselectedRoleID)!), lastObject, isInitialLoad: false, completion: { (arr) in
            
            for res in arr
            {
                
                
                
                for item in self.notificationVC.dataList
                {
                    
                    print((item as! LDACANotification).parent)
                    if (item as! LDACANotification).parent ==  (res as! LDACANotification).parent
                    {
                        self.FinishLoadToEnd =  true
                    }
                }
                
                /*
                 if self.modelArr.contains(res)
                 {
                 
                 
                 }
                 */
                
            }
            if arr.count == 0
            {
                self.FinishLoadToEnd =  true
            }
            if self.FinishLoadToEnd == false
            {
                self.addNewData(arr: arr)
                
                

            }
            
            
            
        })

    }
    override func viewDidAppear(_ animated: Bool) {
        
        self.setupDatasourceWithUserrole()

    }
    func reloadDada()
    {
        
        self.setupDatasourceWithUserrole()
        //------
        if  FirebaseAuthAPI.shareInstance.currentLDACAUSer != nil
        {
            
            if  FirebaseAuthAPI.shareInstance.currentUser != nil
            {
                /*
                LDACANotification.GetLastedAppNotificationWithSingleEvent( LDACANotification(), isInitialLoad: true) { (arr) in
                
                    
                    self.notificationVC.setNoti(noti: arr)
                    
                }
 */
            
            
            }

        }

    }
    var FinishLoadToEnd =  false
var readyToLoadMore = false
    func setupDataSourceWithRole(role:Int)
    {
        
        
        self.currentselectedRoleID = role
        let roletitle =     UserRoleStringArray[role]
        
        self.AppNotiRoleControlButton.setTitle(roletitle, for: .normal)

        if LDACANotification.registerAppNotiRef != nil
        {
            LDACANotification.registerAppNotiRef.removeAllObservers()
        }
        LDACANotification.setupAppnotiRef(roleID: role)
        LDACANotification.registerAppNotiDataAdded( roleID: role, completion: { (noti) in
            
            

            self.FinishLoadToEnd = false

            for item in self.notificationVC.dataList
            {
                
                print((item as! LDACANotification).parent)
                if (item as! LDACANotification).parent ==  (noti as! LDACANotification).parent
                {
                    self.FinishLoadToEnd =  true
                }
            }

            
            
            if self.FinishLoadToEnd == false
            {
            self.notificationVC.insertAtIndex(noti:noti,index:0)
            }
            self.readyToLoadMore =  true
            
            self.setBadge()
        })
        LDACANotification.registerAppNotiDataChange( roleID: role
            , completion: { (noti) in
                
                self.notificationVC.updateNoti(noti: noti)
                
        })

        
        
    }
    func setupDatasourceWithUserrole()
    {
        
       // print(String(Int((FirebaseAuthAPI.shareInstance.currentLDACAUSer?.roleID)!)))
      //  print ((classmodel?.parent)!)
       
        if FirebaseAuthAPI.shareInstance.currentLDACAUSer != nil
        {
        if  FirebaseAuthAPI.shareInstance.currentUser != nil
        {
            if self.notificationVC.dataList.count == 0
            {
                    self.setupDataSourceWithRole(role: Int((FirebaseAuthAPI.shareInstance.currentLDACAUSer?.role)!))
            
            }

            
            
            
            }
        }

        
        
        
    }

    func setupView()
    {
        
        self.view.addSubview(self.notificationVC.view)
        
        self.notificationVC.view.anchor(self.view.topAnchor, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, topConstant: 60, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: -1, heightConstant: -1)
    }
    
    //zyThumbnailTableVC.reloadMainTableView()
}

