//
//  MemberTableViewCell.swift
//  MemberList
//
//  Created by flo on 01.06.16.
//  Copyright © 2016 flo. All rights reserved.
//

import UIKit
import CoreData

class MemberTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    @IBOutlet weak var firstnameLabel: UILabel!
    
    @IBOutlet weak var surenameLabel: UILabel!
    
    @IBOutlet weak var memberImageView: UIImageView!

    @IBOutlet weak var birthLabel: UILabel!
}
