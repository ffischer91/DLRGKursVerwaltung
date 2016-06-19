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
}

extension NSDate{
    func date_toString() -> String{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
        return dateFormatter.stringFromDate(self)
    }
}
