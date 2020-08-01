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
  
    override var isSideViewControllerPresented: Bool {
        didSet {
            let action = isSideViewControllerPresented ? "opened" : "closed"
            let side = self.menuSide == .left ? "left" : "right"
            NSLog("You've \(action) the \(side) view controller.")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.menuSide = .left
        self.topViewController = self.storyboard?.instantiateViewController(withIdentifier: "topScreen")
        self.sideViewController = self.storyboard?.instantiateViewController(withIdentifier: "leftScreen")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}

