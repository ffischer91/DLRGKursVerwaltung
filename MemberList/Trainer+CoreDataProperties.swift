//
//  Trainer+CoreDataProperties.swift
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

extension Trainer {

    @NSManaged var firstname: String?
    @NSManaged var licenseID: String?
    @NSManaged var surname: String?
    @NSManaged var hasEvent_Date: NSSet?

}
