//
//  LDACANotificationViewController.swift
//  LDAContactApp
//
//  Created by Mac on 5/15/17.
//  Copyright © 2017 LeDucAnh. All rights reserved.
//

import UIKit
class LDACAClassNotificationViewController :LDACANotificationViewController
{
    override func topViewDidClickShareBtn(_ topView: TopView) {
        
        
        let indexPath = topView.indexPath
        let post = zyThumbnailTableVC.tableViewDataList[(indexPath?.row)!] as! LDACANotification
       
        
        
        post.deleteClassNotification{ (success) in
            if success
            {
                LDAActionResultHandler.sharedInstance.handleAction(title: "Successfully delete object", returnCase: .success)
                super.topViewDidClickShareBtn(topView)
                
            }
            else
            {
                LDAActionResultHandler.sharedInstance.handleAction(title: "Fail to delete object", returnCase: .fail)

            }
        }

    }
    override func topViewDidClickMarkAsReadButton(_ topView: TopView) {
        let indexPath = topView.indexPath
        let post = zyThumbnailTableVC.tableViewDataList[(indexPath?.row)!] as! LDACANotification
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
            LDACANotification.updateRespondAction(forClassNoti: post, withAction: .seen) { (LDACANotification) in
                
            }

        }
        
        let buttonThree = DefaultButton(title: "Decline", height: 60) {
            print("Ah, maybe next time :)")
            LDACANotification.updateRespondAction(forClassNoti: post, withAction: .Decline) { (LDACANotification) in
            }

        }
        let buttonFour = DefaultButton(title: "Accept", height: 60) {
            print("Ah, maybe next time :)")
            LDACANotification.updateRespondAction(forClassNoti: post, withAction: .Accept) { (LDACANotification) in
            
            }

        }

        
        // Add buttons to dialog
        // Alternatively, you can use popup.addButton(buttonOne)
        // to add a single button
        popup.addButtons([buttonOne, buttonTwo, buttonThree , buttonFour])
        
        // Present dialog
        self.present(popup, animated: true, completion: nil)

        
    }
    
        //zyThumbnailTableVC.reloadMainTableView()
}
