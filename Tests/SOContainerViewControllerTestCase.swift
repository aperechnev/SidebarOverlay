//
//  SOContainerViewControllerTestCase.swift
//  SidebarOverlay
//
//  Created by Alexander Perechnev on 18.01.16.
//  Copyright © 2016 Alexander Perechnev. All rights reserved.
//

import XCTest
@testable import SidebarOverlay


class SOContainerViewControllerTestCase: XCTestCase {
    
    func testInitialization() {
        let containerViewController = SOContainerViewController()
        XCTAssertNotNil(containerViewController)
        XCTAssertNil(containerViewController.topViewController)
        XCTAssertNil(containerViewController.sideViewController)
    }
    
    func testViewControllersAssigning() {
        let containerViewController = SOContainerViewController()
        
        let topViewController = UIViewController()
        containerViewController.topViewController = topViewController
        XCTAssertNotNil(containerViewController.topViewController)
        XCTAssertEqual(topViewController, containerViewController.topViewController)
        
        let leftViewController = UIViewController()
        containerViewController.sideViewController = leftViewController
        XCTAssertNotNil(containerViewController.sideViewController)
        XCTAssertEqual(leftViewController, containerViewController.sideViewController)
        
        XCTAssertEqual(leftViewController.view, containerViewController.view.subviews.last, "Left view controller is not on top of the views stack.")
        
        containerViewController.topViewController = topViewController
        XCTAssertEqual(leftViewController.view, containerViewController.view.subviews.last, "Left view controller is not on top of the views stack.")
    }
    
    func testLeftViewControllerMovement() {
        let containerViewController = SOContainerViewController()
        XCTAssertFalse(containerViewController.isSideViewControllerPresented)
        
        containerViewController.isSideViewControllerPresented = true
        XCTAssertFalse(containerViewController.isSideViewControllerPresented)
        
        let topViewController = UIViewController()
        containerViewController.topViewController = topViewController
        
        let leftViewController = UIViewController()
        containerViewController.sideViewController = leftViewController
        
        containerViewController.isSideViewControllerPresented = true
        XCTAssertTrue(containerViewController.isSideViewControllerPresented)
        
        containerViewController.isSideViewControllerPresented = false
        XCTAssertFalse(containerViewController.isSideViewControllerPresented)
    }
    
    func testViewControllerExtension() {
        let containerViewController = SOContainerViewController()
        let navigationController = UINavigationController()
        
        let topViewController = UIViewController()
        XCTAssertNil(topViewController.so_containerViewController)
        
        navigationController.viewControllers = [topViewController]
        containerViewController.topViewController = navigationController
        
        XCTAssertEqual(containerViewController, topViewController.so_containerViewController)
    }
    
}
