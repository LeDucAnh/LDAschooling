//
//  ZYThumbnailTableViewCell.swift
//  ZYThumbnailTableView
//
//  Created by lzy on 16/2/8.
//  Copyright © 2016年 lzy. All rights reserved.
//

import UIKit
import URLEmbeddedView
public enum DIYTableViewCellActionReturnType : Int
{
    case DetailButtonTapped
    case URLWebViewTapped
}
class DIYTableViewCell: UITableViewCell {
    @IBOutlet weak var extensionsViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var extensionView: UIView!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var favoriteMarkImageView: UIImageView!
    @IBOutlet weak var unreadMarkImageView: UIImageView!
    var DIYTableViewCellDidTouchReturnAction:((_ actionType : DIYTableViewCellActionReturnType)->Void)!
    var currentPost = LDACANotification()
    
    
    var embedURLView = URLEmbeddedView()
    
    var seeMoreLabel = UILabel()
    
    var isPreviewCell = false
    
    
    
    var photoImageView = UIImageView()
    var videoView =  ESVideoView()
    
    
    func setupVideoView()
    {
        self.extensionView.addSubview(self.videoView)
        self.videoView.anchor(self.extensionView.topAnchor, left: self.extensionView.leftAnchor, bottom: self.extensionView.bottomAnchor, right: self.extensionView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: -1, heightConstant: -1 )
        
        self.layoutSubviews()
        self.layoutIfNeeded()

        
        
        
        /*
        self.videoView = ESVideoView(frame: CGRect.zero)
        self.containerView.addSubview(self.videoView)
        
        self.videoView.anchor(self.contentLabel.bottomAnchor, left: self.containerView.leftAnchor, bottom: self.containerView.bottomAnchor, right: self.containerView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 320)
        print(self.videoView.frame)
        
        self.videoView.beginPlayWithURL("https://www.dropbox.com/s/dw9i8ifhd6w261o/1632393030418290.mp4?dl=1")
        print(self.videoView.frame)
         */
    }


    
    func registerForReturnAction(action:@escaping (_ actionType: DIYTableViewCellActionReturnType)->Void)

    {
        self.DIYTableViewCellDidTouchReturnAction = action
    }
    
    @IBAction func DetailbuttonDidTouch(_ sender: Any) {
        self.DIYTableViewCellDidTouchReturnAction(DIYTableViewCellActionReturnType.DetailButtonTapped)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // self.setupVideoView()
        
        

            // Initialization code
    }
    
    class func createCell() -> DIYTableViewCell {
        let cell = Bundle.main.loadNibNamed("DIYTableViewCell", owner: nil, options: nil)?.first as? DIYTableViewCell
        
        
        
        assert(cell != nil, "can not load nib named DIYTableViewCell")
        return cell!
    }
    class func createPreviewCell() -> DIYTableViewCell {
        let cell = Bundle.main.loadNibNamed("DIYTableViewCell", owner: nil, options: nil)?.first as? DIYTableViewCell
        assert(cell != nil, "can not load nib named DIYTableViewCell")
       
        
       // cell?.videoView.removeFromSuperview()
        
