//
//  Trainer.swift
//  MemberList
//
//  Created by flo on 08.06.16.
//  Copyright © 2016 flo. All rights reserved.
//

import Foundation
import CoreData


class Trainer: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
 
    
    
    func addEvent_Date(newValue: Event_Date) {
        let set = self.hasEvent_Date                    //NSSet
        var arr = set!.allObjects as! [Event_Date]      // Array
        arr.append(newValue)
        self.hasEvent_Date = NSSet(array: arr)
    }
    
    func removeEvent_Date(value: Event_Date){
        let set = self.hasEvent_Date
        var arr = set!.allObjects as! [Event_Date]      // Array
        arr.removeAtIndex(arr.indexOf(value)!)
        self.hasEvent_Date = NSSet(array: arr)
    }
    
}
