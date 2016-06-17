//
//  TrainerTableViewController.swift
//  MemberList
//
//  Created by flo on 09.06.16.
//  Copyright © 2016 flo. All rights reserved.
//

import UIKit
import CoreData

class TrainerTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var fetchedResultController: NSFetchedResultsController = NSFetchedResultsController()
    
    
    var selectedTrainer: Trainer?
    var selectedNSManagedObject :NSManagedObject?
    
    var trainers = [Trainer]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        title = "Ausblider"
        //tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        fetchedResultController = getFetchedResultController()
        fetchedResultController.delegate = self
        do{
            try fetchedResultController.performFetch()
        } catch let error as NSError {
            print("Could not fetch Trainer \(error), \(error.userInfo)")
        }
        // Uncomment the following line to preserve selection between presentations
         //self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source


    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if segue.identifier == Constants.ShowNewTrainerSegue{
            if let trainerVC = segue.destinationViewController as? TrainerDetailController{
                trainerVC.trainer = nil
            }
        }
        else if segue.identifier == Constants.ShowDetailTrainerSegue{
            let indexPath = tableView.indexPathForSelectedRow!
            let selectedTrainer = fetchedResultController.objectAtIndexPath(indexPath) as! Trainer
            if let trainerVC = segue.destinationViewController as? TrainerDetailController{
                trainerVC.trainer = selectedTrainer
            }
            
        }
    }
    
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    func getFetchedResultController() -> NSFetchedResultsController {
        fetchedResultController = NSFetchedResultsController(fetchRequest: trainerFetchRequest(), managedObjectContext: managedObjectContext, sectionNameKeyPath: "surname" , cacheName: nil)
        return fetchedResultController
    }
    
    func trainerFetchRequest() -> NSFetchRequest {
//        let primarySortDescriptor = NSSortDescriptor(key: "classification.order", ascending: true)
//        let secondarySortDescriptor = NSSortDescriptor(key: "commonName", ascending: true)
//        animalsFetchRequest.sortDescriptors = [primarySortDescriptor, secondarySortDescriptor]
        
        
        let fetchRequest = NSFetchRequest(entityName: Constants.EntityTrainer)
        let primarySortDescriptor = NSSortDescriptor(key: "surname", ascending: true)
        //let secondarySortDescriptor = NSSortDescriptor(key: "classification.order", ascending: true)
        fetchRequest.sortDescriptors = [primarySortDescriptor]
        
        return fetchRequest
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        let numberOfSections = fetchedResultController.sections!.count
        return numberOfSections
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRowsInSection = fetchedResultController.sections?[section].numberOfObjects
        return numberOfRowsInSection!
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.CellTrainerInfo, forIndexPath: indexPath) as! TrainerTableViewCell
        let trainer = fetchedResultController.objectAtIndexPath(indexPath) as! Trainer
        cell.firstname.text = trainer.firstname
        cell.surname.text = trainer.surname
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let managedObject:NSManagedObject = fetchedResultController.objectAtIndexPath(indexPath) as! NSManagedObject
        managedObjectContext.deleteObject(managedObject)
        
        do{
            try managedObjectContext.save()
        } catch let error as NSError {
            print("Could not save Trainer \(error), \(error.userInfo)")
        }
        
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.reloadData()
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

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
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
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

}
