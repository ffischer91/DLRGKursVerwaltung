//
//  MDTableCell.swift
//  MemberList
//
//  Created by flo on 08.06.16.
//  Copyright © 2016 flo. All rights reserved.
//

import UIKit

class MDTableCell: UITableViewCell, Reusable, UITableViewDelegate, UITableViewDataSource {
    
    let data: [ String ] = ["Event1 ", "Event 2", "Event 3"]
    
    
    @IBOutlet weak var label: UILabel!
    
    
   
    @IBOutlet weak var table: UITableView!
    
   

    
//    override func viewDidAppear(animated: Bool) {
//       test()
//    }

    
    func test(){
        table.registerClass(UITableViewCell.self, forCellReuseIdentifier: "MDTableCell_EventNameCell")
        table.dataSource = self
       table.delegate = self
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count;
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MDTableCell_EventNameCell", forIndexPath: indexPath)
        let eventName = data[indexPath.row]
        cell.textLabel!.text = " Row \(indexPath.row): \(eventName)"
        return cell
        
    }
    

}
