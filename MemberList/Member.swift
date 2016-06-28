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


    // Description anpassen, für Debug Zwecke nützlich!
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
        let set = self.hasEvents
        var arr = set!.allObjects as! [Event]
        arr.append(newValue)
        self.hasEvents = NSSet(array: arr)
    }
    
    func removeEvent(value: Event){
        let set = self.hasEvents
        var arr = set!.allObjects as! [Event]
        arr.removeAtIndex(arr.indexOf(value)!)
        self.hasEvents = NSSet(array: arr)
    }
    
    // Events als Array, sortiert nach name
    func hasEventsAsArray()-> [Event]{
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true,selector: #selector(NSString.localizedStandardCompare))
        let sortedByName = self.hasEvents!.sortedArrayUsingDescriptors([sortDescriptor]) as! [Event]
        return sortedByName
    }
    
    // Funktion zu prüfen ob ein Member ein bestimmtes Event_Date eingetragen hat
    func containsEvent_Date(value: Event_Date)->Bool{
        if (self.hasEvent_Date != nil){
            return self.hasEvent_Date!.containsObject(value)
        }else{
            return false
        }
    }
    
    func removeEvent_Date(value: Event_Date){
        if(containsEvent_Date(value)){
            let set = self.hasEvent_Date                    // NSSet
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


