//
//  EventGeneralController.swift
//  MemberList
//
//  Created by flo on 04.06.16.
//  Copyright © 2016 flo. All rights reserved.
//

import UIKit

class EventGeneralController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem()
        navigationItem.leftItemsSupplementBackButton = true
    }
}
