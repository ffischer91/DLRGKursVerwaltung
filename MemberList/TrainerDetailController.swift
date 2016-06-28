//
//  TrainerDetailController.swift
//  MemberList
//
//  Created by flo on 09.06.16.
//  Copyright © 2016 flo. All rights reserved.
//

import UIKit
import CoreData

class TrainerDetailController: UITableViewController {

    var trainer: Trainer?
    var cellTrainerInfo: TDTextfieldCell?
    var trainer_EventDates : [Event_Date] = [ ]
    var eventDateCount = 0
    
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var fetchedResultController: NSFetchedResultsController = NSFetchedResultsController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsSelection = false

        // Uncomment the following line to preserve selection between presentations
         self.clearsSelectionOnViewWillAppear = false

        if(trainer != nil && trainer?.hasEvent_Date != nil){
            let set = trainer!.hasEvent_Date                            //NSSet
            trainer_EventDates = set!.allObjects as! [Event_Date]      // Array
            //print(trainer_EventDates)
            eventDateCount = trainer!.hasEvent_Date!.count
            //tableView.reloadData()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func btn_Save(sender: AnyObject) {
        if(trainer != nil){
            editTrainer()
        }else{
            createTrainer()
        }
        navigationController?.popViewControllerAnimated(true)
    }
    
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // 2 Sections
        // erste:   Trainer Details
        // zweite:  Trainer Events
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0){
            return 1        // eine Celle für Details
        }else{
            return eventDateCount       // eine Zelle pro Event
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == 1){
            return Constants.TrainerHeaderTermine //"Eingetragene Termine"       // \(section)"
        }
        else{
           return nil   // erste Section, kein Titel
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {     // Trainer Details
            cellTrainerInfo = tableView.dequeueReusableCell(indexPath: indexPath) as TDTextfieldCell
            if(trainer != nil){
                setInfoToCell()
            }
            return cellTrainerInfo!
        }
        else{       // section == 1, Trainer Events
            let cellevent = tableView.dequeueReusableCell(indexPath: indexPath) as TDEventTabCell
            cellevent.label_EventBeginn.text = trainer_EventDates[indexPath.row].beginn!.date_toString_DateTime()
            cellevent.label_EventName.text = trainer_EventDates[indexPath.row].hasEvent!.name
            return cellevent
        }
    }
    




  
    // MARK: - Data
    
    func setInfoToCell(){
        
        cellTrainerInfo!.firstnameTF.text = trainer?.firstname
        cellTrainerInfo!.surnameTF.text = trainer?.surname
        cellTrainerInfo!.licenseIDTF.text = trainer?.licenseID
        
    }
    
    func getInfoOfCells(){
        trainer!.firstname = cellTrainerInfo!.firstnameTF.text
        trainer!.surname = cellTrainerInfo!.surnameTF.text
        trainer!.licenseID = cellTrainerInfo!.licenseIDTF.text
    }
    
    func createTrainer(){
        let entityDescription = NSEntityDescription.entityForName(Constants.EntityTrainer, inManagedObjectContext: managedObjectContext)
        trainer = Trainer(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext)
        
        getInfoOfCells()        // geht alle Zeilen durch und sammelt setzt die Infos in member!
        
        do {
            try managedObjectContext.save()
            //print("createTrainer(), saved finished: \(trainer)")
            
        } catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    
    func editTrainer(){
        print("editTrainer()")

        getInfoOfCells()        // geht alle Zeilen durch und sammelt setzt die Infos in member!
        
        do {
            try managedObjectContext.save()
        } catch let error as NSError  {
            print("Could not edit Trainer \(error), \(error.userInfo)")
        }
    }

}
