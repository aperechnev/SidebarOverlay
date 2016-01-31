//
//  UIViewController.swift
//  SidebarOverlay
//
//  Created by Alex Krzyżanowski on 31.01.16.
//  Copyright © 2016 Alex Krzyżanowski. All rights reserved.
//

import UIKit


/**
 The `UIViewController` class is extended to be compatible with `SidebarOverlay`.
*/
public extension UIViewController {
    
    /**
     Use this computed property to access the container view controller from any view controller.
     
     - returns: An instance of `SOContainerViewController` that holds current view controller or `nil` if there is no container view controller.
    */
    var so_containerViewController: SOContainerViewController? {
        if self is SOContainerViewController {
            return self as? SOContainerViewController
        }
        if let parentVC = self.parentViewController {
            return parentVC.so_containerViewController
        }
        return nil
    }
    
}
