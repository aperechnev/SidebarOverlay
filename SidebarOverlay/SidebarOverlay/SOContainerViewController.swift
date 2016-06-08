//
//  SOContainerViewController.swift
//  SidebarOverlay
//
//  Created by Alex Krzyżanowski on 12/23/15.
//  Copyright © 2015 Alex Krzyżanowski. All rights reserved.
//

import UIKit

public enum Side {
  case Left
  case Right
}

public class SOContainerViewController: UIViewController, UIGestureRecognizerDelegate {
    
    // ---------------------------------
    // MARK: Internal usage
    // ---------------------------------
    
    /// Specifies the indent from trailing side. This means that
    /// if the sidebar comes from left, `SideViewControllerTrailingIndent` is the space
    /// on the right side of this sidebar. Otherwise it's the left side.
    internal let SideViewControllerTrailingIndent: CGFloat = 56.0
    
    /// Specifies the leading offset for the sidebar.
    /// If `menuSide` is set to *Left*, this means the space
    /// from superview's `minX` (usually 0). Otherwise
    /// from the `maxX` (depends on the screen's dimension).
    internal let SideViewControllerOpenedLeadingOffset: CGFloat = 0.0
    
    internal let SideViewControllerOpenAnimationDuration: NSTimeInterval = 0.24
    
    private var _topViewController: UIViewController?
    private var _sideViewController: UIViewController?
    
    private var contentCoverView: UIView
    
    // ---------------------------------
    // MARK: Public properties
    // ---------------------------------
    
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
            
            self.bringSideViewToFront()
        }
    }
    
    /**
     A view controller that represents the sidebar menu.
     
     A view controller, that is assigned to this property, is hidden under the left edge of the screen. When user makes a left-to-right swipe gesture, it follows the finger and becomes visible.
     
     Usually you have to set it only once, when you prepare an instance of `SOContainerViewController` to be presented.
    */
    public var sideViewController: UIViewController? {
        get {
            return _sideViewController
        }
        set {
            _sideViewController?.view.removeFromSuperview()
            _sideViewController?.removeFromParentViewController()
            
            _sideViewController = newValue
            
            if let vc = _sideViewController {
                vc.willMoveToParentViewController(self)
                self.addChildViewController(vc)
                self.view.addSubview(vc.view)
                vc.didMoveToParentViewController(self)
                
                vc.view.addGestureRecognizer(self.createPanGestureRecognizer())
                
                var menuFrame = vc.view.frame
                menuFrame.size.width = self.view.frame.size.width - SideViewControllerTrailingIndent
                menuFrame.origin.x = menuSide == .Left ? -menuFrame.size.width : view.frame.maxX + menuFrame.size.width
                vc.view.frame = menuFrame
            }
            
            self.bringSideViewToFront()
        }
    }
    
    public var isSideViewControllerPresented: Bool {
        get {
            guard let sideVC = self.sideViewController else {
                return false
            }
          
            return (menuSide == .Left) ? (sideVC.view.frame.origin.x == SideViewControllerOpenedLeadingOffset) :
                                         (view.frame.width - sideVC.view.frame.maxX == SideViewControllerOpenedLeadingOffset)
        }
        set {
            guard let sideVC = self.sideViewController else {
                return
            }
            
            var frame = sideVC.view.frame
            if menuSide == .Left {
              frame.origin.x = newValue ? SideViewControllerOpenedLeadingOffset : -frame.size.width
            } else {
              frame.origin.x = newValue ? view.frame.maxX - frame.width - SideViewControllerOpenedLeadingOffset : frame.size.width + SideViewControllerTrailingIndent
            }
          
            let animations = { () -> () in
                sideVC.view.frame = frame
                self.contentCoverView.alpha = newValue ? 1.0 : 0.0
            }
            
            UIView.animateWithDuration(SideViewControllerOpenAnimationDuration, delay: 0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: animations, completion: nil)
        }
    }
  
    /// Determines where the side menu should come from.
    public var menuSide: Side = .Left
    
    // ---------------------------------
    // MARK: Initialization 
    // ---------------------------------
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        self.contentCoverView = UIView()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        self.contentCoverView = UIView()
        super.init(coder: aDecoder)
    }
    
    // ---------------------------------
    // MARK: View life cycle
    // ---------------------------------
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.contentCoverView.frame = self.view.bounds
        self.contentCoverView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
        self.contentCoverView.alpha = 0.0
        
        let tapOnContentCoverViewGesture = UITapGestureRecognizer(target: self, action: #selector(SOContainerViewController.contentCoverViewClicked))
        self.contentCoverView.addGestureRecognizer(tapOnContentCoverViewGesture)
        
        let panOnContentCoverVewGesture = UIPanGestureRecognizer(target: self, action: #selector(SOContainerViewController.contentCoverViewClicked))
        self.contentCoverView.addGestureRecognizer(panOnContentCoverVewGesture)
        
        self.view.addSubview(self.contentCoverView)
    }
    
    // ---------------------------------
    // MARK: Gesture recognizer delegate
    // ---------------------------------
    
    public func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        let panGestureRecognizer = gestureRecognizer as! UIPanGestureRecognizer
        let translation = panGestureRecognizer.translationInView(self.view)
        return self.vectorIsMoreHorizontal(translation)
    }
  
}

