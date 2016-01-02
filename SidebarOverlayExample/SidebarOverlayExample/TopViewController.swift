//
//  TopViewController.swift
//  SidebarOverlayExample
//
//  Created by Alexander Perechnev on 1/2/16.
//  Copyright © 2016 Alexander Perechnev. All rights reserved.
//

import UIKit


class TopViewController: UIViewController {
    
    @IBAction func showMeMyMenu () {
        if let container = self.so_container() {
            container.setMenuOpened(true)
        }
    }

}
