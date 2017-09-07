
import Foundation
import UIKit


class SenderCell: UITableViewCell {
    
    @IBOutlet weak var profilePic: RoundedImageView!
    @IBOutlet weak var message: UITextView!
    @IBOutlet weak var messageBackground: UIImageView!
    var videoView: ESVideoView!
 
    
    func clearCellData()  {
        self.message.text = nil
        self.message.isHidden = false
        self.messageBackground.image = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.message.textContainerInset = UIEdgeInsetsMake(5, 5, 5, 5)
        self.messageBackground.layer.cornerRadius = 15
        self.messageBackground.clipsToBounds = true
        self.setupVideoView()
    }
    func setupVideoView()
    {
        self.videoView = ESVideoView(frame: CGRect.zero)
        self.addSubview(self.videoView)
        
        self.videoView.anchor(self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: -1, heightConstant: -1)

    }
    func beginToPlayVideo()
    {
        self.videoView.beginPlayWithURL("https://www.dropbox.com/s/dw9i8ifhd6w261o/1632393030418290.mp4?dl=1")
    }
}



class ReceiverCell: UITableViewCell {
    
    @IBOutlet weak var message: UITextView!
    @IBOutlet weak var messageBackground: UIImageView!
    var videoView: ESVideoView!

    func clearCellData()  {
        self.message.text = nil
        self.message.isHidden = false
        self.messageBackground.image = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.message.textContainerInset = UIEdgeInsetsMake(5, 5, 5, 5)
        self.messageBackground.layer.cornerRadius = 15
        self.messageBackground.clipsToBounds = true
    }
    func setupVideoView()
    {
        self.videoView = ESVideoView(frame: CGRect.zero)
        self.addSubview(self.videoView)
        
        self.videoView.anchor(self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: -1, heightConstant: -1)
        
    }
    func beginToPlayVideo()
    {
        self.videoView.beginPlayWithURL("https://www.dropbox.com/s/dw9i8ifhd6w261o/1632393030418290.mp4?dl=1")
    }

}

class ConversationsTBCell: UITableViewCell {
    
    @IBOutlet weak var profilePic: RoundedImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    func clearCellData()  {
        self.nameLabel.font = UIFont(name:"AvenirNext-Regular", size: 17.0)
        self.messageLabel.font = UIFont(name:"AvenirNext-Regular", size: 14.0)
        self.timeLabel.font = UIFont(name:"AvenirNext-Regular", size: 13.0)
        self.profilePic.layer.borderColor = GlobalVariables.purple.cgColor
        self.messageLabel.textColor = UIColor.rbg(r: 111, g: 113, b: 121)
        self.nameLabel.textColor = EnglishSocietyConfigurateVaribles.SharedInstance.ESGymRed
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.profilePic.layer.borderWidth = 2
        self.profilePic.layer.borderColor = GlobalVariables.purple.cgColor
    }
    
}

class ContactsCVCell: UICollectionViewCell {
    
    @IBOutlet weak var profilePic: RoundedImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}




