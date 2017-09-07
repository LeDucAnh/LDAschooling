//
//  TopView.swift
//  ZYThumbnailTableView
//
//  Created by lzy on 16/2/14.
//  Copyright © 2016年 lzy. All rights reserved.
//

import UIKit


@objc protocol DiyTopViewDelegate {
    @objc optional func topViewDidClickFavoriteBtn(_ topView: TopView)
    @objc optional func topViewDidClickMarkAsReadButton(_ topView: TopView)
    @objc optional func topViewDidClickShareBtn(_ topView: TopView)
}

//selected A7DA55
//default  AAAAAA
class LDACANotiTableViewCellTopView : TopView

{

    @IBAction func DeleteButtonDidTouch(_ sender: Any) {
     
        if let nonNilDelegate = delegate {
            nonNilDelegate.topViewDidClickShareBtn!(self)
        }
    
    }
    override class func createView(_ indexPath: IndexPath, post: LDACANotification) -> TopView? {
        let view = Bundle.main.loadNibNamed("LDACANotiTableViewCellTopView", owner: nil, options: nil)?.first as? TopView
        guard let nonNilView = view else {
            assertionFailure("ERROR: can not load nib \"TopView\"")
            return nil
        }
        nonNilView.indexPath = indexPath
        nonNilView.configureComponents(post)
        return nonNilView
    }
 

    override func setupReadButtonWhenClicked(_ sender: UIButton) {
        
        
    }
    override func configureComponents(_ post: LDACANotification) {
        //-----收藏
        
        if post.favorite! {
            favoriteButton.setImage(UIImage(named: "star_solid"), for: UIControlState())
            favoriteButton.setTitleColor(COLOR_SELECTED, for: UIControlState())
            favoriteButton.tag = TAG_BUTTON_SELECTED
        } else {
            favoriteButton.setImage(UIImage(named: "star_hollow"), for: UIControlState())
            favoriteButton.setTitleColor(COLOR_NORMAL, for: UIControlState())
            favoriteButton.tag = TAG_BUTTON_GENERAL
        }
        
        //-----已读
        print(post.currentUserRespondState?.rawValue)
        if post.currentUserRespondState?.rawValue == LDACAFirebasePostRespondAction.seen.rawValue
        {
            //setimage
            readMarkingButton.setImage(UIImage(named: "tick_solid"), for: UIControlState())
            readMarkingButton.setTitleColor(COLOR_NORMAL, for: UIControlState())
            readMarkingButton.setTitle(" Seen", for: UIControlState())
            readMarkingButton.tag = TAG_BUTTON_GENERAL
        }
        if post.currentUserRespondState?.rawValue == LDACAFirebasePostRespondAction.Accept.rawValue {
            //setimage
            readMarkingButton.setImage(UIImage(named: "tick_hollow"), for: UIControlState())
            readMarkingButton.setTitleColor(COLOR_SELECTED, for: UIControlState())
            readMarkingButton.setTitle(" Accepted", for: UIControlState())
            readMarkingButton.tag = TAG_BUTTON_SELECTED
        }
        
        if post.currentUserRespondState?.rawValue == LDACAFirebasePostRespondAction.Decline.rawValue {
            //setimage
            readMarkingButton.setImage(UIImage(named: "tick_hollow"), for: UIControlState())
            readMarkingButton.setTitleColor(COLOR_REJECT, for: UIControlState())
            readMarkingButton.setTitle(" Declined", for: UIControlState())
            readMarkingButton.tag = TAG_BUTTON_SELECTED
        }
    }
    

}
class TopView: UIView {
    
    
    @IBOutlet weak var readMarkingButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    
    let TAG_BUTTON_GENERAL = 10
    let TAG_BUTTON_SELECTED = 20
    
    let COLOR_SELECTED = UIColor(red: 167/255.0, green: 218/255.0, blue: 85/255.0, alpha: 1.0)
    let COLOR_NORMAL = UIColor(red: 170/255.0, green: 170/255.0, blue: 170/255.0, alpha: 1.0)
    let COLOR_REJECT = UIColor.red
    var indexPath: IndexPath!
    var delegate: DiyTopViewDelegate?

