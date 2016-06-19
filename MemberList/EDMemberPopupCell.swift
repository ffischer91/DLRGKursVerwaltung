//
//  EDMemberPopupCell.swift
//  MemberList
//
//  Created by flo on 19.06.16.
//  Copyright © 2016 flo. All rights reserved.
//

import UIKit

class EDMemberPopupCell: UITableViewCell {

    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
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
    
    @IBOutlet weak var switch_MemberPopup: UISwitch!
    
    @IBAction func switchChange_MemberPopup(sender: UISwitch) {
        
        if(switch_MemberPopup.on){
            member!.addEvent(event!)
            updateDB()
        }else {
            if(member?.hasEvents!.count>0){
                if(member!.hasEvents!.containsObject(event!)){
                    member!.removeEvent(event!)
                    updateDB()
                }
            }
        }
    }
  
    
    func setData(){
        if(member != nil){
            //switch default aus!
            switch_MemberPopup.on = false
            //labels füllen
            label_firstname.text = member!.firstname
            label_surename.text = member!.surname
            //Bild setzen
            if(member!.image != nil){
                imageView_Member.contentMode = .ScaleAspectFit
                imageView_Member.image = UIImage(data: member!.image!)
            }
            // gucken ob member schon Mitglied von Event ist
            let set = member!.hasEvents                    //NSSet
            if (set?.count>0){
                if (set!.containsObject(event!)){
                    switch_MemberPopup.on = true
                }
            }
  
        }
    }
    
    func updateDB(){
        do {
            try managedObjectContext.save()
            print("update a Member(), saved finished \(event)")
        } catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
    }
}
