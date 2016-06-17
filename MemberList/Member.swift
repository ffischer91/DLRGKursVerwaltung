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
}


