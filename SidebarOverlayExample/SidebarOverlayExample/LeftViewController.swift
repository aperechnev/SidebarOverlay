//
//  LeftViewController.swift
//  SidebarOverlayExample
//
//  Created by Alex Krzyżanowski on 09.01.16.
//  Copyright © 2016 Alex Krzyżanowski. All rights reserved.
//

import UIKit


class LeftViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("menuItemCell")!
        cell.textLabel?.text = "Menu Item #\(indexPath.row + 1)"
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("topScreen")
        
        dispatch_async(dispatch_get_main_queue()) {
            self.so_containerViewController?.topViewController = vc
        }
    }
    
}
