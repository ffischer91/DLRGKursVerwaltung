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
    
// Labels zum setzen
    @IBOutlet weak var label_surname: UILabel!
    @IBOutlet weak var label_firstname: UILabel!
    

}
