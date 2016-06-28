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

    //Konstruktor
    convenience init(name: String, location: String, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        
        let entity = NSEntityDescription.entityForName(Constants.EntityEvent, inManagedObjectContext: context)!
        self.init(entity: entity, insertIntoManagedObjectContext: context)
       
        self.name = name
        self.location = location
    }
    
    // Summen werden für Chart gebraucht:
    var sumMemberArray: [ Double ] = [ ]
    var sumTrainerArray: [ Double ] = [ ]
    
    // fügt ein einzelnes Event_Date hinzu
    func addEvent_Date(newValue: Event_Date) {
        let set = self.eventHasDates                    //NSSet
        var arr = set!.allObjects as! [Event_Date]      // Array
        arr.append(newValue)                            // hinzufügen
        self.eventHasDates = NSSet(array: arr)          // zurückschreiben
    }
    
    // entfernt ein einzelnes Event_Date, wenn es vorhanden ist
    func removeEvent_Date(value: Event_Date){
        let set = self.eventHasDates                    // NSSet
        var arr = set!.allObjects as! [Event_Date]      // Array
        arr.removeAtIndex(arr.indexOf(value)!)          // löschen
        self.eventHasDates = NSSet(array: arr)          // zurückschreiben
    }
    
    // gibt Members als Array zurück sortiert nach Nachname
    func hasMembersAsArray()-> [Member]{
        let sortDescriptor = NSSortDescriptor(key: "surname", ascending: true,selector: #selector(NSString.localizedStandardCompare))
        let sortedBySurname = self.eventHasMembers!.sortedArrayUsingDescriptors([sortDescriptor]) as! [Member]
       
        return sortedBySurname
    }
    
    // gibt Event_Dates als Array zurück sortiert nach Begin
    func hasEventDatesAsArray()-> [Event_Date]{
        let sortDescriptor = NSSortDescriptor(key: "beginn", ascending: true,selector: #selector(NSDate.compare))
        let sortedByDate = self.eventHasDates!.sortedArrayUsingDescriptors([sortDescriptor]) as! [Event_Date]
        return sortedByDate
    }
    
    // Daten für BarChart
    func hasEventDatesForChart()-> [String]{
        sumMemberArray = [ ]            // ausleeren
        sumTrainerArray = [ ]
        var stringForDate: [ String ] = [ ]     // Dates als Stings
        
        // Datum nach Begin sortieren
        let sortDescriptor = NSSortDescriptor(key: "beginn", ascending: true,selector: #selector(NSDate.compare))
        let sortedByDate = self.eventHasDates!.sortedArrayUsingDescriptors([sortDescriptor]) as! [Event_Date]
        
        // Datums durchgehen
        for i in 0 ..< sortedByDate.count
        {
            stringForDate.append(sortedByDate[i].beginn!.date_toString_Date())      // String immer anhängen
            if(sortedByDate[i].hasTrainer != nil){
                let sumTrainer = Double(sortedByDate[i].hasTrainer!.count)          // wie viele Trainer an Datum
                sumTrainerArray.append(sumTrainer)
                //print(sumTrainer)
            }
            if(sortedByDate[i].hasMember != nil){
                let sumMember = Double(sortedByDate[i].hasMember!.count)            // wie viele Members an Datum
                sumMemberArray.append(sumMember)
                //print(sumMember)
            }
        }
        return stringForDate
    }
}


// ein paar Funktionen die den Umgang mit Datum leichter machen!
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
