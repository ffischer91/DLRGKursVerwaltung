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
            let set = trainer!.hasEvent_Date                        //NSSet
            trainer_EventDates = set!.allObjects as! [Event_Date]      // Array
            print(trainer_EventDates)
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
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0){
            return 1
        }else{
//            let set = trainer!.hasEvent_Date                        //NSSet
//            trainer_EventDates = set!.allObjects as! [Event_Date]      // Array
//            //print(trainer_EventDates)
//            eventDateCount = trainer!.hasEvent_Date!.count
//            tableView.reloadData()
            
            return eventDateCount
            //return trainer!.hasEvent_Date!.count
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == 1){
            return "Eingetragene Termine"       // \(section)"
        }
        else{
           return nil
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            cellTrainerInfo = tableView.dequeueReusableCell(indexPath: indexPath) as TDTextfieldCell
            if(trainer != nil){
                setInfoToCell()
            }
            return cellTrainerInfo!
        }
        else{
            let cellevent = tableView.dequeueReusableCell(indexPath: indexPath) as TDEventTabCell
            cellevent.label_EventBeginn.text = trainer_EventDates[indexPath.row].beginn!.date_toString_DateTime()
            cellevent.label_EventName.text = trainer_EventDates[indexPath.row].hasEvent!.name
            //cellevent.label_EventName.text = "dsfaewgfa"
            return cellevent
        }
    }
    

    func setInfoToCell(){
        
        cellTrainerInfo!.firstnameTF.text = trainer?.firstname
        cellTrainerInfo!.surnameTF.text = trainer?.surname
        cellTrainerInfo!.licenseIDTF.text = trainer?.licenseID
        
    }


  
    // MARK: - Data

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
            print("createTrainer(), saved finished: \(trainer)")
            
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