    class func createView(_ indexPath: IndexPath, post: LDACANotification) -> TopView? {
        let view = Bundle.main.loadNibNamed("TopView", owner: nil, options: nil)?.first as? TopView
        guard let nonNilView = view else {
            assertionFailure("ERROR: can not load nib \"TopView\"")
            return nil
        }
        nonNilView.indexPath = indexPath
        nonNilView.configureComponents(post)
        return nonNilView
    }
    
    func configureComponents(_ post: LDACANotification) {
        //-----收藏
        
        if post.favorite! {
            favoriteButton.setImage(UIImage(named: "star_solid"), for: UIControlState())
            favoriteButton.setTitleColor(COLOR_SELECTED, for: UIControlState())
            favoriteButton.tag = TAG_BUTTON_SELECTED
        } else {
            favoriteButton.setImage(UIImage(named: "star_hollow"), for: UIControlState())
            favoriteButton.setTitleColor(COLOR_NORMAL, for: UIControlState())
            favoriteButton.tag = TAG_BUTTON_GENERAL
        }
        
        //-----已读
        if post.seen! {
            //setimage
            readMarkingButton.setImage(UIImage(named: "tick_solid"), for: UIControlState())
            readMarkingButton.setTitleColor(COLOR_SELECTED, for: UIControlState())
            readMarkingButton.setTitle(" Accept", for: UIControlState())
            readMarkingButton.tag = TAG_BUTTON_SELECTED
        } else {
            //setimage
            readMarkingButton.setImage(UIImage(named: "tick_hollow"), for: UIControlState())
            readMarkingButton.setTitleColor(COLOR_NORMAL, for: UIControlState())
            readMarkingButton.setTitle(" Decline", for: UIControlState())
            readMarkingButton.tag = TAG_BUTTON_GENERAL
        }
    }
    
    @IBAction func clickFavoriteButton(_ sender: UIButton) {
        if sender.tag == TAG_BUTTON_GENERAL {
            sender.setTitleColor(COLOR_SELECTED, for: UIControlState())
            sender.setImage(UIImage(named: "star_solid"), for: UIControlState())
            sender.tag = TAG_BUTTON_SELECTED
        } else if sender.tag == TAG_BUTTON_SELECTED {
            sender.setTitleColor(COLOR_NORMAL, for: UIControlState())
            sender.setImage(UIImage(named: "star_hollow"), for: UIControlState())
            sender.tag = TAG_BUTTON_GENERAL
        }
        
        //notification
        let notification = Notification(name: Notification.Name(rawValue: "NOTIFY_NAME_DISMISS_PREVIEW"), object: nil)
        NotificationCenter.default.perform(#selector(NotificationCenter.post(_:)), with: notification, afterDelay: 0.25)
        
        //delegate
        if let nonNilDelegate = delegate {
            nonNilDelegate.topViewDidClickFavoriteBtn?(self)
        }
    }
    
    func setupReadButtonWhenClicked(_ sender: UIButton)
    {
        if sender.tag == TAG_BUTTON_GENERAL {
            sender.setTitleColor(COLOR_SELECTED, for: UIControlState())
            sender.setTitle(" Mark as Decline", for: UIControlState())
            sender.setImage(UIImage(named: "tick_solid"), for: UIControlState())
            sender.tag = TAG_BUTTON_SELECTED
        } else if sender.tag == TAG_BUTTON_SELECTED {
            sender.setTitleColor(COLOR_NORMAL, for: UIControlState())
            sender.setTitle(" Mark as Accept", for: UIControlState())
            sender.setImage(UIImage(named: "tick_hollow"), for: UIControlState())
            sender.tag = TAG_BUTTON_GENERAL
        }

    }
    @IBAction func clickMarkAsReadButton(_ sender: UIButton) {
        
        self.setupReadButtonWhenClicked(sender)
        //notification
        let notification = Notification(name: Notification.Name(rawValue: "NOTIFY_NAME_DISMISS_PREVIEW"), object: nil)
        NotificationCenter.default.perform(#selector(NotificationCenter.post(_:)), with: notification, afterDelay: 0.25)
        
        //delegate
        if let nonNilDelegate = delegate {
            nonNilDelegate.topViewDidClickMarkAsReadButton?(self)
        }
    }
    
    
}
