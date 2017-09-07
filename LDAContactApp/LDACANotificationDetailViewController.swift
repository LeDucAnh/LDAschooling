//
//  LDACANotificationDetailViewController.swift
//  LDAContactApp
//
//  Created by Mac on 5/26/17.
//  Copyright © 2017 LeDucAnh. All rights reserved.
//

import UIKit


class LDACANotificationDetailViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {


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
    //   var inputTextview = UITextView()
    
    var navView = LDACANavView()
    
    var  optionView : LDAHorizontalScrollOptionView?
    
    var notification : LDACANotification?
    var detailTableView = UITableView()
    var currentSetupArray = [LDACAReceiver]()
    func handleDoneButtonTap()
    {
        
    }
    func handleCloseButtonTap()
    {
        self.dismiss(animated: true , completion: nil)
        
    }
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
        
        
        self.view.layoutSubviews()
        self.view.layoutIfNeeded()
        self.navView.embedToView(view: self.view)
        self.navView.DoneButton.setTitle("", for: .normal)
        self.navView.registerForReturnAction { (LDACANavViewReturnAction) in
            print("nav view action")
            if LDACANavViewReturnAction == .done
            {
                self.handleDoneButtonTap()
                
            }
            else
            {
                self.handleCloseButtonTap()
            }
            
            
            
        }
        
        self.setupAppearance()
        self.setupAnchor()
        
        self.view.layoutSubviews()
        self.view.layoutIfNeeded()
        self.setupAction()
        // Do any additional setup after loading the view.
        
        // self.ViewerButton.imageView?.frame = CGRect(x: 0, y: 0, width: self.ViewerButton.frame.size.height, height: self.ViewerButton.frame.size.height)
        
        
        self.setupOptionView()
        self.setupDetailTableView()
        
        
    }
    
    
    func setupDetailTableView()
    {
        
        
        self.view.addSubview(self.detailTableView)
        self.detailTableView.register(LDAUserIDTableViewCell.self, forCellReuseIdentifier: "Cell")

        self.detailTableView.register(UINib(nibName: "LDAUserIDTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        self.detailTableView.anchor(self.optionView?.bottomAnchor, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: -1, heightConstant: -1)
   
        
        
        
        self.detailTableView.dataSource =  self
        self.detailTableView.delegate =  self
       
    }
    //MARK TABLEVIEWDATASOURCE 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        
        print(self.optionView?.currentOption)
            if self.optionView?.currentOption == LDACAFirebasePostRespondAction.pending.rawValue
            {
                
                
                
                self.currentSetupArray = (self.notification?.receiversArr.filter ({ $0.respondAction?.rawValue == LDACAFirebasePostRespondAction.pending.rawValue}))!
             
                
            }
        if self.optionView?.currentOption == LDACAFirebasePostRespondAction.seen.rawValue
        {
            
            
            
            self.currentSetupArray = (self.notification?.receiversArr.filter ({ $0.respondAction?.rawValue == LDACAFirebasePostRespondAction.seen.rawValue}))!
            
            
        }

        if self.optionView?.currentOption == LDACAFirebasePostRespondAction.Decline.rawValue
        {
          self.currentSetupArray =   (self.notification?.receiversArr.filter ({ $0.respondAction?.rawValue == LDACAFirebasePostRespondAction.Decline.rawValue}))!
        }
        if self.optionView?.currentOption == LDACAFirebasePostRespondAction.Accept.rawValue
        {
            
         self.currentSetupArray =    (self.notification?.receiversArr.filter ({ $0.respondAction?.rawValue == LDACAFirebasePostRespondAction.Accept.rawValue}))!
        }

        
        
        return self.currentSetupArray.count
        
        
    }

 func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! LDAUserIDTableViewCell
        print(self.currentSetupArray[indexPath.row].id)
      cell.UserIDTtileLabel.text =  self.currentSetupArray[indexPath.row].id
        cell.backgroundColor = UIColor.white
        
        return cell
    }
    func setupOptionView()
        
    {
        
        optionView  = LDAHorizontalScrollOptionView(view, titleValues: ["Pending","Seen","Decline","Accept"], atYValue: 0, withHeight: 45, displayItem: 3)
        optionView?.registerForCellSelected(action: { (LDAHorizontalScrollOptionCell) in
            
            self.detailTableView.reloadData()
        })
        self.view.addSubview(optionView!)
        optionView?.translatesAutoresizingMaskIntoConstraints =  false
        var newConstraint = NSLayoutConstraint(item: self.navView, attribute: .bottom,
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

    }
    func setupAction()
    {
    }
    func updateViewerButtonWithStatusArr(arr : [LDACheckListTableViewCellStatus],isAllSelected:Bool)
    {
        
    }
    func viewerButtondidTouch()
    {
        
        
    }
    func setupAppearance()
    {
        self.navView.backgroundColor = UIColor.rbg(r: 45, g: 135, b: 220)
        
        
        
        ///28 127 230
    }
    func setupAnchor()
    {
        
        
        
        print(navView.frame)
        //  navView.backgroundColor = UIColor.red
        
        
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
