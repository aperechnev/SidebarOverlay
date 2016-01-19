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
        XCTAssertNil(containerViewController.leftViewController)
    }
    
    func testViewControllersAssigning() {
        let containerViewController = SOContainerViewController()
        
        let topViewController = UIViewController()
        containerViewController.topViewController = topViewController
        XCTAssertNotNil(containerViewController.topViewController)
        XCTAssertEqual(topViewController, containerViewController.topViewController)
        
        let leftViewController = UIViewController()
        containerViewController.leftViewController = leftViewController
        XCTAssertNotNil(containerViewController.leftViewController)
        XCTAssertEqual(leftViewController, containerViewController.leftViewController)
        
        XCTAssertEqual(leftViewController.view, containerViewController.view.subviews.last, "Left view controller is not on top of the views stack.")
        
        containerViewController.topViewController = topViewController
        XCTAssertEqual(leftViewController.view, containerViewController.view.subviews.last, "Left view controller is not on top of the views stack.")
    }
    
    func testLeftViewControllerMovement() {
        let containerViewController = SOContainerViewController()
        XCTAssertFalse(containerViewController.isLeftViewControllerPresented)
        
        containerViewController.isLeftViewControllerPresented = true
        XCTAssertFalse(containerViewController.isLeftViewControllerPresented)
        
        let topViewController = UIViewController()
        containerViewController.topViewController = topViewController
        
        let leftViewController = UIViewController()
        containerViewController.leftViewController = leftViewController
        
        containerViewController.isLeftViewControllerPresented = true
        XCTAssertTrue(containerViewController.isLeftViewControllerPresented)
        
        containerViewController.isLeftViewControllerPresented = false
        XCTAssertFalse(containerViewController.isLeftViewControllerPresented)
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
    
    func testVector() {
        let containerViewController = SOContainerViewController()
        XCTAssertTrue(containerViewController.vectorIsMoreHorizontal(CGPointMake(20, -10)))
        XCTAssertFalse(containerViewController.vectorIsMoreHorizontal(CGPointMake(10, -20)))
    }
    
    func testSidebarMovement() {
        let containerViewController = SOContainerViewController()
        
        let view = UIView()
        view.frame = CGRectMake(-10, 0, 10, 10)
        
        containerViewController.moveSidebarToVector(view, vector: CGPointMake(5, 0))
        XCTAssertEqual(CGRectMake(-5, 0, 10, 10), view.frame)
        
        containerViewController.moveSidebarToVector(view, vector: CGPointMake(100, 100))
        XCTAssertEqual(CGRectMake(0, 0, 10, 10), view.frame)
    }
    
    func testSidebarMoveFinishing() {
        let containerViewController = SOContainerViewController()
        let viewController = UIViewController()
        
        viewController.view.frame = CGRectMake(-50, 0, 200, 400)
        XCTAssertTrue(containerViewController.viewPulledOutMoreThanHalfOfItsWidth(viewController))
        
        viewController.view.frame = CGRectMake(-150, 0, 200, 400)
        XCTAssertFalse(containerViewController.viewPulledOutMoreThanHalfOfItsWidth(viewController))
    }
    
}
