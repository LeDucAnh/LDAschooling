//
//  LDAUserIDTableViewCell.swift
//  LDAContactApp
//
//  Created by Mac on 5/7/17.
//  Copyright © 2017 LeDucAnh. All rights reserved.
//

import UIKit

class LDAUserIDTableViewCell: UITableViewCell {
    @IBOutlet weak var UserIDTtileLabel: UILabel!

    @IBOutlet weak var UserDetailButton: UIButton!
    @IBAction func UserDetailButtonDidTouch(_ sender: Any) {
        
        
        
        
        if self.UserDetailButtonDidTouchAction != nil
        {
            self.UserDetailButtonDidTouchAction()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    var UserDetailButtonDidTouchAction:(()->Void)!

    
    func captureDetailButtontouchAction(action:@escaping ()->Void)
    {
        self.UserDetailButtonDidTouchAction =  action
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
