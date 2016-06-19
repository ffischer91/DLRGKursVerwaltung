//
//  EDMemberPopoverController.swift
//  MemberList
//
//  Created by flo on 19.06.16.
//  Copyright © 2016 flo. All rights reserved.
//

import UIKit
import CoreData

class EDMemberPopoverController: UITableViewController, NSFetchedResultsControllerDelegate{

    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var fetchedResultController: NSFetchedResultsController = NSFetchedResultsController()
    
    var event: Event?
    
    //var selectedMember: Member?
    var selectedNSManagedObject :NSManagedObject?
    
    var members = [Member]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Wählen Sie ihre Teilnehmer"
        
        fetchedResultController = getFetchedResultController()
        fetchedResultController.delegate = self
        
        do{
            try fetchedResultController.performFetch()
        } catch let error as NSError {
            print("Could not fetch Member \(error), \(error.userInfo)")
        }
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
    
    
    func getFetchedResultController() -> NSFetchedResultsController {
        fetchedResultController = NSFetchedResultsController(fetchRequest: memberFetchRequest(), managedObjectContext: managedObjectContext, sectionNameKeyPath: nil , cacheName: nil)
        return fetchedResultController
    }
    
    func memberFetchRequest() -> NSFetchRequest {
        
        let fetchRequest = NSFetchRequest(entityName: Constants.EntityMember)
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
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.CellEDMemberPopup, forIndexPath: indexPath) as! EDMemberPopupCell
        let member = fetchedResultController.objectAtIndexPath(indexPath) as! Member
        cell.event = event!
        cell.member = member
        cell.setData()
        return cell
    }
    
  
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.reloadData()
    }
    
    func dismissCompactPopoverPresentationController(){
        print("hallo")
    }

}