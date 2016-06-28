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
        title = "Ausbilder"
        
        fetchedResultController = getFetchedResultController()
        fetchedResultController.delegate = self
        
        do{
            try fetchedResultController.performFetch()
        } catch let error as NSError {
            print("Could not fetch Trainer \(error), \(error.userInfo)")
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Table view data source

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // leere Detail Ansicht
        if segue.identifier == Constants.ShowNewTrainerSegue{
            if let trainerVC = segue.destinationViewController as? TrainerDetailController{
                trainerVC.trainer = nil
            }
        }   // Informationen setzen in Detail Ansicht
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
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        let numberOfSections = fetchedResultController.sections!.count
        return numberOfSections
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRowsInSection = fetchedResultController.sections?[section].numberOfObjects
        return numberOfRowsInSection!
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       // let cell = tableView.dequeueReusableCellWithIdentifier(Constants.CellTrainerInfo, forIndexPath: indexPath) as! TrainerTableViewCell
        let cell = tableView.dequeueReusableCell(indexPath: indexPath) as TrainerTableViewCell
        let trainer = fetchedResultController.objectAtIndexPath(indexPath) as! Trainer
        cell.label_firstname.text = trainer.firstname
        cell.label_surname.text = trainer.surname   
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

    
    //MARK: - Core Data
    
    func getFetchedResultController() -> NSFetchedResultsController {
        fetchedResultController = NSFetchedResultsController(fetchRequest: trainerFetchRequest(), managedObjectContext: managedObjectContext, sectionNameKeyPath: "surname" , cacheName: nil)
        return fetchedResultController
    }
    
    func trainerFetchRequest() -> NSFetchRequest {
        
        let fetchRequest = NSFetchRequest(entityName: Constants.EntityTrainer)
        let primarySortDescriptor = NSSortDescriptor(key: "surname", ascending: true)
        
        fetchRequest.sortDescriptors = [primarySortDescriptor]
        
        return fetchRequest
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.reloadData()
    }

}
