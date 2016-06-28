//
//  TrainerTableViewCell.swift
//  MemberList
//
//  Created by flo on 09.06.16.
//  Copyright © 2016 flo. All rights reserved.
//

import UIKit

class TrainerTableViewCell: UITableViewCell, Reusable {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var firstname: UILabel!
    
    @IBOutlet weak var surname: UILabel!
        

}