// MARK: - Utils 

extension SOContainerViewController {
    private func bringSideViewToFront() {
        self.view.bringSubviewToFront(self.contentCoverView)
        
        if let vc = self.sideViewController {
            self.view.bringSubviewToFront(vc.view)
        }
    }
    
    private func createPanGestureRecognizer() -> UIPanGestureRecognizer! {
        return UIPanGestureRecognizer.init(target: self, action: #selector(SOContainerViewController.moveMenu(_:)))
    }
}

// MARK: - UIPanGesture Geometry Utils 

extension SOContainerViewController {
    private func vectorIsMoreHorizontal(point: CGPoint) -> Bool {
        if fabs(point.x) > fabs(point.y) {
            return true
        }
        return false
    }
    
    private func viewPulledOutMoreThanHalfOfItsWidth(viewController: UIViewController) -> Bool {
        let frame = viewController.view.frame
        return fabs(frame.origin.x) < frame.size.width / 2
    }
    
    private func moveSidebarToVector(sidebar: UIView, vector: CGPoint) {
        let calculatedXPosition = menuSide == .Left ? min(sidebar.frame.size.width / 2.0, sidebar.center.x + vector.x) :
            max(sidebar.frame.size.width / 2.0, sidebar.center.x + vector.x)
        
        let shouldMove = menuSide == .Left ? (calculatedXPosition < sidebar.frame.width / 2) :
            (calculatedXPosition - sidebar.frame.width / 2 > SideViewControllerTrailingIndent - SideViewControllerOpenedLeadingOffset)
        if shouldMove {
            sidebar.center = CGPointMake(calculatedXPosition, sidebar.center.y)
        }
    }
}

// MARK: - Actions

extension SOContainerViewController {
    @IBAction internal func contentCoverViewClicked() {
        if self.isSideViewControllerPresented {
            self.isSideViewControllerPresented = false
        }
    }
    
    @IBAction internal func moveMenu(panGesture: UIPanGestureRecognizer) {
        panGesture.view?.layer.removeAllAnimations()
        
        let translatedPoint = panGesture.translationInView(self.view)
        
        if panGesture.state == UIGestureRecognizerState.Changed {
            if let sidebarView = self.sideViewController?.view {
                self.moveSidebarToVector(sidebarView, vector: translatedPoint)
            }
            
            panGesture.setTranslation(CGPointMake(0, 0), inView: self.view)
            
            if let view = self.sideViewController?.view {
                self.contentCoverView.alpha = 1.0 - abs(view.frame.origin.x) / view.frame.size.width
            }
        } else if panGesture.state == UIGestureRecognizerState.Ended {
            if let sidebar = self.sideViewController {
                self.isSideViewControllerPresented = self.viewPulledOutMoreThanHalfOfItsWidth(sidebar)
            }
        }
    }
}

// MARK: - Autolayout management

extension SOContainerViewController {
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if menuSide == .Right && !isSideViewControllerPresented {
            guard let sideVC = self.sideViewController else {
                return
            }
            
            var frame = sideVC.view.frame
            frame.origin.x = frame.size.width + SideViewControllerTrailingIndent
            sideVC.view.frame = frame
        }
    }
}
