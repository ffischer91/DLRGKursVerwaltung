//
//  ViewController.swift
//  MemberList
//
//  Created by flo on 31.05.16.
//  Copyright © 2016 flo. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource{
    
    let CellReuseIdentifier = "Cell"
    let ShowDetailMemberSegue = "Show Detail Member"

    var members = [Member]()    //[NSManagedObject]()
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func addBtn(sender: AnyObject) {
        let alert = UIAlertController(title: "New Name",
                                      message: "Add a new name",
                                      preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .Default, handler: { (action:UIAlertAction) -> Void in
                                        
                       let textField = alert.textFields!.first
                       self.saveName(textField!.text!)
                       self.tableView.reloadData()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel",                                  style: .Default) { (action: UIAlertAction) -> Void in
        }
        
        alert.addTextFieldWithConfigurationHandler {
            (textField: UITextField) -> Void in
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert,animated: true,completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Teilnehmer"
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //1
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let fetchRequest = NSFetchRequest(entityName: "Member")
        
        //3
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            members = results as! [Member]
        } catch let error as NSError {
            print("Could not fetch Members \(error), \(error.userInfo)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return members.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")
        let member = members[indexPath.row]

        cell!.textLabel!.text = member.firstname //.valueForKey("firstname") as? String
        return cell!
    }
    

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == ShowDetailMemberSegue{
            if let memberVC = segue.destinationViewController as? MemberViewController{
                        //Todo
            }
        }
    }


    func saveName(firstname: String) {
        //1
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
    
        //2
        let entity =  NSEntityDescription.entityForName("Member", inManagedObjectContext:managedContext)
        let member = Member(entity: entity!,insertIntoManagedObjectContext: managedContext)
    
        //3
        //member.setValue(firstname, forKey: "firstname")
        member.firstname = firstname
    
        //4
        do {
            try managedContext.save()
            //5
            members.append(member)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    
}
