//
//  EventDateController.swift
//  MemberList
//
//  Created by flo on 02.06.16.
//  Copyright © 2016 flo. All rights reserved.
//

import UIKit

class EventDateController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem()
        navigationItem.leftItemsSupplementBackButton = true
    }
}
