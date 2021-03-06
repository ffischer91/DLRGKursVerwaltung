//
//  Event_Date+CoreDataProperties.swift
//  MemberList
//
//  Created by flo on 19.06.16.
//  Copyright © 2016 flo. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Event_Date {

    @NSManaged var beginn: NSDate?
    @NSManaged var end: NSDate?
    @NSManaged var hasEvent: Event?
    @NSManaged var hasTrainer: NSSet?
    @NSManaged var hasMember: NSSet?

}
