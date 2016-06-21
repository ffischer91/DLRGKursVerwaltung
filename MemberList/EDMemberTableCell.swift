//
//  EDMemberTableCell.swift
//  MemberList
//
//  Created by flo on 19.06.16.
//  Copyright © 2016 flo. All rights reserved.
//

import UIKit

class EDMemberTableCell: UITableViewCell {

    var delegate: SwichChanged_Member?
    
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
    
    
    @IBAction func switch_Member_Changed(sender: AnyObject) {
        self.delegate?.switchChanged_Member(self)
    }
    
    func setData(){
        switch_Member.on = false
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

protocol SwichChanged_Member {
    func switchChanged_Member(sender: EDMemberTableCell )
}