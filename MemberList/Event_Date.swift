//
//  Event_Date.swift
//  MemberList
//
//  Created by flo on 08.06.16.
//  Copyright © 2016 flo. All rights reserved.
//

import Foundation
import CoreData


class Event_Date: NSManagedObject {

    convenience init(event: Event, begin: NSDate, end: NSDate, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        
        let entity = NSEntityDescription.entityForName("Event_Date", inManagedObjectContext: context)!
        self.init(entity: entity, insertIntoManagedObjectContext: context)
        self.hasEvent = event
        self.beginn = begin
        self.end = end
    }
    
    convenience init(event: Event, beginDate: String, beginTime: String, endTime: String, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        
        let entity = NSEntityDescription.entityForName("Event_Date", inManagedObjectContext: context)!
        self.init(entity: entity, insertIntoManagedObjectContext: context)

        
        let strBegin = beginDate + " " + beginTime
        let strEnd = beginDate + " " + endTime
        self.beginn = string_toDate(strBegin)
        self.end = string_toDate(strEnd)
        
        self.hasEvent = event
        
    }
    
    func string_toDate(dateTime: String)-> NSDate{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
        return dateFormatter.dateFromString(dateTime)!
    }
}

extension NSDate{
    
    func date_toString_DateTime() -> String{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
        return dateFormatter.stringFromDate(self)
    }
    
    func date_toString_Date() -> String{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.stringFromDate(self)
    }
    
        func hour() -> Int
        {
            //Get Hour
            let calendar = NSCalendar.currentCalendar()
            let components = calendar.components(.Hour, fromDate: self)
            let hour = components.hour
            
            //Return Hour
            return hour
        }
        
        
        func minute() -> Int
        {
            //Get Minute
            let calendar = NSCalendar.currentCalendar()
            let components = calendar.components(.Minute, fromDate: self)
            let minute = components.minute
            
            //Return Minute
            return minute
        }
        
        func toShortTimeString() -> String
        {
            //Get Short Time String
            let formatter = NSDateFormatter()
            formatter.timeStyle = .ShortStyle
            let timeString = formatter.stringFromDate(self)
            
            //Return Short Time String
            return timeString
        }
}
    

