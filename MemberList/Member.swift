//
//  Member.swift
//  MemberList
//
//  Created by flo on 31.05.16.
//  Copyright © 2016 flo. All rights reserved.
//

import Foundation
import CoreData


class Member: NSManagedObject{

// Insert code here to add functionality to your managed object subclass


   override var description: String {
        return "[Member, First: \(self.firstname!), Surname: \(self.surname!) ]"
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
    
}


