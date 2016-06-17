//
//  EventTableController.swift
//  MemberList
//
//  Created by flo on 02.06.16.
//  Copyright © 2016 flo. All rights reserved.
//

import UIKit

class EventTableHeaderController: UITableViewController {

    let eventHeaders = ["Allgemein", "Termine", "Teilnehmer", "Helfer" ]
    var selectedEventHeadCell = 0
    var event: Event?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Veranstaltung"
        selectedEventHeadCell = Constants.Cell_Allgemein
        performSegueWithIdentifier(Constants.ShowDetailEvent, sender: tableView)
        
    }
    
    override func viewWillAppear(animated: Bool) {
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventHeaders.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.CellEventHeaders, forIndexPath: indexPath)
        cell.textLabel?.text = eventHeaders[indexPath.row]
        return cell
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        selectedEventHeadCell = indexPath.row
        return indexPath
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //var destination: UIViewController?
        
    if segue.identifier == Constants.ShowDetailEvent {
            //let indexPath = tableView.indexPathForSelectedRow
            switch selectedEventHeadCell{
            case Constants.Cell_Allgemein:
                print("Allgemein")
                segue.destinationViewController.performSegueWithIdentifier(Constants.ShowDetailEventAllgemein, sender: sender)
               //let destination = segue.destinationViewController.contentViewController as? EventGeneralController
            case Constants.Cell_Termine:
                print("Termine")
                segue.destinationViewController.performSegueWithIdentifier(Constants.ShowDetailEventTermin, sender: sender)
            case Constants.Cell_Teilnehmer:
                print("Teilnehmer")
            case Constants.Cell_Helfer:
                print("Helfer")
            default:
                print("nix ausgewählt")
            }
        }
    }
    
}

extension UIViewController{
    var contentViewController : UIViewController {
        if let navCon = self as? UINavigationController{
            return navCon.visibleViewController!
        }else{
            return self
        }
    }
}
