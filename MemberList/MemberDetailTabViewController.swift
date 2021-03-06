//
//  MemberDetailTabViewController.swift
//  MemberList
//
//  Created by flo on 06.06.16.
//  Copyright © 2016 flo. All rights reserved.
//

import UIKit
import CoreData

class MemberDetailTabViewController: UITableViewController, UITextFieldDelegate, UITextViewDelegate ,ShowPickerProtocol{
    
    var cells: [UITableViewCell] = []       // hält alle Cells der Table nachdem sie angelgt wurden
    
    var member: Member?
    
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var fetchedResultController: NSFetchedResultsController = NSFetchedResultsController()
    
    
    override func viewDidLoad() {
        tableView.allowsSelection = false
    }
    
    override func viewDidAppear(animated: Bool) {

        if(member != nil){
            setDataToCells()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    

    //MARK: Button Save
    
    @IBAction func btn_Save(sender: AnyObject) {
        if(member != nil){  // wenn Member übergeben -> nur bearbeiten
            editMember()
        }else{              // kein Member übergeben -> neuer Member
            createMember()
        }
        navigationController?.popViewControllerAnimated(true)
    }
    
    
    //MARK: Table View
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        // Höhe der Zellen anpassen
        switch indexPath.row {
        case 5:
            return 275.0
        case 7:
            return 140.0
        default:
            return tableView.rowHeight
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == 1){
            return Constants.HeaderSecEventsMember //"Eingetragene Veranstaltungen"
        }
        else{
            return nil
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var result = Constants.MAX_CELLS_MEMBER   //8       // section == 0
        if(section == 1){                                   // Events pro Member
            if( member != nil && member!.hasEvents != nil ){
                result = member!.hasEvents!.count           // Anzahl Events
            }else{
                result = 0                                  // keine Events
            }
        }
        return result
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // legt jede cell in einen Array ab, damit sie später auch wieder ausgelesen werden können
        if (indexPath.section == 0)
        {
            switch indexPath.row {
                case 0,1,2,3,4:
                    let cell = tableView.dequeueReusableCell(indexPath: indexPath) as MDTextfieldCell
                    cell.label.text = Constants.CellMDLableText[ indexPath.row] // Labeltext setzen
                    cell.textField.delegate = self                              // Delegate setzen
                    cells.append(cell)                                          // in Array anhängen
                    return cell
                case  5:       //Photo
                    let cell = tableView.dequeueReusableCell(indexPath: indexPath) as MDPhotoCell
                    cell.delegate = self;
                    cells.append(cell)
                    return cell
                case 6:         //Switch
                    let cell = tableView.dequeueReusableCell(indexPath: indexPath) as MDSwitchCell
                    cell.label.text = Constants.CellMDLableText[ indexPath.row]
                    cells.append(cell)
                    return cell
                case 7:     // TextView=>Notiz
                    let cell = tableView.dequeueReusableCell(indexPath: indexPath) as MDTextViewCell
                    cell.label.text = Constants.CellMDLableText[ indexPath.row]
                    cell.textView.delegate = self
                    cells.append(cell)
                    return cell
                default:
                    let cell = tableView.dequeueReusableCell(indexPath: indexPath) as MDTextfieldCell
                    cell.label.text = Constants.Default //"Default"
                    return cell
                }
        }else{
            let cell = tableView.dequeueReusableCell(indexPath: indexPath) as MDTableCell
            let events = member!.hasEventsAsArray()
            cell.label_name.text = events[indexPath.row].name
            return cell
        }
    }
    
    
    // MARK: Data 
    
    func createMember(){
        let entityDescription = NSEntityDescription.entityForName(Constants.EntityMember, inManagedObjectContext: managedObjectContext)
        member = Member(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext)
        
        getInfoOfCells()        // geht alle Zeilen durch und sammelt setzt die Infos in member!
        
        do {
            try managedObjectContext.save()
            
        } catch let error as NSError{
            //print("Could not save \(error), \(error.userInfo)")
            NSLog("Unresolved error when save Member\(error), \(error.userInfo)")
        }
    }
    
    
    func editMember(){
        getInfoOfCells()        // geht alle Zeilen durch und sammelt setzt die Infos in member!
        
        do {
            try managedObjectContext.save()
        } catch let error as NSError  {
            //print("Could not edit Member \(error), \(error.userInfo)")
            NSLog("Unresolved error when save Member\(error), \(error.userInfo)")
        }
    }

    // geht durch alle Cells und holt Informationen, speichert diese in Member
    func getInfoOfCells(){
        for i in 0 ... 7 {
            switch i {
            case 0:
                let cell = cells[ i ] as! MDTextfieldCell
                member!.firstname = cell.textField.text
            case 1:
                let cell = cells[ i ] as! MDTextfieldCell
                member!.surname = cell.textField.text
            case 2:
                let cell = cells[ i ] as! MDTextfieldCell
                member!.street = cell.textField.text
            case 3:
                let cell = cells[ i ] as! MDTextfieldCell
                member!.plz = cell.textField.text
            case 4:
                let cell = cells[ i ] as! MDTextfieldCell
                member!.city = cell.textField.text
            case 5:
                let cell = cells[ i ] as! MDPhotoCell
                if(cell.photo!.image != nil){
                    member!.image = UIImagePNGRepresentation(cell.photo!.image!)
                }
            case 6:
                let cellSwitch = cells[ i ] as! MDSwitchCell
                member!.dlrg = cellSwitch.bool_switch.on
            case 7:
                let cellText = cells[ i ] as! MDTextViewCell
                member!.note = cellText.textView.text
            default:
                //print("error: index ist bei: \(i)")
                NSLog("Unresolved error")
            }
        }
    }
    
    
    // setzt alle Informationen in den Cells
    func setDataToCells(){
        
        for i in 0 ..< cells.count {
            switch i {
            case 0:
                let cell = cells[ i ] as! MDTextfieldCell
                cell.textField.text = member!.firstname
            case 1:
                let cell = cells[ i ] as! MDTextfieldCell
                cell.textField.text = member!.surname
            case 2:
                let cell = cells[ i ] as! MDTextfieldCell
                cell.textField.text = member!.street
            case 3:
                let cell = cells[ i ] as! MDTextfieldCell
                cell.textField.text = member!.plz
            case 4:
                let cell = cells[ i ] as! MDTextfieldCell
                cell.textField.text = member!.city
            case 5:
                let cellPhoto = cells[ i ] as! MDPhotoCell
                if (member!.image != nil){
                    if(cellPhoto.imageIsNew){
                        // nicht neu von member laden
                        //member!.image = UIImagePNGRepresentation(cellPhoto.photo!.image!)
                        //cellPhoto.photo.image = cellPhoto.photo!.image!
                        cellPhoto.imageIsNew = false
                    }else{
                        cellPhoto.photo!.contentMode = .ScaleAspectFit
                        cellPhoto.photo.image = UIImage(data: member!.image!)
                    }
                }else{  // default Bild
                    cellPhoto.photo.image = UIImage(named: "person_swim")
                    editMember()
                }
            case 6:
                let cellSwitch = cells[ i ] as! MDSwitchCell
                cellSwitch.bool_switch.on = member!.dlrg!.boolValue
            case 7:
                let cellText = cells[ i ] as! MDTextViewCell
                cellText.textView.text = member!.note
            default:
                print("error: index ist bei: \(i)")
            }
        }
    }
    
    
    
    
    func loadNewScreen(controller: UIViewController) {
        self.presentViewController(controller, animated: true) { () -> Void in  }
    }
    
    func dismissNewScreen() -> Void{
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
// mit Return Taste aus Text View --> kein Zeilenumbruch möglich
//    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
//        if text == "\n"  // Recognizes enter key in keyboard
//        {
//            textView.resignFirstResponder()
//            return false
//        }
//        return true
//    }
    
}


protocol ShowPickerProtocol : NSObjectProtocol {
    func loadNewScreen(controller: UIViewController) -> Void
    func dismissNewScreen() -> Void
}


extension UITableView {
    final func registerReusableCell<T: UITableViewCell where T: Reusable>(cellType: T.Type) {
            self.registerClass(cellType.self, forCellReuseIdentifier: cellType.reuseIdentifier)
    }
 
    func dequeueReusableCell<T: UITableViewCell where T: Reusable>(indexPath indexPath: NSIndexPath) -> T {
        return self.dequeueReusableCellWithIdentifier(T.reuseIdentifier, forIndexPath: indexPath) as! T
    }
    
}



