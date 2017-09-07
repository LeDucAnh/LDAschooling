//
//  LDACAClassPostNotificationViewController.swift
//  LDAContactApp
//
//  Created by Mac on 5/21/17.
//  Copyright © 2017 LeDucAnh. All rights reserved.
//

import UIKit

class LDACAClassPostNotificationViewController : LDACAPostNotificationViewController
{
    
    let classNotiSendVC = LDAClassNotificationSendCheckListVC()
    var classID :String?
    var isAllSelected =  true
    
    override func handleCloseButtonTap()
    {
        self.dismiss(animated: true , completion: nil)
    }
    
    override func handleDoneButtonTap() {
        
        
        
        let noti = LDACANotification.init(type: .text, content: self.inputTextField.text, owner: .sender, timestamp: Int(Date().timeIntervalSince1970), isRead: false, classID: "")
        
        if self.embedingURL != ""
        {
            noti.embedURL = self.embedingURL
        }
   
        print(self.returnSelectValueFromCellStatusArr(statusArr: self.currentSelected, Arr: self.viewerIDStringArr))
        
        
        LDACANotification.sendClass(notification: noti, istoAll: self.isAllSelected, toID: self.returnSelectValueFromCellStatusArr(statusArr: self.currentSelected, Arr: self.viewerIDStringArr), accessType:  .limitUserType, withValues: LDACANotification.composeNotificationWithNoti(notification: noti), classId: classID!) { (Bool,key) in
            if Bool
            {
                
                //
                if self.uploadImage != nil
                {
                    let thumbImageData = (UIImageJPEGRepresentation(self.uploadImage!, 0.4)! as Data) as Data
                    FirebaseAPI.shareInstance.uploadPhotoFileToFirebase(thumbImageData, name: key, completion: { (downloadLink) in
                        
                        
                        noti.parent = key
                        noti.belongtoclassId = self.classID
                        
                        noti.updateNotification(key: "photoURL",downloadLink, completion: {
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
                if let vidurl = self.uploadvideoLocalURL
                {

                    FirebaseAPI.shareInstance.uploadVidFileFromLocal(vidurl, name: key, completion: { (downloadlink) in
                        
                        
                        
                        noti.parent = key
                        noti.belongtoclassId = self.classID
                        noti.updateNotification(key: "videoURL",downloadlink, completion: {
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
                
                

                
                
                
            LDAActionResultHandler.sharedInstance.handleAction(title: "Successfully upload notification", returnCase: .success)
            }
            else
            {
                
                
                            LDAActionResultHandler.sharedInstance.handleAction(title: "Fail to upload notification", returnCase: .fail)
            }
            
        }
        
        
        
        
        
        /*
         LDACANotification.send(notification: noti, istoAll: self.classNotiSendVC.checkIfSelectedAll(), toID: self.returnSelectValueFromCellStatusArr(statusArr: self.currentSelected, Arr: self.viewerIDStringArr), accessType: .limitUserType, withValues: LDACANotification.composeNotificationWithNoti(notification: noti), completion: { (Bool) in
         
         })
         */

        
    }
    override func viewerButtondidTouch()
    {
        classNotiSendVC.StudentIDArr = self.viewerIDStringArr
        classNotiSendVC.returnWhenCloseAction = ({
            (postCheckListVC) in
            
            
            self.currentSelected = (postCheckListVC.TableViewCheckList?.cellStatusArr)!
            self.isAllSelected =  (postCheckListVC.TableViewCheckList?.isAllSelected())!
            
            self.updateViewerButtonWithStatusArr(arr: self.currentSelected, isAllSelected: self.isAllSelected)
            
            
            if !(postCheckListVC.TableViewCheckList?.isAllSelected())!
            {
                //didcommitchange
                
                
                
                
                let countSelected = (postCheckListVC.TableViewCheckList?.countSelectedRow)
                
                //  print((postCheckListVC.TableViewCheckList?.countSelectedRow))
                print(countSelected)
                
                print(postCheckListVC.TableViewCheckList!.cellStatusArr)
                let string =  "send to " + String(describing: postCheckListVC.TableViewCheckList!.cellStatusArr.filter({$0 == LDACheckListTableViewCellStatus.selected}).count) + " User"
                self.ViewerButton.setTitle(string, for: .normal)
                
            }
                
            else
            {
                self.ViewerButton.setTitle("All User", for: .normal)
                
            }
            
            
            
        })
        self.present(classNotiSendVC, animated: true, completion: nil)
        classNotiSendVC.setCheckListWithCellStatusArr(arr: self.currentSelected)
        
        
        
    }
    
}
