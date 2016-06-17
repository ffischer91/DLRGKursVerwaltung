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
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var fetchedResultController: NSFetchedResultsController = NSFetchedResultsController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsSelection = false
        
        

        // Uncomment the following line to preserve selection between presentations
         self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(animated: Bool) {
        
//        if(trainer != nil){
//            setDataToCells()
//        }
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
            return 8
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == 1){
            return "Eingetragene Termine \(section)"
        }
        else{
           return nil
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            cellTrainerInfo = tableView.dequeueReusableCell(indexPath: indexPath) as TDTextfieldCell
            if(trainer != nil){
                cellTrainerInfo!.firstnameTF.text = trainer?.firstname
                cellTrainerInfo!.surnameTF.text = trainer?.surname
                cellTrainerInfo!.licenseIDTF.text = trainer?.licenseID
            }
            return cellTrainerInfo!
        }
        else{
            let cellevent = tableView.dequeueReusableCell(indexPath: indexPath) as TDEventTabCell
            return cellevent
        }
    }
    

   /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */


   /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
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
