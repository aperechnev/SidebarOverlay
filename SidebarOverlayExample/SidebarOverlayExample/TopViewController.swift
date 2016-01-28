//
//  TopViewController.swift
//  SidebarOverlayExample
//
//  Created by Alex Krzyżanowski on 1/2/16.
//  Copyright © 2016 Alex Krzyżanowski. All rights reserved.
//

import UIKit


class TopViewController: UIViewController {
    
    @IBAction func showMeMyMenu () {
        if let container = self.so_containerViewController {
            container.isLeftViewControllerPresented = true
        }
    }

}
