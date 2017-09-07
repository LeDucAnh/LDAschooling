//
//  LDAClassNotificationSendCheckListViewController.swift
//  LDAContactApp
//
//  Created by Mac on 5/19/17.
//  Copyright © 2017 LeDucAnh. All rights reserved.
//

import UIKit
class LDAClassNotificationSendCheckListVC : UIViewController
{
    
    
    
    var searchControllerView = LDASearchTableViewControllerView()
  //-- searhControllerView will control TableViewCheckList and SearchBar
    var TableViewCheckList : LDAStudentCheckListTableView?
    var SearchBar = UISearchBar()
    //--

    
    
    var navView = LDACANavView()
    var StudentIDArr = [Int]()
    
    func checkIfSelectedAll ()->Bool
    {
       return  (TableViewCheckList?.isAllSelected())!
    }
    var isAllSelected : Bool?
    {
        didSet{
            
          
            
            
            self.TableViewCheckList?.isAllSelected =  self.isAllSelected
        }
        willSet(newValue){
            //println("willSet called")
        }
    }
    func setCheckListWithCellStatusArr(arr : [LDACheckListTableViewCellStatus])
    {
        self.TableViewCheckList?.cellStatusArr = arr
        self.TableViewCheckList?.reloadRows(at: (self.TableViewCheckList?.indexPathsForVisibleRows!)!, with: .fade)

    }

    

    var returnWhenCloseAction : ((_ checkListVC : LDAClassNotificationSendCheckListVC)->Void)!
   
    func setupAnchor()
    {
        self.searchControllerView.anchor(self.navView.bottomAnchor, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: -1, heightConstant: -1)
        
    }
    override func viewDidLoad() {
        
        
        self.navView.embedToView(view: self.view)
        self.navView.backgroundColor = UIColor.rbg(r: 45, g: 135, b: 220)

        self.navView.registerForReturnAction { (LDACANavViewReturnAction) in
            //nav return action 
            if LDACANavViewReturnAction == .done
            {
                //return current check list then exit 
                
              //  self.searchControllerView
                
                self.returnWhenCloseAction(self)
                
            }
            else
            {//just exit
                
                
            }
            self.dismiss(animated: true, completion: nil)
        }
        
        self.searchControllerView.frame =  self.view.frame
        self.view.backgroundColor = UIColor.white
        TableViewCheckList =  LDAStudentCheckListTableView(frame: self.view.frame, Items: StudentIDArr)
        
        
        
        
        TableViewCheckList?.setup(numberOfItem: StudentIDArr.count)
        self.view.addSubview(searchControllerView)
        
        searchControllerView.setupWith(SearchBar: SearchBar, tableView: TableViewCheckList!)
        
        
        
        print(self.searchControllerView.frame)
        print(self.SearchBar.frame)
        print(TableViewCheckList?.frame)
        print(self.view.frame)
        
        self.setupAnchor()
        
    }
}
