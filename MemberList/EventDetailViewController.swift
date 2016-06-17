//
//  EventDetailViewController.swift
//  MemberList
//
//  Created by flo on 17.06.16.
//  Copyright © 2016 flo. All rights reserved.
//

import UIKit
import CoreData

class EventDetailViewController: UIViewController, UITextFieldDelegate{

    var event: Event?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tF_name.delegate = self
        tf_location.delegate = self
        self.viewAllgemein.hidden = false
        self.viewTermine.hidden = true
        
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var viewAllgemein: UIView!
    @IBOutlet weak var viewTermine: UIView!

    @IBAction func segmentChange(sender: AnyObject)
    {
        switch sender.selectedSegmentIndex {
        case 0:
            self.viewAllgemein.hidden = false
            self.viewTermine.hidden = true
        case 1:
            self.viewAllgemein.hidden = true
            self.viewTermine.hidden = false
        default:
            print("default")
        }
    }
    
    @IBOutlet weak var tF_name: UITextField!
    @IBOutlet weak var tf_location: UITextField!

    
    @IBOutlet weak var dP_date: UIDatePicker!
    @IBOutlet weak var dP_begin: UIDatePicker!
    @IBOutlet weak var dP_end: UIDatePicker!
    
    
    func textFieldDidEndEditing(textField: UITextField) {
        // update data
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    
    func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        
       // dateTextField.text = dateFormatter.stringFromDate(sender.date)
        
    }


}
