//
//  EDTrainerTableCell.swift
//  MemberList
//
//  Created by flo on 18.06.16.
//  Copyright © 2016 flo. All rights reserved.
//

import UIKit

class EDTrainerTableCell: UITableViewCell {

    var cellDelegate: CellSwichChangedProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    var trainer: Trainer?
    
    @IBOutlet weak var label_name: UILabel!
    @IBOutlet weak var switch_present: UISwitch!
    
    
    @IBAction func switchTrainer_Changed(sender: UISwitch) {
        self.cellDelegate?.switchChanged(self)
    }
}

protocol CellSwichChangedProtocol {
    func switchChanged(sender: EDTrainerTableCell )
}
