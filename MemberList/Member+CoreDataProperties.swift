//
//  Member+CoreDataProperties.swift
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

extension Member {

    @NSManaged var city: String?
    @NSManaged var dlrg: NSNumber?
    @NSManaged var firstname: String?
    @NSManaged var image: NSData?
    @NSManaged var note: String?
    @NSManaged var plz: String?
    @NSManaged var street: String?
    @NSManaged var surname: String?
    @NSManaged var hasEvents: NSSet?

}
