//
//  MDSwitchCell.swift
//  MemberList
//
//  Created by flo on 06.06.16.
//  Copyright © 2016 flo. All rights reserved.
//

import UIKit

class MDSwitchCell: UITableViewCell, Reusable{
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var bool_switch: UISwitch!
    
}
