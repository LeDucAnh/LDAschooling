//
//  MainTableViewController.swift
//
// Copyright (c) 21/12/15. Ramotion Inc. (http://ramotion.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit
import ObjectiveC
import UserNotifications
import UserNotificationsUI

// Swift
import UserNotifications
class LDAClassTableViewController: LDASearchTableViewController ,UNUserNotificationCenterDelegate{
    /*
     var SearchBar = UISearchBar()
     
     
     @IBAction func LDACAClassVCSearchButtonDidTouch(_ sender: Any) {
     
     SearchBar.frame = CGRect(x: 0, y: 30, width: 320, height: 100)
     
     self.view.addSubview(SearchBar)
     self.view.bringSubview(toFront: SearchBar)
     
     }
     */
    //static var sharedInstance = UIStoryboard(name: "MeaningTableViewStoryboard", bundle: nil).instantiateViewController(withIdentifier: "MainTableViewController") as! MeaningTableViewController
    
    let kCloseCellHeight: CGFloat = 100
    let kOpenCellHeight: CGFloat = 300.0
    
    let kRowsCount = 10
    
    var cellHeights = [CGFloat]()
    var currentExploringWord:String?
    static var sharedInstance = LDAClassTableViewController()
    // var meaningVC :  LDAClassTableViewController?
    //action handle
    
    let requestIdentifier = "SampleRequest" //identifier is to cancel the notification request
    
