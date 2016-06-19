//
//  EventDetailViewController.swift
//  MemberList
//
//  Created by flo on 17.06.16.
//  Copyright © 2016 flo. All rights reserved.
//

import UIKit
import CoreData

class EventDetailViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate, CellSwichChangedProtocol{

    var event: Event?
    var selectedEvent_Date: Event_Date?
    var eventDates: [ Event_Date] = [ ]
    var eventDates_Set : NSSet?
    let dateFormatter = NSDateFormatter()
    
    var trainer: Trainer?
    var eventDatePicker: Event_Date?
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var fetchedRSC_Trainer: NSFetchedResultsController = NSFetchedResultsController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tF_name.delegate = self
        tf_location.delegate = self
        self.viewAllgemein.hidden = false
        self.viewTermine.hidden = true
        self.viewAusbilder.hidden = true
        self.viewTeilnehmer.hidden = true
        
        dP_begin.date = NSDate() //current date
        dP_end.date = NSDate() //current date
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        //
        self.trainerTableView.delegate = self
        self.trainerTableView.dataSource = self
        fetchedRSC_Trainer = getFetchedRSC_Trainer()
        fetchedRSC_Trainer.delegate = self
        do{
            try fetchedRSC_Trainer.performFetch()
        } catch let error as NSError {
            print("Could not fetch Trainer \(error), \(error.userInfo)")
        }
        
        
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"

        if(event != nil){
            setDataToView()
    //        eventDates_Set = event!.eventHasDates
    //        eventDates = eventDates_Set?.allObjects as! [Event_Date]
        }
        
        
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var viewAllgemein: UIView!
    @IBOutlet weak var viewTermine: UIView!
    @IBOutlet weak var viewAusbilder: UIView!
    @IBOutlet weak var viewTeilnehmer: UIView!
    

    @IBAction func segmentChange(sender: AnyObject)
    {
        switch sender.selectedSegmentIndex {
        case 0:
            self.viewAllgemein.hidden = false
            self.viewTermine.hidden = true
            self.viewAusbilder.hidden = true
            self.viewTeilnehmer.hidden = true
        case 1:
            self.viewAllgemein.hidden = true
            self.viewTermine.hidden = false
            self.viewAusbilder.hidden = true
            self.viewTeilnehmer.hidden = true
        case 2:
            self.viewAllgemein.hidden = true
            self.viewTermine.hidden = true
            self.viewTeilnehmer.hidden = false
            self.viewAusbilder.hidden = true
        case 3:
            self.viewAllgemein.hidden = true
            self.viewTermine.hidden = true
            self.viewTeilnehmer.hidden = true
            self.viewAusbilder.hidden = false
        default:
            print("default")
        }
    }
    
    @IBOutlet weak var tF_name: UITextField!
    @IBOutlet weak var tf_location: UITextField!

    
    @IBOutlet weak var dP_begin: UIDatePicker!
    @IBOutlet weak var dP_end: UIDatePicker!
    
    
    @IBAction func btn_addDate(sender: AnyObject) {
        var date = dP_begin.date
        //let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"

        let beginString = dateFormatter.stringFromDate(date)
        date = dP_end.date
        let endString = dateFormatter.stringFromDate(date)
        
        selectedEvent_Date = Event_Date(event: event!, begin: dP_begin.date, end: dP_end.date, insertIntoManagedObjectContext: managedObjectContext)
        updateEvent()   // evtl. event == nil
        event!.addEvent_Date(selectedEvent_Date!)
        updateEvent()       // infos abspeichern
        
        
        print(beginString)
        print(endString)
        tableView.reloadData()
        
    }
    
