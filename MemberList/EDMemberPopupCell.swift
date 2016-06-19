//
//  EDMemberPopupCell.swift
//  MemberList
//
//  Created by flo on 19.06.16.
//  Copyright © 2016 flo. All rights reserved.
//

import UIKit

class EDMemberPopupCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var member: Member?
    var event: Event?
    
    @IBOutlet weak var label_firstname: UILabel!
    
    @IBOutlet weak var label_surename: UILabel!

    @IBOutlet weak var imageView_Member: UIImageView!
    
    @IBOutlet weak var switch_MemberPopup: NSLayoutConstraint!
}
