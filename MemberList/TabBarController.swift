//
//  TabBarController.swift
//  MemberList
//
//  Created by flo on 21.06.16.
//  Copyright © 2016 flo. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let center = NSNotificationCenter.defaultCenter()
        let queue = NSOperationQueue.mainQueue()
        let appDelegate = UIApplication.sharedApplication().delegate
        
        center.addObserverForName(CSVURL.Notification, object: appDelegate, queue: queue){ notification in
            if let url = notification.userInfo?[CSVURL.Key] as? NSURL {

                self.selectedIndex = 3      // Download Tab
                let vc = self.selectedViewController!.contentViewController as! ImportViewController
                vc.url = url        // Url setzen
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension UIViewController{
    var contentViewController : UIViewController {
        if let navCon = self as? UINavigationController{
            return navCon.visibleViewController!
        }else{
            return self
        }
    }
}
