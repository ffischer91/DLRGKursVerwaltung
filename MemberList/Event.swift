//
//  Event.swift
//  MemberList
//
//  Created by flo on 08.06.16.
//  Copyright © 2016 flo. All rights reserved.
//

import Foundation
import CoreData


class Event: NSManagedObject {

    convenience init(name: String, location: String, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        
        let entity = NSEntityDescription.entityForName("Event", inManagedObjectContext: context)!
        self.init(entity: entity, insertIntoManagedObjectContext: context)
       
        self.name = name
        self.location = location
    }
    
    
    
    func addEvent_Date(newValue: Event_Date) {
        let set = self.eventHasDates                    //NSSet
        var arr = set!.allObjects as! [Event_Date]      // Array
        arr.append(newValue)
        self.eventHasDates = NSSet(array: arr)
    }
    
    func removeEvent_Date(value: Event_Date){
        let set = self.eventHasDates
        var arr = set!.allObjects as! [Event_Date]      // Array
        arr.removeAtIndex(arr.indexOf(value)!)
        self.eventHasDates = NSSet(array: arr)
    }
    
    func hasMembersAsArray()-> [Member]{
        //let set = self.eventHasMembers
         //return set!.allObjects as! [Member]      // Array
        let sortDescriptor = NSSortDescriptor(key: "surname", ascending: true,selector: #selector(NSString.localizedStandardCompare))
        let sortedBySurname = self.eventHasMembers!.sortedArrayUsingDescriptors([sortDescriptor]) as! [Member]
       
        return sortedBySurname
    }
}
