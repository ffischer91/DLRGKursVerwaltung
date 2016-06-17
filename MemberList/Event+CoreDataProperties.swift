//
//  Event+CoreDataProperties.swift
//  MemberList
//
//  Created by flo on 08.06.16.
//  Copyright © 2016 flo. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Event {

    @NSManaged var location: String?
    @NSManaged var name: String?
    @NSManaged var eventHasDates: NSSet?
    @NSManaged var eventHasMembers: NSSet?
    @NSManaged var eventHasTrainers: NSSet?

}
