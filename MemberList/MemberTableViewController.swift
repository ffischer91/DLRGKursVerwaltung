//
//  MemberTableViewController.swift
//  MemberList
//
//  Created by flo on 31.05.16.
//  Copyright © 2016 flo. All rights reserved.
//

import UIKit
import CoreData

class MemberTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    
    //public var context: NSManagedObjectContext!
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var fetchedResultController: NSFetchedResultsController = NSFetchedResultsController()
    
       
    var selectedmember: Member?
    var selectedNSManagedObject :NSManagedObject?
    
    var members = [Member]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    @IBAction func addBtn(sender: AnyObject) {
        selectedmember = nil

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Teilnehmer"
        //tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        fetchedResultController = getFetchedResultController()
        fetchedResultController.delegate = self
        do{
            try fetchedResultController.performFetch()
        } catch let error as NSError {
            print("Could not fetch Members \(error), \(error.userInfo)")
        }
   }
    

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if segue.identifier == Constants.ShowNewMemberSegue{
            if let memberVC = segue.destinationViewController as? MemberDetailTabViewController{
                memberVC.member = nil
            }
        }
        else if segue.identifier == Constants.ShowDetailMemberSegue{
            let indexPath = tableView.indexPathForSelectedRow!
            let selectedMember = fetchedResultController.objectAtIndexPath(indexPath) as! Member
            if let memberTVC = segue.destinationViewController as? MemberDetailTabViewController{
                memberTVC.member = selectedMember
            }
            
        }
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    func getFetchedResultController() -> NSFetchedResultsController {
        fetchedResultController = NSFetchedResultsController(fetchRequest: memberFetchRequest(), managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultController
    }
    
    func memberFetchRequest() -> NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: Constants.EntityMember)
        let sortDescriptor = NSSortDescriptor(key: "surname", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        let numberOfSections = fetchedResultController.sections?.count
        return numberOfSections!
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRowsInSection = fetchedResultController.sections?[section].numberOfObjects
        return numberOfRowsInSection!
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.CellReuseIdentifier, forIndexPath: indexPath) as! MemberTableViewCell
        let member = fetchedResultController.objectAtIndexPath(indexPath) as! Member
        cell.firstnameLabel.text = member.firstname
        cell.surenameLabel.text = member.surname
        if(member.birth != nil){
            cell.birthLabel.text = member.birth!.date_toString_Date()
        }
        // was tun wenn nil?
        if(member.image != nil){
            cell.memberImageView.image = UIImage(data: member.image!)
            cell.memberImageView.contentMode = .ScaleAspectFit
        }
        else{
            print("kein Bild")
        }

        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let managedObject:NSManagedObject = fetchedResultController.objectAtIndexPath(indexPath) as! NSManagedObject
        managedObjectContext.deleteObject(managedObject)
        
        do{
            try managedObjectContext.save()
        } catch let error as NSError {
            print("Could not save Members \(error), \(error.userInfo)")
        }

    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.reloadData()
    }
    
    
    
    
    
}


