//
//  LDACARequestTableViewCell.swift
//  LDAContactApp
//
//  Created by Mac on 6/10/17.
//  Copyright © 2017 LeDucAnh. All rights reserved.
//

import UIKit

class LDACARequestTableViewCell: UITableViewCell {
    @IBOutlet weak var RequestContentLabel: UILabel!

    @IBOutlet weak var RequestStatusButton: UIButton!
    @IBOutlet weak var RequestUserNameLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