   // var LDACAclassArray = [LDACAClass]()
    @IBAction func ComposeButtonDidTouch(_ sender: Any) {
        
        
        
        self.performSegue(withIdentifier: "pushToClassCreateVC", sender: nil)
        
    }
    
    
    func titleText()
    {
        let label =  UILabel(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        label.text = self.currentExploringWord
        self.view.addSubview(label)
    }
    override func viewWillAppear(_ animated: Bool) {
        LDAUIHelpers.sharedInstance.setupVCforLDA(vc: self)
        //  LDAKeyboardHanlder.shareInstance.register(viewController: self)
        
        
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print("Tapped in notification")
    }
    
    //This is key callback to present notification while the app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        print("Notification being triggered")
        //You can either present alert ,sound or increase badge while the app is in foreground too with ios 10
        //to distinguish between notifications
        if notification.request.identifier == requestIdentifier{
            
            completionHandler( [.alert,.sound,.badge])
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleText()
        
        // let notificationSettings: UIUserNotificationSettings! = UIApplication.shared.currentUserNotificationSettings
        
        
        
        let center = UNUserNotificationCenter.current()
        
        let options: UNAuthorizationOptions = [.alert, .sound];
        center.requestAuthorization(options: options) {
            (granted, error) in
            if !granted {
                print("Something went wrong")
            }
        }
        
        // Swift
        center.getNotificationSettings { (settings) in
            if settings.authorizationStatus != .authorized {
                // Notifications not allowed
            }
        }
        
        
        createCellHeightsArray()
        self.tableView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        
        //  self.view.layer.cornerRadius = 8.0
        // self.view.layer.masksToBounds = true
        
        // self.view.backgroundColor =     UIColor.white
        //self.view.backgroundColor = UIColor.wh
        // timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: Selector("doSomething"), userInfo: nil, repeats: false)
        
        self.tableView.backgroundColor  = UIColor.clear
        
        
        self.registerFirebase()
        
        
    }
    override func sortData()
    {
        self.modelArr =   self.modelArr.sorted(by: { ($0 as! LDACAClass).timestamp! > ($1 as! LDACAClass).timestamp! })
    }
    
    
    
    override func loadMoreData()
    {
        
        FirebaseClassAPI.sharedInstance.getLastedObjects(self.modelArr.last! as! LDACAClass, { (arr) in
            for res in arr
            {
                
                for item in self.modelArr
                {
                    
                    print((item as! LDACAClass).parent)
                    if (item as! LDACAClass).parent ==  (res as! LDACAClass).parent
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
            
            self.handleAddMoreData(arr)
            
            
        })
        
        
    }
    
    override func registerFirebase()
    {
        FirebaseClassAPI.sharedInstance.registerForClassChange
            {(classes)in
                
                
                
                let LDACAclassArray =  self.modelArr as! [LDACAClass]
                
                
                
                if let index =  LDACAclassArray.index(of: LDACAclassArray.first(where: { $0.parent == classes.first?.parent })!)
                    
                {
                    self.triggerNotification()
                    self.modelArr[index] = classes.first!
                    
                    self.tableView.reloadData()
                }
                //  self.
                //questionImageObjects.first(where: { $0.imageUUID == imageUUID })
                
        }
        
        
        
        
        //  NVActivityIndicatorView(frame: <#T##CGRect#>, type: <#T##NVActivityIndicatorType?#>, color: <#T##UIColor?#>, padding: <#T##CGFloat?#>)
        //NVActivityIndicatorView(frame: frame, type: type, color: color, padding: padding)
        
        
        self.applyIndicator()
        self.startIndicator()
        FirebaseClassAPI.sharedInstance.registerForAddedClass { (classes) in
            
            self.stopAnimating()
            DispatchQueue.main.async {
                self.handleAddMoreData(classes)
                
                self.isLoadingFirstTime = false
            }
            
            
            
        }
        
    }
    var waitingIndicator : NVActivityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 30, height: 30).returnCenterForSelf(), type: NVActivityIndicatorType.ballPulseSync, color: EnglishSocietyConfigurateVaribles.SharedInstance.ESGymRed, padding: 0)
    func applyIndicator()
    {
        self.view.addSubview(self.waitingIndicator)
        
    }
    func startIndicator()
    {
        
        
        waitingIndicator.startAnimating()
        
    }
    func stopAnimating()
    {
        
        waitingIndicator.stopAnimating()
        
    }
    func triggerNotification(){
        
        print("notification will be triggered in five seconds..Hold on tight")
        let content = UNMutableNotificationContent()
        content.title = "Intro to Notifications"
        content.subtitle = "Lets code,Talk is cheap"
        content.body = "Sample code from WWDC"
        content.sound = UNNotificationSound.default()
        
        //To Present image in notification
        if let path = Bundle.main.path(forResource: "teacher", ofType: "png") {
            let url = URL(fileURLWithPath: path)
            
            do {
                let attachment = try UNNotificationAttachment(identifier: "sampleImage", url: url, options: nil)
                content.attachments = [attachment]
            } catch {
                print("attachment not found.")
            }
        }
        
        // Deliver the notification in five seconds.
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 5.0, repeats: false)
        let request = UNNotificationRequest(identifier:requestIdentifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().add(request){(error) in
            
            if (error != nil){
                
                print(error?.localizedDescription)
            }
        }
    }
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        
        guard case let cell as classCell = cell else {
            return
        }
        
        cell.backgroundColor = UIColor.clear
        
        if cellHeights[(indexPath as NSIndexPath).row] == kCloseCellHeight {
            cell.selectedAnimation(false, animated: false, completion:nil)
        } else {
            cell.selectedAnimation(true, animated: false, completion: nil)
        }
        
        cell.number = indexPath.row
        
        super.tableView(tableView, willDisplay: cell, forRowAt: indexPath)
        
        
    }

