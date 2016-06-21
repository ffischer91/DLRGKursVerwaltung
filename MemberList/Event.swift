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
    
    func hasEventDatesAsArray()-> [Event_Date]{
        let sortDescriptor = NSSortDescriptor(key: "beginn", ascending: true,selector: #selector(NSDate.compare))//NSString.localizedStandardCompare))
        let sortedByDate = self.eventHasDates!.sortedArrayUsingDescriptors([sortDescriptor]) as! [Event_Date]
        return sortedByDate
    }
}


extension NSDate {
    
    func isGreaterThanDate(dateToCompare: NSDate) -> Bool {
        //Declare Variables
        var isGreater = false
        
        //Compare Values
        if self.compare(dateToCompare) == NSComparisonResult.OrderedDescending {
            isGreater = true
        }
        
        //Return Result
        return isGreater
    }
    
    func isLessThanDate(dateToCompare: NSDate) -> Bool {
        //Declare Variables
        var isLess = false
        
        //Compare Values
        if self.compare(dateToCompare) == NSComparisonResult.OrderedAscending {
            isLess = true
        }
        
        //Return Result
        return isLess
    }
    
    func equalToDate(dateToCompare: NSDate) -> Bool {
        //Declare Variables
        var isEqualTo = false
        
        //Compare Values
        if self.compare(dateToCompare) == NSComparisonResult.OrderedSame {
            isEqualTo = true
        }
        
        //Return Result
        return isEqualTo
    }
    
    func addDays(daysToAdd: Int) -> NSDate {
        let secondsInDays: NSTimeInterval = Double(daysToAdd) * 60 * 60 * 24
        let dateWithDaysAdded: NSDate = self.dateByAddingTimeInterval(secondsInDays)
        
        //Return Result
        return dateWithDaysAdded
    }
    
    func addHours(hoursToAdd: Int) -> NSDate {
        let secondsInHours: NSTimeInterval = Double(hoursToAdd) * 60 * 60
        let dateWithHoursAdded: NSDate = self.dateByAddingTimeInterval(secondsInHours)
        
        //Return Result
        return dateWithHoursAdded
    }
}
