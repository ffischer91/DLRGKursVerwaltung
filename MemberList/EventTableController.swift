//
//  EventTableController.swift
//  MemberList
//
//  Created by flo on 16.06.16.
//  Copyright © 2016 flo. All rights reserved.
//

import UIKit
import CoreData

class EventTableController: UITableViewController, NSFetchedResultsControllerDelegate {
    
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        var fetchedResultController: NSFetchedResultsController = NSFetchedResultsController()
        
        
        var selectedEvent: Event?
        var selectedNSManagedObject :NSManagedObject?
        
        var events = [Event]() {
            didSet {
                tableView.reloadData()
            }
        }
        
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            
            title = "Veranstaltungen"
            
            fetchedResultController = getFetchedResultController()
            fetchedResultController.delegate = self
            do{
                try fetchedResultController.performFetch()
            } catch let error as NSError {
                print("Could not fetch Event \(error), \(error.userInfo)")
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
            
//            if segue.identifier == Constants.ShowNewEventSegue{
//                if let eventVC = segue.destinationViewController as? EventDetailController{
//                    eventVC.event = nil
//                }
//            }
//            else if segue.identifier == Constants.ShowDetailEventSegue{
//                let indexPath = tableView.indexPathForSelectedRow!
//                let selectedEvent = fetchedResultController.objectAtIndexPath(indexPath) as! Event
//                if let eventVC = segue.destinationViewController as? EventDetailController{
//                    eventVC.event = selectedEvent
//                }
//            }
            if segue.identifier == Constants.ShowEventHeader{
                let indexPath = tableView.indexPathForSelectedRow!
                let selectedEvent = fetchedResultController.objectAtIndexPath(indexPath) as! Event
                if let eventVC = segue.destinationViewController as? EventTableHeaderController{
                      eventVC.event = selectedEvent
                }
            }
        }
        
        
        override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
            // Return false if you do not want the specified item to be editable.
            return true
        }
        
        
        func getFetchedResultController() -> NSFetchedResultsController {
            fetchedResultController = NSFetchedResultsController(fetchRequest: eventFetchRequest(), managedObjectContext: managedObjectContext, sectionNameKeyPath: "name" , cacheName: nil)
            return fetchedResultController
        }
        
        func eventFetchRequest() -> NSFetchRequest {
            //        let primarySortDescriptor = NSSortDescriptor(key: "classification.order", ascending: true)
            //        let secondarySortDescriptor = NSSortDescriptor(key: "commonName", ascending: true)
            //        animalsFetchRequest.sortDescriptors = [primarySortDescriptor, secondarySortDescriptor]
            
            
            let fetchRequest = NSFetchRequest(entityName: Constants.EntityEvent)
            let primarySortDescriptor = NSSortDescriptor(key: "name", ascending: true)
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
            let cell = tableView.dequeueReusableCellWithIdentifier(Constants.CellEventTable, forIndexPath: indexPath)
            let event = fetchedResultController.objectAtIndexPath(indexPath) as! Event
            cell.textLabel?.text = event.name
            return cell
        }
        
        override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
            let managedObject:NSManagedObject = fetchedResultController.objectAtIndexPath(indexPath) as! NSManagedObject
            managedObjectContext.deleteObject(managedObject)
            
            do{
                try managedObjectContext.save()
            } catch let error as NSError {
                print("Could not save Event \(error), \(error.userInfo)")
            }
            
        }
        
        func controllerDidChangeContent(controller: NSFetchedResultsController) {
            tableView.reloadData()
        }
    
}