        return cell!
    }
    
func setupExtensionsView()
{
    for subview in self.extensionView.subviews{
        subview.isHidden  =  true
    }
    }
    func updateCell(_ post: LDACANotification) {
        currentPost = post
        
        print(post)
        
        
        
        nameLabel.text = "\(post.sendUser!.lastName!) \(post.sendUser!.firstName!)"
        if let imageurl  = post.sendUser?.profileImageURL
        {
            
            
            avatarImageView.layer.masksToBounds =  true
            avatarImageView.layer.cornerRadius =  avatarImageView.frame.size.width/2
            
        }
        descLabel.text = "User ID \(post.fromID!)"
        timeLabel.text = NSDate(timeIntervalSince1970: Double(post.timestamp)).timeAgoSinceDate(numericDates: true)
        
        
        contentLabel.text = post.content as! String
       // avatarImageView.image = UIImage(named: post.avatar) ?? UIImage(named: "avatar0")
        avatarImageView.image = UIImage(named: "avatar0") ?? UIImage(named: "avatar0")
        self.extensionView.isHidden =  true
        
        self.extensionsViewHeightConstraint.constant = 0

        self.layoutSubviews()
        self.layoutIfNeeded()
        self.setupExtensionsView()
        if let photoURL = post.photoURL
        {
            
            self.extensionView.isHidden =  false
            self.extensionsViewHeightConstraint.constant = EnglishSocietyConfigurateVaribles.SharedInstance.ScreenSize.width
            setupPhotoImageView()

            if self.isPreviewCell == true
                
            {
              

self.photoImageView.isHidden = false
                self.photoImageView.sd_setImage(with: URL(string: photoURL))
                
                

                self.layoutSubviews()
                self.layoutIfNeeded()

            }
            else
            {
                self.setupSeemoreButton()
            }
            
           
        }
        if let videoURL = post.videoURL
        {
            
            self.extensionView.isHidden =  false
            self.extensionsViewHeightConstraint.constant = EnglishSocietyConfigurateVaribles.SharedInstance.ScreenSize.width
            self.setupVideoView()
            if self.isPreviewCell == true
                
            {
                
                
                
                self.videoView.isHidden = false
                videoView.beginPlayWithURL( videoURL)
                
                self.layoutSubviews()
                self.layoutIfNeeded()
                
            }
            else
            {
                self.setupSeemoreButton()
            }
            
            
        }

        
        
        if let embedurl = post.embedURL
        {
            if post.embedURL != ""
                
            {
                
                
                self.extensionsViewHeightConstraint.constant = 100

                setupURLWebView()
                let url = post.embedURL
            

                

                if self.isPreviewCell == true
                    
                {
                    

                    self.extensionView.isHidden =  false
                    print(self.contentView.superview)
                                        self.contentView.isUserInteractionEnabled
                                            =  true
                    
                    
                    
                    self.isUserInteractionEnabled =  true
                    
                    self.extensionView.isUserInteractionEnabled =  true
                    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.webURLViewTapHandle(_:)))
                    tapGesture.delegate =  self
                    self.isUserInteractionEnabled = true
                    
                    self.extensionView.addGestureRecognizer(tapGesture)
                    self.embedURLView.isHidden = false
                    
                }
                else
                {
                    //set up see more button
                    self.setupSeemoreButton()
                }
                   
                
                self.embedURLView.loadURL(url!)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    // your code here
                    self.embedURLView.loadURL(url!)
                }
            }
            

                
        
        }
        
        
        
   //     self.favoriteMarkImageView.isHidden = !post.favorite
     //   self.unreadMarkImageView.isHidden = post.read
    }
    func setupURLWebView()
    {
        self.extensionView.addSubview(self.embedURLView)
        self.embedURLView.anchor(self.extensionView.topAnchor, left: self.extensionView.leftAnchor, bottom: self.extensionView.bottomAnchor, right: self.extensionView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: -1, heightConstant: -1 )
        
        self.layoutSubviews()
        self.layoutIfNeeded()
        
        
        
    }

    func setupPhotoImageView()
    {
        
        
        self.extensionView.addSubview(self.photoImageView)
        self.photoImageView.anchor(self.extensionView.topAnchor, left: self.extensionView.leftAnchor, bottom: self.extensionView.bottomAnchor, right: self.extensionView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: -1, heightConstant: -1 )


        
        self.layoutSubviews()
        self.layoutIfNeeded()

        
        

    }
    func setupSeemoreButton()
    {
        //self.seeMoreButton.setTitle("Tap to see embeded URL", for: .normal)
        
        self.seeMoreLabel.textColor = UIColor.gray
        self.addSubview(self.seeMoreLabel)
        self.seeMoreLabel.textAlignment = .center
        self.seeMoreLabel.font = UIFont.systemFont(ofSize: 12)
        self.seeMoreLabel.text = "Tap to see more"
        
        self.seeMoreLabel.anchor(self.extensionView.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 2, leftConstant: 2, bottomConstant: 8, rightConstant: 8, widthConstant: -1, heightConstant: -1)
       

        
    
        
    }
    public override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
    }

    public override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
return true
    
        
        }
    
    func webURLViewTapHandle(_  sender: UITapGestureRecognizer)
    {
        //tap on webview 
                self.DIYTableViewCellDidTouchReturnAction(DIYTableViewCellActionReturnType.URLWebViewTapped)
        
      //  self.superview?.gestureRecognizers = currentGesture
        print("Tap on webview")
    }
    
}
