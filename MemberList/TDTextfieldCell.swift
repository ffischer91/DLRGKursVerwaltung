//
//  TDTextfieldCell.swift
//  MemberList
//
//  Created by flo on 14.06.16.
//  Copyright © 2016 flo. All rights reserved.
//

import UIKit

class TDTextfieldCell: UITableViewCell, Reusable{

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var firstnameTF: UITextField!

    @IBOutlet weak var licenseIDTF: UITextField!
    @IBOutlet weak var surnameTF: UITextField!
}
