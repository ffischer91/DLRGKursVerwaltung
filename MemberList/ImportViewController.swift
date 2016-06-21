//
//  ImportViewController.swift
//  MemberList
//
//  Created by flo on 20.06.16.
//  Copyright © 2016 flo. All rights reserved.
//

import UIKit
import FileBrowser
import SwiftCSV

class ImportViewController: UIViewController {

    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var btn_add: UIBarButtonItem!
    
    @IBAction func btn_add_action(sender: AnyObject) {
        let fileBrowser = FileBrowser()
        self.presentViewController(fileBrowser, animated: true, completion: nil)
        fileBrowser.didSelectFile = { (file: FBFile) -> Void in
            print(file.filePath)
            self.url =  file.filePath
        }
        
    }
    
    @IBAction func btn_import_action(sender: AnyObject) {
        print("IMPORT")
    }

    
    var url: NSURL?{
        didSet {
            self.textView.text = "File to import: \n\n \(self.url!)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(url != nil){
            self.textView.text = "Received: \n\n \(self.url!)"
        }
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



    


    
}
