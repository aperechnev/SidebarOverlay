//
//  ViewController.swift
//  SidebarOverlayExample
//
//  Created by Alexander Perechnev on 12/24/15.
//  Copyright © 2015 Alexander Perechnev. All rights reserved.
//

import UIKit
import SidebarOverlay


class ViewController: SOContainerViewController {
    
    override var isLeftViewControllerPresented: Bool {
        didSet {
            let action = isLeftViewControllerPresented ? "opened" : "closed"
            NSLog("You've \(action) the left view controller.")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.topViewController = self.storyboard?.instantiateViewControllerWithIdentifier("topScreen")
        self.leftViewController = self.storyboard?.instantiateViewControllerWithIdentifier("leftScreen")
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }

}

