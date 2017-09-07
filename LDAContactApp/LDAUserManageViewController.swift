//
//  LDATeacherImportTableView.swift
//  LDAContactApp
//
//  Created by Mac on 4/21/17.
//  Copyright © 2017 LeDucAnh. All rights reserved.
//

import UIKit
public enum LDAUserMangeTableViewControllerActionType:Int
{
    case celltap
    case celldetail
}
class LDAUserMangeTableViewController: LDASearchTableViewController{
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
        self.modelArr =   self.modelArr.sorted(by: { ($0 as! Int) < ($1 as! Int) })
    }
    
    
    
    override func loadMoreData()
    {

        
    }
    
    override func registerFirebase()
    {
        /*
        FirebaseClassAPI.sharedInstance.registerForClassChange
            {(classes)in
         
         
         
                let LDACAclassArray =  self.modelArr as! [LDACAClass]
                
                
                
                if let index =  LDACAclassArray.index(of: LDACAclassArray.first(where: { $0.parent == classes.first?.parent })!)
                    
                {
                    self.modelArr[index] = classes.first!
                    
                    self.tableView.reloadData()
                }
                //  self.
                //questionImageObjects.first(where: { $0.imageUUID == imageUUID })
                
        }
        
        
        

        FirebaseClassAPI.sharedInstance.registerForAddedClass { (classes) in
            
            DispatchQueue.main.async {
                self.handleAddMoreData(classes)
                
                self.isLoadingFirstTime = false
            }
            
            
            
        }
 */
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        
        guard case let cell as LDAUserIDTableViewCell = cell else {
            return
        }
      
      
        
        super.tableView(tableView, willDisplay: cell, forRowAt: indexPath)
        
        cell.captureDetailButtontouchAction {
            
            
     //       self.CellDetailTapped(indexPath)
            
            
            
         //   self.CellReturnAction(indexPath,LDAUserMangeTableViewControllerActionType.celldetail)
           // self.pushtoChatVC(id: String(self.classStudentidStringArr[indexPath.row]))
            
            
            //do something in here
        }
    }
 
    
    
    
    var CellReturnAction:((_ cell:IndexPath,_ type:LDAUserMangeTableViewControllerActionType)->Void)!
    
    
    func registerForCell(action:@escaping (_ cell:IndexPath,_ type :LDAUserMangeTableViewControllerActionType)->Void)
    {
        self.CellReturnAction = action
    }
    
    override func setupCell(cell: UITableViewCell,indexPath:IndexPath) {
        
        /*
        
        let classModel =  modelArr[indexPath.row] as! LDACAClass
        (cell as! classCell).setWithClassDataModel(classModel: classModel)
        
        cell.layoutIfNeeded()
        print(cell.frame)
        
        (cell as! classCell).registerDetailTappedCallBackAction {
            print("got tap")
            
            self.CellTappedReturnAction(classModel)
            
            
        }
        
         */
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print(modelArr)
        return modelArr.count
        
        
        return 10
    }
     override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            as! LDAUserIDTableViewCell
        
        cell.UserIDTtileLabel?.text =   String(describing: modelArr[indexPath.row])
        
        
        cell.UserIDTtileLabel.textColor  = UIColor.white
        cell.UserIDTtileLabel?.backgroundColor = EnglishSocietyConfigurateVaribles.SharedInstance.randColor()
        
        
        let image  = UIImage(named: "forwardArrow.png")?.withRenderingMode(.alwaysTemplate)
        cell.UserDetailButton.setImage(image, for: .normal)
        cell.UserDetailButton.imageView?.tintColor = EnglishSocietyConfigurateVaribles.SharedInstance.ESGymRed
        cell.captureDetailButtontouchAction {
            
            self.CellReturnAction(indexPath,LDAUserMangeTableViewControllerActionType.celldetail)
            
         //   self.pushtoChatVC(id: String(self.modelArr[indexPath.row]))
            
        }
        
        
        return cell
        
        
        
    }
    //MARK : TABLEVIEW DELEGATE
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    self.CellReturnAction(indexPath,LDAUserMangeTableViewControllerActionType.celltap)
    
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
class LDAUserManageViewController: UIViewController{
    var searchBar = UISearchBar()
    var LDACAUserMangeVCModelsdict:Dictionary<String, Any> = [:]
    
     var LDAUserManagerTableViewController: LDAUserMangeTableViewController!
    var  optionView : LDAHorizontalScrollOptionView?
    
    var navView = LDACANavView()

    var currentSelectArr = [Int]()
    var searchControllerView = LDASearchTableViewControllerView()
    
    var isloadingData = false
    
