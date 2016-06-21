//
//  Member.swift
//  MemberList
//
//  Created by flo on 31.05.16.
//  Copyright © 2016 flo. All rights reserved.
//

import Foundation
import CoreData

//@NSManaged var city: String?
//@NSManaged var dlrg: NSNumber?
//@NSManaged var firstname: String?
//@NSManaged var image: NSData?
//@NSManaged var note: String?
//@NSManaged var plz: String?
//@NSManaged var street: String?
//@NSManaged var surname: String?
//@NSManaged var birth: NSDate?
//@NSManaged var hasEvent_Date: NSSet?
//@NSManaged var hasEvents: NSSet?

class Member: NSManagedObject{

// Insert code here to add functionality to your managed object subclass


   override var description: String {
        return "[Member, First: \(self.firstname!), Surname: \(self.surname!) ]"
    }
    
    convenience init(firstname: String, surname: String, birth: String, street: String, plz: String, city: String, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        
        let entity = NSEntityDescription.entityForName("Member", inManagedObjectContext: context)!
        self.init(entity: entity, insertIntoManagedObjectContext: context)
        self.firstname = firstname
        self.surname = surname
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let birth_date =  dateFormatter.dateFromString( birth )
        
        self.birth = birth_date
        self.street = street
        self.plz = plz
        self.city = city
        self.dlrg = false
        
    }
    
    func addEvent(newValue: Event) {
        let set = self.hasEvents                    //NSSet
        var arr = set!.allObjects as! [Event]      // Array
        arr.append(newValue)
        self.hasEvents = NSSet(array: arr)
    }
    
    func removeEvent(value: Event){
        let set = self.hasEvents
        var arr = set!.allObjects as! [Event]      // Array
        arr.removeAtIndex(arr.indexOf(value)!)
        self.hasEvents = NSSet(array: arr)
    }
    
    func hasEventsAsArray()-> [Event]{
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true,selector: #selector(NSString.localizedStandardCompare))
        let sortedByName = self.hasEvents!.sortedArrayUsingDescriptors([sortDescriptor]) as! [Event]
        return sortedByName
    }
    
    func containsEvent_Date(value: Event_Date)->Bool{
        if (self.hasEvent_Date != nil){
            return self.hasEvent_Date!.containsObject(value)
        }else{
            return false
        }
    }
    
    func removeEvent_Date(value: Event_Date){
        if(containsEvent_Date(value)){
            let set = self.hasEvent_Date
            var arr = set!.allObjects as! [Event_Date]      // Array
            arr.removeAtIndex(arr.indexOf(value)!)
            self.hasEvent_Date = NSSet(array: arr)
        }
    }
    
    func addEvent_Date(newValue: Event_Date) {
        let set = self.hasEvent_Date                    //NSSet
        var arr = set!.allObjects as! [Event_Date]      // Array
        arr.append(newValue)
        self.hasEvent_Date = NSSet(array: arr)
    }
    
}


