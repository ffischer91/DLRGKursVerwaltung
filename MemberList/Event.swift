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

// Insert code here to add functionality to your managed object subclass
//    @NSManaged func addEvent_Date(value:Event_Date)
//    @NSManaged func removeEvent_Date(value:Event_Date)
//    @NSManaged func addEvent_Dates(value:Set<Event_Date>)
    
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
}
