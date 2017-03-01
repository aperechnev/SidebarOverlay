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
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuItemCell")!
        cell.textLabel?.text = "Menu Item #\(indexPath.row + 1)"
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "topScreen")
        
        DispatchQueue.main.async {
            self.so_containerViewController?.topViewController = vc
        }
    }
    
}