    /*
     
     
     override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
     
     super.tableView(tableView, willDisplay: cell, forRowAt: indexPath)
     guard case let cell as classCell = cell else {
     return
     }
     
     cell.backgroundColor = UIColor.clear
     
     if cellHeights[(indexPath as NSIndexPath).row] == kCloseCellHeight {
     cell.selectedAnimation(false, animated: false, completion:nil)
     } else {
     cell.selectedAnimation(true, animated: false, completion: nil)
     }
     
     cell.number = indexPath.row
     
     
     if self.FinishLoadToEnd ==  false
     {
     if indexPath.row == self.LDACAclassArray.count - 1
     {
     
     if isLoadingFirstTime ==  false
     {
     FirebaseClassAPI.sharedInstance.getLastedObjects(self.LDACAclassArray.last!, { (arr) in
     for res in arr
     {
     if self.LDACAclassArray.contains(res)
     {
     
     self.FinishLoadToEnd =  true
     }
     
     }
     if arr.count == 0
     {
     self.FinishLoadToEnd =  true
     }
     
     self.handleAddMoreData(arr)
     
     
     })
     }
     /*
     FirebasePostAPI.shareInstance.GetPostWithSingleEvent(self.ESTopicPostsArray.last!, completion: { (post) in
     
     for res in post
     {
     if self.ESTopicPostsArray.contains(res)
     {
     
     self.FinishLoadToEnd =  true
     }
     
     }
     if post.count == 0
     {
     self.FinishLoadToEnd =  true
     }
     
     self.handleAddMoreData(post)
     
     })
     */
     
     
     }
     }
     
     }
     
     
     
     */
    
    
    
    // MARK: configure
    func createCellHeightsArray() {
        for _ in 0...kRowsCount {
            cellHeights.append(kCloseCellHeight)
        }
    }
    
    
    
    var CellTappedReturnAction:((_ cell:LDACAClass)->Void)!
    
    
    func registerForCellTapped(action:@escaping (_ cell:LDACAClass)->Void)
    {
        self.CellTappedReturnAction = action
    }
    
    override func setupCell(cell: UITableViewCell,indexPath:IndexPath) {
        
        
        let classModel =  modelArr[indexPath.row] as! LDACAClass
        (cell as! classCell).setWithClassDataModel(classModel: classModel)
        
        cell.layoutIfNeeded()
        print(cell.frame)
        
        (cell as! classCell).registerDetailTappedCallBackAction {
            print("got tap")
            
            self.CellTappedReturnAction(classModel)
            
            
        }
        
    }
    /*
     // MARK: - Table view data source
     override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     
     return LDACAclassArray.count
     
     
     return 10
     }
     
     
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "FoldingCell", for: indexPath) as! classCell
     
     
     
     let classModel =  LDACAclassArray[indexPath.row] as! LDACAClass
     cell.setWithClassDataModel(classModel: classModel)
     // cell.setDataFromTranlateObject(translateObject:  self.MeaningTableVCTranslateObj!, cellIndex: indexPath.row)
     cell.layoutIfNeeded()
     print(cell.frame)
     
     cell.registerDetailTappedCallBackAction {
     print("got tap")
     
     self.CellTappedReturnAction(classModel)
     
     
     }
     cell.backgroundColor = UIColor.clear
     return cell
     }
     
     */
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        /*
         let cell =  tableView.cellForRow(at: indexPath) as! MeaningCell
         
         if cell.MeaningCell_FrontWordDefinitionLabel != nil
         {
         return  EnglishSocietyVCShareFunctions.SharedInstance.heightForView(cell.MeaningCell_FrontWordDefinitionLabel.text!, font: cell.MeaningCell_FrontWordDefinitionLabel.font, width: cell.MeaningCell_FrontWordDefinitionLabel.frame.width)
         
         }
         */
        return (self.cellHeights[(indexPath as NSIndexPath).row])
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print(modelArr as! [LDACAClass])
        return modelArr.count
        
        
        return 10
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoldingCell", for: indexPath) as! classCell
        
        
        let classModel =  modelArr[indexPath.row] as! LDACAClass
        cell.setWithClassDataModel(classModel: classModel)
        // cell.setDataFromTranlateObject(translateObject:  self.MeaningTableVCTranslateObj!, cellIndex: indexPath.row)
        cell.layoutIfNeeded()
        print(cell.frame)
        
        cell.registerDetailTappedCallBackAction {
            print("got tap")
            
            self.CellTappedReturnAction(classModel)
            
            
        }
        cell.backgroundColor = UIColor.clear
        return cell
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! FoldingCell
        
        
        if cell.isAnimating() {
            return
        }
        
        
        
        
        
        var duration = 0.0
        if cellHeights[(indexPath as NSIndexPath).row] == kCloseCellHeight { // open cell
            cellHeights[(indexPath as NSIndexPath).row] = CGFloat(kOpenCellHeight)
            cell.setBackViewHeight(newHeight: CGFloat(kOpenCellHeight))
            
            
            
            
            
            let cellx =  tableView.cellForRow(at: indexPath) as! classCell
            
            if cellx.MeaningCell_FrontWordDefinitionLabel != nil
            {
                var height = LDATextHelpers.sharedInstance.heightForView(cellx.MeaningCellBackWorDefinitionLabel.text!, font: cellx.MeaningCellBackWorDefinitionLabel.font, width: cellx.MeaningCellBackWorDefinitionLabel.frame.width)
                
                height += LDATextHelpers.sharedInstance.heightForView(cellx.MeaningCellBackWordSynonymLabel.text!, font: cellx.MeaningCellBackWordSynonymLabel.font, width: cellx.MeaningCellBackWordSynonymLabel.frame.width)
                
                height += LDATextHelpers.sharedInstance.heightForView(cellx.MeaningCellBackWordExampleLabel.text!, font: cellx.MeaningCellBackWordExampleLabel.font, width: cellx.MeaningCellBackWordExampleLabel.frame.width)
                
                
                print(height)
                //default is 120
                cellHeights[(indexPath as NSIndexPath).row] = CGFloat(135 + height)
                cell.setBackViewHeight(newHeight: CGFloat(135 + height))
            }
            
            
            
            
            cell.selectedAnimation(true, animated: true, completion: nil)
            duration = 0.5
        } else {// close cell
            cellHeights[(indexPath as NSIndexPath).row] = kCloseCellHeight
            
            cell.selectedAnimation(false, animated: true, completion: nil)
            cell.setBackViewHeight(newHeight: kCloseCellHeight)
            duration = 0.8
        }
        
        /*
         var duration = 0.0
         if cellHeights[(indexPath as NSIndexPath).row] == kCloseCellHeight { // open cell
         cellHeights[(indexPath as NSIndexPath).row] = CGFloat(self.kOpenCellHeight)
         cell.setBackViewHeight(newHeight: CGFloat(self.kOpenCellHeight))
         
         cell.selectedAnimation(true, animated: true, completion: nil)
         duration = 0.5
         } else {// close cell
         cellHeights[(indexPath as NSIndexPath).row] = kCloseCellHeight
         cell.setBackViewHeight(newHeight: kCloseCellHeight)
         cell.selectedAnimation(false, animated: true, completion: nil)
         
         duration = 0.8
         }
         */
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { () -> Void in
            tableView.beginUpdates()
            tableView.endUpdates()
        }, completion: nil)
        
        
    }
    // MARK: Table vie delegate
    
    
}
/*
 protocol UIExtensionDelegateScrollViewDelegate:UIScrollViewDelegate
 {
 func scrollToBottom(_ scrollView: UIScrollView)
 
 func scrollViewDidReachLimitBound(_ scrollView: UIScrollView)
 
 
 }
 
 class UIExtensionDelegateScrollView:UIScrollView,UIScrollViewDelegate
 
 {
 var timer = Timer()
 
 public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
 
 
 self.delegate?.scrollViewWillBeginDragging!(self)
 if (self.contentOffset.y == 0)
 {
 
 
 if self.timer != nil
 {
 self.timer.invalidate()
 }
 //  ESAnimation.shareInstance.fadeOutToAlpha(self.view, toAlpha: 0.5, withDuration: 1)
 
 timer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(self.aupdate), userInfo: nil, repeats: false)
 
 RunLoop.main.add(timer, forMode: RunLoopMode.commonModes)
 }
 
 }
 public func scrollViewDidScroll(_ scrollView: UIScrollView) {
 self.delegate?.scrollViewDidScroll!(scrollView)
 /*
 if scrollView.contentOffset.y >= 0 && self.view.alpha != 0
 {
 
 //     ESAnimation.shareInstance.fadeIn(self.view, withDuration: 0.2)
 }
 */
 
 print(scrollView.contentOffset.y)
 print(-scrollView.contentSize.height)
 if scrollView.contentOffset.y < -150
 {
 self.timer.invalidate()
 
 //    ESAnimation.shareInstance.fadeOut(self.view, withDuration: 0.02)
 (self.delegate as! UIExtensionDelegateScrollViewDelegate).scrollViewDidReachLimitBound(self)
 
 }
 
 
 }
 
 func aupdate()
 {
 if self.contentOffset.y < -10
 
 {
 // ESAnimation.shareInstance.fadeOut(self.view, withDuration: 0.02)
 }
 else
 {
 
 (self.delegate as! UIExtensionDelegateScrollViewDelegate).scrollViewDidReachLimitBound(self)
 
 
 // ESAnimation.shareInstance.fadeIn(self.view, withDuration: 0.2)
 }
 
 
 }
 
 
 
 }
 */
