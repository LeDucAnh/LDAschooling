//
//  LDASearchTableViewController.swift
//  LDAContactApp
//
//  Created by Mac on 6/20/17.
//  Copyright © 2017 LeDucAnh. All rights reserved.
//

import UIKit

class LDASearchTableViewController:UITableViewController{
    var modelArr = [Any]()
    var captureHandleDataAction : ((_ classes:[Any])->Void)!
    var FinishLoadToEnd:Bool = false
    
    
    
    var isLoadingFirstTime: Bool =  true
    func enableLoadMore()
    {
        self.isLoadingFirstTime = false
        self.FinishLoadToEnd =  false
    }
    func disableLoadMore()
    {
        self.isLoadingFirstTime = true
        self.FinishLoadToEnd =  true
        
    }
    
    
    func setSearchMode(value:Bool)
    {
        self.FinishLoadToEnd =  value
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate =  self
        
        
    }
    func registerHandleData(action:@escaping (_ classes:[Any])->Void)
    {
        
        captureHandleDataAction = action
    }
    
    func sortData()
    {
        
    }
    func handleAddMoreData(_ objects:[Any])
    {
        
        
        DispatchQueue.main.async {
            self.modelArr.append(contentsOf: objects)
            var newuserKeysArray = [String]()
            
            if objects.count > 1
            {
                self.sortData()
                
                // self.modelArr =   self.modelArr.sorted(by: { $0.timestamp! > $1.timestamp! })
            }
            
            self.captureHandleDataAction(self.modelArr)
            
            self.tableView.reloadData()
            
            
            
            
        }
        
        
    }
    
    func registerFirebase()
    {
        /*        FirebaseClassAPI.sharedInstance.registerForClassChange
         {(classes)in
         
         if let index =  self.LDACAclassArray.index(of: self.LDACAclassArray.first(where: { $0.parent == classes.first?.parent })!)
         
         {
         self.triggerNotification()
         self.LDACAclassArray[index] = classes.first!
         
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
         */
    }
    func loadMoreData()
    {
        /*
         FirebaseClassAPI.sharedInstance.getLastedObjects(self.modelArr.last!, { (arr) in
         for res in arr
         {
         if self.modelArr.contains(res)
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
         */
        
    }
    var willLoadMoreData:(()->Void)!
    
    func registerwillLoadMoreData(action:@escaping ()->Void)
        
    {
        self.willLoadMoreData = action
    }
    
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        
        
        if self.FinishLoadToEnd ==  false
        {
            if indexPath.row >= self.modelArr.count - 1
            {
                
                if isLoadingFirstTime ==  false
                {
                    if self.willLoadMoreData != nil
                    {
                        self.willLoadMoreData()
                    }
                    self.loadMoreData()
                }
                
                
                
            }
        }
        
    }
    
    
    
    
    
    func setupCell(cell:UITableViewCell,indexPath:IndexPath)
    {
        
        
    }
    
    
    
    
}



class LDASearchTableViewControllerView : UIView , UISearchBarDelegate{
    //must have a UITextField
    var SearchBar : UISearchBar?
    var tableView : UITableView?
    
    var SearchBarActionReturn : ((_ searchText:String)->Void)!
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) // called
    {
        
    }
    public func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        if searchBar ==  self.SearchBar
        {
            self.SearchBarActionReturn(searchBar.text!)
        }
        
    }
    
    func registerSearchBarActionReturn(action:@escaping (_ searchText:String)->Void)
    {
        self.SearchBarActionReturn = action
    }
    func setupWith(SearchBar:UISearchBar,tableView:UITableView)
    {
        
        
        //   if (tableView.conforms(to: LDASearchTableViewActionRegister.self))
        // {
        
        self.SearchBar = SearchBar
        self.tableView = tableView
        self.addSubview(self.SearchBar!)
        self.addSubview(self.tableView!)
        
        //     self.backgroundColor = UIColor.red
        //   self.searchField?.backgroundColor = UIColor.blue
        //  self.tableView?.backgroundColor = UIColor.gray
        
        
        SearchBar.delegate =  self
        self.setupAnchor()
        
        
        // }
        // else
        // {
        //  print("tableview \(tableView) does not conform to  LDASearchTableViewActionRegister Protocol")
        //}
        
    }
    private func setupAnchor()
    {
        
        
        if !self.subviews.contains(tableView!)
        {
            self.addSubview(tableView!)
        }
        let x =   SearchBar?.anchor(self.topAnchor, left: self.leftAnchor, bottom: self.tableView?.topAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: EnglishSocietyConfigurateVaribles.SharedInstance.ScreenSize.width, heightConstant: 45)
        let y =   self.tableView?.anchor(self.SearchBar?.bottomAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: -1, heightConstant: -1)
        
        
        self.layoutSubviews()
        self.layoutIfNeeded()
        
        print(SearchBar?.frame)
        print(self.tableView?.frame)
    }
    
    
    
}