        func loadMoreData()
    {
        
         isloadingData = true
        

        
        let lastobject  = LDACAUser()
        lastobject.roleID = Float(currentSelectArr.first!)
        FirebaseLDACAUserAPI.shareInstance.GetLastedUserWithSingleEventWithRoleID(lastobject, queryRole: UserRoleInString.UserRoleInstring(fromInt: currentSelectID)) { (arr) in
         

            
            for res in arr
            {
                
                for item in self.LDAUserManagerTableViewController.modelArr
                {
                    
                    
                    if (item as! Int) ==  res
                    {
                        self.LDAUserManagerTableViewController.FinishLoadToEnd =  true
                    }
                }
                
            }
            
            if arr.count == 0
            {
                self.LDAUserManagerTableViewController.FinishLoadToEnd =  true
            }
            
            
            if self.LDAUserManagerTableViewController.FinishLoadToEnd == false
            {
            self.LDAUserManagerTableViewController.handleAddMoreData(arr)
            }
            self.isloadingData = false
            
            

        }
        

    }
    override func viewWillDisappear(_ animated: Bool) {
        
        LDALoadingHanlder.SharedInstance.stopAnimating()
        

    }
    func showUserDialog(animated: Bool = true,userString:String) {
        
        LDALoadingHanlder.SharedInstance.startIndicator()
        
        FirebaseLDACAUserAPI.shareInstance.getUserWithID(userString, completion: { (arr) in
            
            DispatchQueue.main.async {
                let user  =  arr.first
                
                
                LDALoadingHanlder.SharedInstance.stopAnimating()
                
                // Prepare the popup assets
                
                let title =  "\(user!.firstName)!" + " \(user!.lastName) - \(String(Int((user!.roleID)!)))"
                let message = "Password : \(user!.password)"
                
                
                // Create the dialog
                let popup = PopupDialog(title: title, message: message)
                
                
                // Create third button
                let okButton = DefaultButton(title: "Thanks") {
                }
                
                // Add buttons to dialog
                popup.addButtons([okButton])
                
                // Present dialog
                self.present(popup, animated: animated, completion: nil)

                
            }
        })
        
            }

    override func viewDidLoad() {
    
    
        LDAKeyboardHanlder.shareInstance.register(viewController: self, backgroundviews: [self.view])
        
        self.navView.embedToView(view: self.view)
        self.navView.DoneButton.setTitle("", for: .normal)
        self.navView.backgroundColor = EnglishSocietyConfigurateVaribles.SharedInstance.ESGymRed
        self.navView.registerForReturnAction { (LDACANavViewReturnAction) in
            if LDACANavViewReturnAction == .exit
            {
              
                self.performSegueToReturnBack()
            }
            
        }
        self.setupOptionView()
        self.setupTableview()
        print(optionView?.frame)
    
    
        searchBar.placeholder = "Type Class Name"
        searchControllerView.registerSearchBarActionReturn { (textString) in
            
            print(textString)
            
            if textString != ""
                
            {
                self.LDAUserManagerTableViewController.setSearchMode(value: true)
                
                                self.LDAUserManagerTableViewController.modelArr =  self.currentSelectArr.filter(
                                    {
                                        String($0).contains(textString)
                                })
                
                /*
                FirebaseClassAPI.sharedInstance.searchClassWithNameValue(value: textString, { (classes) in
                    
                    self.LDAUserManagerTableViewController.modelArr = classes
                    self.LDAUserManagerTableViewController.tableView.reloadData()
                    
                })
                 */
            }
            else
            {
                
                self.LDAUserManagerTableViewController.setSearchMode(value: false)
              //  self.LDAUserManagerTableViewController.modelArr = self.originalClassArr
              
                self.LDAUserManagerTableViewController.modelArr =  self.currentSelectArr

                
                
            }
            self.LDAUserManagerTableViewController.tableView.reloadData()

        }
        
        self.LDAUserManagerTableViewController.registerForCell { (classCell) in
            
            
            self.performSegue(withIdentifier: "modalToClassDetailVC", sender: classCell)
        }
        self.LDAUserManagerTableViewController.registerHandleData { (arr) in
            
           // self.displayClassButton.setTitle("\(arr.count) classes", for: .normal)
            
            self.currentSelectArr =    self.LDAUserManagerTableViewController.modelArr as! [Int]
            self.LDACAUserMangeVCModelsdict[String(self.currentSelectID)]  = self.LDAUserManagerTableViewController.modelArr as! [Int]

            

            
           // self.originalClassArr =  self.tableViewClassController.modelArr as! [LDACAClass]
        }
        
        self.LDAUserManagerTableViewController.registerwillLoadMoreData {
            self.loadMoreData()
        }

        
    
        searchControllerView.setupWith(SearchBar: searchBar, tableView: LDAUserManagerTableViewController.tableView)
        
        self.searchControllerView.frame =  self.view.frame
        
        self.view.addSubview(self.searchControllerView)
        
        self.setupAnchor()
        
        
        self.LDAUserManagerTableViewController.registerForCell { (IndexPath, type) in
            
            if type.rawValue == LDAUserMangeTableViewControllerActionType.celldetail.rawValue
            {
                LDACASingleChatViewController.pushToChatVC(id: String(self.currentSelectArr[IndexPath.row]), vc: self)
                
            }
            if type.rawValue == LDAUserMangeTableViewControllerActionType.celltap.rawValue
            {
                
                
                self.showUserDialog(animated: true, userString:  String(self.currentSelectArr[IndexPath.row]))
              //  LDACASingleChatViewController.pushToChatVC(id: String(self.currentSelectArr[IndexPath.row]), vc: self)
                
            }
            
        }

        /*
    self.LDAUserManagerTableViewController.registerForCellDetailTapped { (IndexPath) in
        
         
        }
 */
        
        LDALoadingHanlder.SharedInstance.applyIndicator(toview: self.view)
    }
    
    
    
    
    
