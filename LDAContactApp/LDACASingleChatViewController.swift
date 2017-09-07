//
//  LDACASingleChatViewController.swift
//  LDAContactApp
//
//  Created by Mac on 5/31/17.
//  Copyright © 2017 LeDucAnh. All rights reserved.
//

import UIKit

class LDACASingleChatViewController: UIViewController {

    var ChatViewController : ChatVC!
    
    
    var navView = LDACANavView()
    var WithUser : LDACAUser!
    class func pushToChatVC(id:String,vc:UIViewController)
    {
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
                
                vc.present(ChatNavigationNavController, animated: true, completion: nil)
                
                
                
                
                
            })
            
            
        

    }
    func setupNavView()
    {
        
        
        self.navView.embedToView(view: self.view)
        self.navView.DoneButton.setTitle("", for: .normal)
        self.navView.titleLabel.text = WithUser.lastName + " " + WithUser.firstName
        self.navView.backgroundColor = UIColor.rbg(r: 45, g: 135, b: 220)
        
        
        self.navView.registerForReturnAction { (LDACANavViewReturnAction) in
            print("nav view action")
            if LDACANavViewReturnAction == .exit
                
            {
                self.dismiss(animated: true, completion: nil)
            }
            
            
            
        }

        
    }

    func setupChatView()
    {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
            ChatViewController = storyboard.instantiateViewController(withIdentifier: "Chat") as! ChatVC
        
        
        ChatViewController.currentUser = WithUser
        self.view.addSubview(ChatViewController.view)
        
        self.view.addSubview(ChatViewController.inputAccessoryView!)
        ChatViewController.view.anchor(self.navView.bottomAnchor, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: -1, heightConstant: -1)
      
        
    self.inputAnchor =  ChatViewController.inputAccessoryView?.anchor(nil, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: -1, heightConstant: 50)
        
    }
    
    
    var inputAnchor : LDACAAnchorValue!
    func showKeyboard(notification: Notification) {
        if let frame = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let height = frame.cgRectValue.height
            
            print(ChatViewController.inputAccessoryView?.frame)
            print(height)
            print(self.inputAnchor.anchorValueWithLDACAAnchorKey(.bottom).constant)
            
            
            
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 1, animations: {
             self.inputAnchor.anchorValueWithLDACAAnchorKey(.bottom).constant  = -height
                self.view.layoutIfNeeded()
            })

            self.view.setNeedsUpdateConstraints()
            ChatViewController.inputAccessoryView?.setNeedsUpdateConstraints()
            
            self.view.layoutSubviews()
            self.view.layoutIfNeeded()
            
            print(ChatViewController.inputAccessoryView?.frame)
            self.ChatViewController.tableView.contentInset.bottom = height
            self.ChatViewController.tableView.scrollIndicatorInsets.bottom = height
            if self.ChatViewController.items.count > 0 {
                self.ChatViewController.tableView.scrollToRow(at: IndexPath.init(row: self.ChatViewController.items.count - 1, section: 0), at: .bottom, animated: true)
            }
        }
    }
    func hideKeyboard(notification: Notification) {
                    self.inputAnchor.anchorValueWithLDACAAnchorKey(.bottom).constant = 0
        
        self.ChatViewController.view.layoutIfNeeded()
        self.ChatViewController.view.layoutSubviews()
    }

        override func viewDidLoad() {
        
        self.setupNavView()
        self.setupChatView()
            NotificationCenter.default.addObserver(self, selector: #selector(LDACASingleChatViewController.showKeyboard(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)

                NotificationCenter.default.addObserver(self, selector: #selector(LDACASingleChatViewController.hideKeyboard(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
        LDAKeyboardHanlder.shareInstance.register(viewController: self, backgroundviews: [self.ChatViewController.tableView,self.navView])
    }
    
    
}