    //MARK: Textfield
    func textFieldDidEndEditing(textField: UITextField) {
        updateEvent()
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
    
    @IBOutlet weak var label_AusbilderDate: UILabel!
    
    @IBOutlet weak var stepper_Ausbilder: UIStepper!
    
    @IBAction func stepper_Ausbilder_Changed(sender: UIStepper) {
        if(eventDates.count > 1){
            eventDatePicker = eventDates[Int(stepper_Ausbilder.value)]
            label_AusbilderDate.text = dateFormatter.stringFromDate(eventDatePicker!.beginn!)
            trainerTableView.reloadData()
        }
    }
    
    
    
    func setDataToView(){
        tF_name.text = event!.name
        tf_location.text = event!.location
        
        eventDates = event!.eventHasDates!.allObjects as! [Event_Date]
        stepper_Ausbilder.minimumValue = 0.0
        stepper_Ausbilder.maximumValue = Double(eventDates.count - 1)
        stepper_Ausbilder.stepValue = 1.0
        
        if(eventDates.count > 0){
            label_AusbilderDate.text = dateFormatter.stringFromDate(eventDates[0].beginn!)
            let eD = eventDates[ 0 ]
            eventDatePicker = eD
        }else{
            label_AusbilderDate.text = ""
        }
    }
    
    //MARK: DateTable
    
    @IBOutlet weak var tableView: UITableView!
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if(tableView == self.trainerTableView){
            guard let sectionCount = fetchedRSC_Trainer.sections?.count else {
                return 0
            }
            return sectionCount
        }
        else{
            return 1
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print("Cells.count:  \(cells.count)")
         if(tableView == self.tableView){
            if (event == nil){
                return 0
            }else{
                print("EventHasDates.Count: \(event!.eventHasDates!.count)")
                return event!.eventHasDates!.count
            }
         }else if( tableView == self.trainerTableView){
            guard let sectionData = fetchedRSC_Trainer.sections?[section] else {
                return 0
            }
            return sectionData.numberOfObjects
         }
         else{
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if(tableView == self.tableView){
            let cell = tableView.dequeueReusableCellWithIdentifier(Constants.CellEDDate)
            eventDates = event!.eventHasDates!.allObjects as! [Event_Date]
            let eventDate = eventDates[indexPath.row]
        
            let beginString = dateFormatter.stringFromDate(eventDate.beginn!)
            let endString = dateFormatter.stringFromDate(eventDate.end!)
        
            setDataToView() //Stepper muss aktualisiert werden

            cell!.textLabel!.text = beginString + "  -  " + endString
            return cell!
        }
        else if(tableView == self.trainerTableView){
            trainer = fetchedRSC_Trainer.objectAtIndexPath(indexPath) as? Trainer
            let cell = tableView.dequeueReusableCellWithIdentifier(Constants.CellEDTrainer) as! EDTrainerTableCell
            cell.label_name.text = trainer!.firstname! + ", " + trainer!.surname!
            cell.switch_present.on = false
            cell.trainer = trainer
            if (trainer!.hasEvent_Date?.count > 0 && eventDatePicker != nil){
                if(trainer!.hasEvent_Date!.containsObject(eventDatePicker!)){
                    cell.switch_present.on = true
                }
            }
           
            cell.cellDelegate = self
            return cell
        }
        else{
            
            return UITableViewCell()
        }
    }
    
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if(tableView == self.tableView){
            print("Event Count: \(eventDates.count)")
            selectedEvent_Date = eventDates[indexPath.row]
            print(selectedEvent_Date)
            event!.removeEvent_Date(selectedEvent_Date!)
            tableView.reloadData()
            setDataToView() //Stepper muss aktualisiert werden
        }
    }

    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
         if(tableView == self.tableView){
            return true
         }else{
            return false
        }
    }

    //MARK: Trainer Table
    
    @IBOutlet weak var trainerTableView: UITableView!
    
    
    func switchChanged(sender: EDTrainerTableCell){
        trainer = sender.trainer
        
        if (sender.switch_present.on){  //JA
            trainer!.addEvent_Date(eventDatePicker!)
            updateEvent()
        }else{  //NEIN
            trainer!.removeEvent_Date(eventDatePicker!)
            updateEvent()
        }
        print("von Drüben aufgerufen")
    }
    
    func trainerFetchRequest() -> NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: Constants.EntityTrainer)
        let primarySortDescriptor = NSSortDescriptor(key: "surname", ascending: true)
        fetchRequest.sortDescriptors = [primarySortDescriptor]
        
        return fetchRequest
    }
    
    func getFetchedRSC_Trainer() -> NSFetchedResultsController {
        fetchedRSC_Trainer = NSFetchedResultsController(fetchRequest: trainerFetchRequest(), managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedRSC_Trainer
    }
    
    
    
    //MARK: Update Data
    
    func updateEvent(){
        if event == nil{
            //neues Event
            let entityDescription = NSEntityDescription.entityForName(Constants.EntityEvent, inManagedObjectContext: managedObjectContext)
            event = Event(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext)
        }
        getDataFromView()   //Daten Holen
            
        do {
            try managedObjectContext.save()
            print("updateEvent(), saved finished \(event)")
        } catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
    }


    func getDataFromView(){
        event?.name = tF_name.text
        event?.location = tf_location.text
    }
    
}
