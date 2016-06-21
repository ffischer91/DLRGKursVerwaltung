//
//  ImportViewController.swift
//  MemberList
//
//  Created by flo on 20.06.16.
//  Copyright © 2016 flo. All rights reserved.
//

import UIKit
import FileBrowser
import SwiftCSV
import CoreData

class ImportViewController: UIViewController {

    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var elementCounter = 0
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var btn_add: UIBarButtonItem!
    
    @IBAction func btn_add_action(sender: AnyObject) {
        let fileBrowser = FileBrowser()
        self.presentViewController(fileBrowser, animated: true, completion: nil)
        fileBrowser.didSelectFile = { (file: FBFile) -> Void in
            print(file.filePath)
            self.url =  file.filePath
        }
        
    }
    
    @IBAction func btn_import_action(sender: AnyObject) {
        print("IMPORT")
        importData()
    }

    
    var url: NSURL?{
        didSet {
            if(textView != nil){
                self.textView.text = "File to import: \n\n \(self.url!)"
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //self.textView.scrollRangeToVisible(NSRange(location:0, length:0))
        self.textView.scrollsToTop = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.title = "Import"
        if(url != nil){
            self.textView.text = "Received: \n\n \(self.url!)"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // True == erfolgreich
    // false == kein Import möglich
    func importData()->Bool{
        
        do {
            let csv = try CSV(url: url!, delimiter: ";", encoding: NSWindowsCP1254StringEncoding, loadColumns: true)
            
            print (csv.header)  // 1. Zeile
            //let event = Event(name: array[1], location: "", insertIntoManagedObjectContext: managedObjectContext)
            
            var bool_event: Bool = false
            var marker_event_date = 0
            var bool_event_date = false
            var marker_member  = 0
            var bool_member = false
            var i = 0
        
            
            
            // sehr einfache Überprüfung des Files
            let header = csv.header
            if(header[ 0 ] == "Veranstaltung" && header[ 1 ] == "Name" && header[ 2 ] == "Ort"){
                bool_event = true
            }
            else{
                self.textView.text = "kein Import möglich: \n\n CSV-Datei ist nicht kompatibel"
                return false
            }
            var event: Event?
            
            
            csv.enumerateAsArray { data in
                
                if(data[0] == "Veranstaltungstermine"){
                    marker_event_date = i + 1
                    bool_event_date = true
                    
                }else if(data[0] == "Teilnehmer"){
                    marker_member = i + 1
                    bool_event_date = false
                    bool_member = true
                }
                if(bool_event){
                    event = Event(name: data[1], location: data[2], insertIntoManagedObjectContext: self.managedObjectContext)
                    bool_event = false
                    self.elementCounter += 1
                }else if(i >= marker_event_date && bool_event_date){
                    _ = Event_Date(event: event!, beginDate: data[1] , beginTime: data[2], endTime: data[3], insertIntoManagedObjectContext: self.managedObjectContext)
                    self.elementCounter += 1

                    
                }else if(i >= marker_member && bool_member){
                    let member = Member(firstname: data[2], surname: data[1], birth: data[3], street: data[4], plz: data[5], city: data[6], insertIntoManagedObjectContext: self.managedObjectContext)
                    member.addEvent(event!)
                    self.elementCounter += 1

                }

                i += 1  //merker
            }
            
        } catch {
            self.textView.text = "kein Import möglich: \n\n CSV-Datei ist nicht kompatibel"
            return false
        }
        
        updateData()
        return true
    }
    
    
    
    func updateData(){
        do {
            try managedObjectContext.save()
            print(" Import..., saved finished ")       //\(event)")
            self.textView.text.appendContentsOf("\n Import erfolgreich: \n\n insgesamt \(self.elementCounter) Elemente importiert!")
            
        } catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    


    
}
