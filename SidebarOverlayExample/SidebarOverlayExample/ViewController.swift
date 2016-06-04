//
//  ViewController.swift
//  SidebarOverlayExample
//
//  Created by Alex Krzyżanowski on 12/24/15.
//  Copyright © 2015 Alex Krzyżanowski. All rights reserved.
//

import UIKit
import SidebarOverlay


class ViewController: SOContainerViewController {
  
    override var isSideViewControllerPresented: Bool {
        didSet {
            let action = isSideViewControllerPresented ? "opened" : "closed"
            let side = menuSide == .Left ? "left" : "right"
            NSLog("You've \(action) the \(side) view controller.")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.menuSide = .Left
        self.topViewController = self.storyboard?.instantiateViewControllerWithIdentifier("topScreen")
        self.sideViewController = self.storyboard?.instantiateViewControllerWithIdentifier("leftScreen")
    }
  
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }

}