    func setupAnchor()
    {
        self.searchControllerView.anchor(self.optionView?.bottomAnchor, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: -1, heightConstant: -1)
        
        
        
        self.optionView?.anchor(self.navView.bottomAnchor, left: self.view.leftAnchor, bottom: self.searchControllerView.topAnchor, right: self.view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: -1, heightConstant: 40 )
        
        self.view.layoutSubviews()
    }
    func setupTableview()
    {
        
        
        self.LDAUserManagerTableViewController = LDAUserMangeTableViewController()
        
        
        
        self.LDAUserManagerTableViewController.tableView.register(LDAUserIDTableViewCell.self, forCellReuseIdentifier: "Cell")
        
        self.LDAUserManagerTableViewController.tableView.register(UINib(nibName: "LDAUserIDTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
      //  self.view.addSubview(self.LDAUserManagerTableView)

        
       // self.LDAUserManagerTableView.delegate =  self
        
       // self.LDAUserManagerTableView.dataSource =  self
        

    }
    override func viewDidAppear(_ animated: Bool) {
        optionView?.setSelectedAtIndex(index: 0)
        
         isloadingData = false

    }
    func setupOptionView()
        
    {
        
        optionView  = LDAHorizontalScrollOptionView(view, titleValues: ["Student","Teacher","Staff"], atYValue: 0, withHeight: 40, displayItem: 3)
        optionView?.backgroundColor = UIColor.gray
        self.view.addSubview(optionView!)
        

        optionView?.registerForCellSelected(action: { (LDAHorizontalScrollOptionCell) in
           
            
            print(LDAHorizontalScrollOptionCell.tag)
            
            if self.isloadingData == false
            {
            
            self.handleRoleViewSelected(tag: LDAHorizontalScrollOptionCell.tag)
            }
            else
            {
                LDAActionResultHandler.sharedInstance.handleAction(title: "Please wait until data is finisZ", returnCase: LDAActionResultHandlerType.fail)
            }
            
          
        })
        
    }

    
    var currentSelectID = -1
    func handleRoleViewSelected(tag:Int)
    {
        
         currentSelectID = tag + 1
        if let arr = self.LDACAUserMangeVCModelsdict[String(self.currentSelectID)] as? [Int]
        {
            
            currentSelectArr = arr
        }
        
        if self.LDACAUserMangeVCModelsdict[String(self.currentSelectID)]  == nil
        {
            
            
            isloadingData = true
            
            self.LDAUserManagerTableViewController.disableLoadMore()
        FirebaseLDACAUserAPI.shareInstance.GetLastedUserWithSingleEventWithRoleID(queryRole: UserRoleInString.UserRoleInstring(fromInt: currentSelectID)) { (items: [Int]) in
            
            self.LDACAUserMangeVCModelsdict[String(self.currentSelectID)] = items
            
            self.LDAUserManagerTableViewController.modelArr = items
            
            self.currentSelectArr = items
            
            self.LDAUserManagerTableViewController.tableView.reloadData()
            
            
            self.LDAUserManagerTableViewController.enableLoadMore()
            
            self.isloadingData = false
            
            
            }
        }
        else
        {
            
            
            self.LDAUserManagerTableViewController.modelArr = currentSelectArr
            self.LDAUserManagerTableViewController.tableView.reloadData()
            
            

        }
        

    }
    /*
    //MARK : TABLEVIEWDATASOURCE
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        
        
        if let arr = self.LDACAUserMangeVCModelsdict[String(self.currentSelectID)] as? [Int]
        {
            
            currentSelectArr = arr
            
            return arr.count
            //       return LDACAUserMangeVCModelsArr[(self.optionView?.currentOption)!].count
        }
        else
        {
            return 0
        }
    }
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
        
    }
    


    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        as! LDAUserIDTableViewCell
        
      cell.UserIDTtileLabel?.text =   String(currentSelectArr[indexPath.row])
        
        
        cell.UserIDTtileLabel.textColor  = UIColor.white
        cell.UserIDTtileLabel?.backgroundColor = EnglishSocietyConfigurateVaribles.SharedInstance.randColor()
        
        
        let image  = UIImage(named: "forwardArrow.png")?.withRenderingMode(.alwaysTemplate)
        cell.UserDetailButton.setImage(image, for: .normal)
        cell.UserDetailButton.imageView?.tintColor = EnglishSocietyConfigurateVaribles.SharedInstance.ESGymRed
        cell.captureDetailButtontouchAction {
            
            
            self.pushtoChatVC(id: String(self.currentSelectArr[indexPath.row]))
            
        }

        
        return cell
        
        
        
    }
        //MARK : TABLEVIEW DELEGATE
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
 */
    @IBAction func LDATeacherImportButtonDidTouch(_ sender: Any) {
    
        
      //
        
        
    
    
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
