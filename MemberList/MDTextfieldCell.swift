//
//  MDTextfieldCell.swift
//  MemberList
//
//  Created by flo on 06.06.16.
//  Copyright © 2016 flo. All rights reserved.
//

import UIKit

class MDTextfieldCell: UITableViewCell, Reusable {
      
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    

    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var textField: UITextField!
    
    //static var reuseIdentifier: String { return "VeryCustomReuseIdentifier" }
}




public protocol Reusable: class {
    /// The reuse identifier to use when registering and later dequeuing a reusable cell
    static var reuseIdentifier: String { get }
}

public extension Reusable {
    /// By default, use the name of the class as String for its reuseIdentifier
    static var reuseIdentifier: String {
        return String(self)
    }
}
