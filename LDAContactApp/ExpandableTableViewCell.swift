//
//  ExpandableTableViewCell.swift
//  HSUFreeWalkingtour
//
//  Created by Mac on 11/8/16.
//  Copyright © 2016 LeDucAnh. All rights reserved.
//

import UIKit

protocol ExpandableTableViewCellDelegate: class {
    
    /// Media Launched successfully on the cast device
    func DetailButtonDidTap(_ sender:UIView)
    
}

class ExpandableTableViewCell: UITableViewCell {
    
    @IBOutlet weak var ExpandableTitleLabel: UILabel!
    @IBOutlet weak var ExpandableSubTitleLabel: UILabel!

    @IBOutlet weak var ExpandableArrowImageView: UIImageView!
    @IBOutlet weak var ExpandableDetailButton: UIButton!
    @IBOutlet weak var ExpandableImageview: UIImageView!
    var delegate:ExpandableTableViewCellDelegate?
    var IsExpand:Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func DetailButtonDidSelect(_ sender: Any) {
        self.delegate?.DetailButtonDidTap(self)
        
    }
    
}
