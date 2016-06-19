//
//  EDMemberTableCell.swift
//  MemberList
//
//  Created by flo on 19.06.16.
//  Copyright © 2016 flo. All rights reserved.
//

import UIKit

class EDMemberTableCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    var member: Member?
    
    @IBOutlet weak var label_firstname: UILabel!
    @IBOutlet weak var label_surname: UILabel!
    
    @IBOutlet weak var imageView_Member: UIImageView!
    
    @IBOutlet weak var switch_Member: UISwitch!
    
    func setData(){
        if(member != nil){
            label_firstname.text = member!.firstname
            label_surname.text = member!.surname
            if(member!.image != nil){
                imageView_Member.contentMode = .ScaleAspectFit
                imageView_Member.image = UIImage(data: member!.image!)
            }
        }
    }
}
