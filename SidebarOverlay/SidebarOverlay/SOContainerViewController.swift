//
//  SOContainerViewController.swift
//  SidebarOverlay
//
//  Created by Alex Krzyżanowski on 12/23/15.
//  Copyright © 2015 Alex Krzyżanowski. All rights reserved.
//

import UIKit


public class SOContainerViewController: UIViewController, UIGestureRecognizerDelegate {
    
    /**
     A view controller that is currently presented to user.
     
     Assign this property to any view controller, that should be presented on the top of your application.
     
     In most cases you have to set this property when user selects an item in sidebar menu:
     
     ```swift
     func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = self.storyboard!.instantiateViewControllerWithIdentifier("newsScreen")
        self.so_containerViewController!.topViewController = vc
     }
     ```
    */
    public var topViewController: UIViewController? {
        get {
            return _topViewController
        }
        set {
            _topViewController?.view.removeFromSuperview()
            _topViewController?.removeFromParentViewController()
            
            _topViewController = newValue
            
            if let vc = _topViewController {
                vc.willMoveToParentViewController(self)
                self.addChildViewController(vc)
                self.view.addSubview(vc.view)
                vc.didMoveToParentViewController(self)
                
                vc.view.addGestureRecognizer(self.createPanGestureRecognizer())
            }
            
            self.brindLeftViewToFront()
        }
    }
    
    /**
     A view controller that represents the sidebar menu.
     
     A view controller, that is assigned to this property, is hidden under the left edge of the screen. When user makes a left-to-right swipe gesture, it follows the finger and becomes visible.
     
     Usually you have to set it only once, when you prepare an instance of `SOContainerViewController` to be presented.
    */
    public var leftViewController: UIViewController? {
        get {
            return _leftViewController
        }
        set {
            _leftViewController?.view.removeFromSuperview()
            _leftViewController?.removeFromParentViewController()
            
            _leftViewController = newValue
            
            if let vc = _leftViewController {
                vc.willMoveToParentViewController(self)
                self.addChildViewController(vc)
                self.view.addSubview(vc.view)
                vc.didMoveToParentViewController(self)
                
                vc.view.addGestureRecognizer(self.createPanGestureRecognizer())
                
                var menuFrame = vc.view.frame
                menuFrame.size.width = self.view.frame.size.width - LeftViewControllerRightIndent
                menuFrame.origin.x = -menuFrame.size.width
                vc.view.frame = menuFrame
            }
            
            self.brindLeftViewToFront()
        }
    }
    
    public var isLeftViewControllerPresented: Bool {
        get {
            guard let leftVC = self.leftViewController else {
                return false
            }
            
            return leftVC.view.frame.origin.x == LeftViewControllerOpenedLeftOffset
        }
        set {
            guard let leftVC = self.leftViewController else {
                return
            }
            
            var frame = leftVC.view.frame
            frame.origin.x = newValue ? LeftViewControllerOpenedLeftOffset : -frame.size.width
            
            let animations = { () -> () in
                leftVC.view.frame = frame
                self.contentCoverView.alpha = newValue ? 1.0 : 0.0
            }
            
            UIView.animateWithDuration(SideViewControllerOpenAnimationDuration, delay: 0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: animations, completion: nil)
        }
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        self.contentCoverView = UIView()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        self.contentCoverView = UIView()
        super.init(coder: aDecoder)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.contentCoverView.frame = self.view.bounds
        self.contentCoverView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
        self.contentCoverView.alpha = 0.0
        
        let tapOnContentCoverViewGesture = UITapGestureRecognizer(target: self, action: "contentCoverViewClicked")
        self.contentCoverView.addGestureRecognizer(tapOnContentCoverViewGesture)
        
        let panOnContentCoverVewGesture = UIPanGestureRecognizer(target: self, action: "contentCoverViewClicked")
        self.contentCoverView.addGestureRecognizer(panOnContentCoverVewGesture)
        
        self.view.addSubview(self.contentCoverView)
    }
    
    //
    // MARK: Gesture recognizer delegate
    
    public func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        let panGestureRecognizer = gestureRecognizer as! UIPanGestureRecognizer
        let translation = panGestureRecognizer.translationInView(self.view)
        return self.vectorIsMoreHorizontal(translation)
    }
    
    //
    // MARK: Internal usage
    
    let LeftViewControllerRightIndent: CGFloat = 56.0
    let LeftViewControllerOpenedLeftOffset: CGFloat = 0.0
    let SideViewControllerOpenAnimationDuration: NSTimeInterval = 0.24
    
    var _topViewController: UIViewController?
    var _leftViewController: UIViewController?
    
    var contentCoverView: UIView
    
    func contentCoverViewClicked() {
        if self.isLeftViewControllerPresented {
            self.isLeftViewControllerPresented = false
        }
    }
    
    func moveMenu(panGesture: UIPanGestureRecognizer) {
        panGesture.view?.layer.removeAllAnimations()
        
        let translatedPoint = panGesture.translationInView(self.view)
        
        if panGesture.state == UIGestureRecognizerState.Changed {
            if let sidebarView = self.leftViewController?.view {
                self.moveSidebarToVector(sidebarView, vector: translatedPoint)
            }
            
            panGesture.setTranslation(CGPointMake(0, 0), inView: self.view)
            
            if let view = self.leftViewController?.view {
                self.contentCoverView.alpha = 1.0 - abs(view.frame.origin.x) / view.frame.size.width
            }
        } else if panGesture.state == UIGestureRecognizerState.Ended {
            if let sidebar = self.leftViewController {
                self.isLeftViewControllerPresented = self.viewPulledOutMoreThanHalfOfItsWidth(sidebar)
            }
        }
    }
    
    func brindLeftViewToFront() {
        self.view.bringSubviewToFront(self.contentCoverView)
        
        if let vc = self.leftViewController {
            self.view.bringSubviewToFront(vc.view)
        }
    }
    
    func createPanGestureRecognizer() -> UIPanGestureRecognizer! {
        return UIPanGestureRecognizer.init(target: self, action: "moveMenu:")
    }
    
    func vectorIsMoreHorizontal(point: CGPoint) -> Bool {
        if fabs(point.x) > fabs(point.y) {
            return true
        }
        return false
    }
    
    func viewPulledOutMoreThanHalfOfItsWidth(viewController: UIViewController) -> Bool {
        let frame = viewController.view.frame
        return fabs(frame.origin.x) < frame.size.width / 2
    }
    
    func moveSidebarToVector(sidebar: UIView, vector: CGPoint) {
        let calculatedXPosition = min(sidebar.frame.size.width / 2.0, sidebar.center.x + vector.x)
        sidebar.center = CGPointMake(calculatedXPosition, sidebar.center.y)
    }
    
}
