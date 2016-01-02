//
//  ViewController.swift
//  SidebarOverlayExample
//
//  Created by Alexander Perechnev on 12/24/15.
//  Copyright © 2015 Alexander Perechnev. All rights reserved.
//

import UIKit
import SidebarOverlay


class ViewController: SOContainerViewController, SOContainerViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.topViewController = self.storyboard?.instantiateViewControllerWithIdentifier("topScreen")
        self.leftViewController = self.storyboard?.instantiateViewControllerWithIdentifier("leftScreen")
        
        self.delegate = self // This is just an exmaple, isn't it? :)
    }
    
    func leftViewControllerPulledOut(pulledOut: Bool) {
        if pulledOut {
            NSLog("You've opened the left view controller.")
        } else {
            NSLog("You've closed the left view controller.")
        }
    }

}

