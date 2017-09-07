//
//  LDACAClassesViewController.swift
//  LDAContactApp
//
//  Created by Mac on 6/6/17.
//  Copyright © 2017 LeDucAnh. All rights reserved.
//

import UIKit

class LDACAClassesViewController: UIViewController {

    @IBAction func CreateClassButonDidTouch(_ sender: Any) {
        self.performSegue(withIdentifier: "pushtoCreateClass", sender: nil)
    }

    var tableViewClassController =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainTableViewController")  as! LDAClassTableViewController
    var searchBar = UISearchBar()
    var searchControllerView =
        LDASearchTableViewControllerView()

    @IBOutlet weak var displayClassButton: UIButton!
    func setupAnchor()
    {
        self.searchControllerView.anchor(self.view.topAnchor, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, topConstant: 62, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: -1, heightConstant:-1)
        
        print(self.searchControllerView.frame)
        print(self.searchControllerView.tableView?.frame)
        print(self.searchControllerView.SearchBar?.frame)
        
    }
    
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "modalToClassDetailVC"
        {
            if let detailVC =    segue.destination as? LDAClassDetailViewController
            {
                detailVC.classmodel = sender as! LDACAClass
            }
            
        }
        

    }
    override func viewDidAppear(_ animated: Bool) {
     
        
               self.navigationController?.setNavigationBarHidden(false, animated: true)
        /*
       self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.navigationBar.barTintColor = UIColor.clear
        self.tabBarController?.tabBar.barTintColor = UIColor.clear
        
*/
                LDAKeyboardHanlder.shareInstance.register(viewController: self, backgroundviews: [self.searchControllerView.tableView!,(self.navigationController?.navigationBar)!])
        
       // LDAKeyboardHanlder.shareInstance.register(viewController: self, withBackGroundView: self.searchControllerView.tableView!)
        
        

    }
    var originalClassArr = [LDACAClass]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
               // self.tableView.backgroundView = imageView

        //            self.displayClassButton.setTitle("\(originalClassArr.count) Classes", for: .normal)

        searchBar.placeholder = "Type Class Name"
        searchControllerView.registerSearchBarActionReturn { (textString) in
            
            print(textString)
           
            if textString != ""
            
            {
                self.tableViewClassController.setSearchMode(value: true)
                
                /*
                if self.originalClassArr.count == 0 && self.tableViewClassController.LDACAclassArray.count != 0
                {
                    self.originalClassArr = self.tableViewClassController.LDACAclassArray
                }
 */
                
                FirebaseClassAPI.sharedInstance.searchClassWithNameValue(value: textString, { (classes) in
                
                self.tableViewClassController.modelArr = classes
                self.tableViewClassController.tableView.reloadData()
                
                })
            }
            else
            {
                
                self.tableViewClassController.setSearchMode(value: false)
                self.tableViewClassController.modelArr = self.originalClassArr
                self.tableViewClassController.tableView.reloadData()

            }
        }
        
        self.tableViewClassController.registerForCellTapped { (classCell) in
            
            
              self.performSegue(withIdentifier: "modalToClassDetailVC", sender: classCell)
        }
        
        
        
        self.tableViewClassController.registerHandleData { (arr) in
            
            self.displayClassButton.setTitle("\(arr.count) classes", for: .normal)
            
            
            
            self.originalClassArr =  self.tableViewClassController.modelArr as! [LDACAClass]
        }

        
        
    searchControllerView.setupWith(SearchBar: searchBar, tableView: tableViewClassController.tableView)

        self.searchControllerView.frame =  self.view.frame
        
        self.view.addSubview(self.searchControllerView)
        
        self.setupAnchor()
        
        
        
        let imageView = UIImageView(image: UIImage(named: "blur.jpg"))
        self.view.addSubview(imageView)
        self.view.sendSubview(toBack: imageView)
        
        imageView.anchor(self.view.topAnchor, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: -1, heightConstant: -1)
        
        

        
      //  self.view.addSubview(self.tableViewClassController.view)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
     //   self.tableViewClassController.view.anchor(self.view.topAnchor, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
