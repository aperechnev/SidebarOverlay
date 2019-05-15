//
//  SOContainerViewController.swift
//  SidebarOverlay
//
//  Created by Alexander Perechnev on 12/23/15.
//  Copyright © 2015-2017 Alexander Perechnev. All rights reserved.
//

import UIKit

/**
 The container view controller is the root view controller that makes all magic for us. It's necessary to subclass `SOContainerViewController` and assign it to our container view controller. Then we can setup top and side view controllers:
 
 ```swift
 import SidebarOverlay
 
 class ContainerViewController: SOContainerViewController {
 
     override func viewDidLoad() {
        super.viewDidLoad()
     
        self.menuSide = .left
        self.topViewController = self.storyboard?.instantiateViewControllerWithIdentifier("topScreen")
        self.sideViewController = self.storyboard?.instantiateViewControllerWithIdentifier("leftScreen")
     }
 
 }
 ```
 
 Set the container view controller as initial on your storyboard and your basic application with sidebar is ready to run.
 */
open class SOContainerViewController: UIViewController, UIGestureRecognizerDelegate {
    
    //
    // MARK: Private constants
    
    private static let kSideMenuDefaultWidth: CGFloat = 260.0
    
    //
    // MARK: Internal usage
    
    /**
     Specifies the leading offset for the sidebar. If `menuSide` is set to *Left*,
     this means the space from superview's `minX` (usually 0). Otherwise from
     the `maxX` (depends on the screen's dimension).
     */
    internal let SideViewControllerOpenedLeadingOffset: CGFloat = 0.0
    
    internal let SideViewControllerOpenAnimationDuration: TimeInterval = 0.24
    
    fileprivate var _topViewController: UIViewController?
    fileprivate var _sideViewController: UIViewController?
    
    fileprivate var contentCoverView: UIView
    
    //
    // MARK: Public properties
    
    /**
     Determines the width of the side menu.
     */
    open var sideMenuWidth: CGFloat = SOContainerViewController.kSideMenuDefaultWidth {
        didSet {
            self.updateSideMenuFrame()
        }
    }
    
    /**
     Limit the width for the PanGestureRecognizer to prevent collision with UITableView (swipe to delete)
     */
    open var widthForPanGestureRecognizer: Int = 0
    
    /**
     Height offset when limiting the width for the PanGestureRecognizer (UINavigationBar)
     */
    open var heightOffsetForPanGestureRecognizer: Int = 0
    
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
    open var topViewController: UIViewController? {
        get {
            return _topViewController
        }
        set {
            _topViewController?.view.removeFromSuperview()
            _topViewController?.removeFromParentViewController()
            
            _topViewController = newValue
            
            if let vc = _topViewController {
                vc.willMove(toParentViewController: self)
                self.addChildViewController(vc)
                self.view.addSubview(vc.view)
                vc.view.frame = self.view.bounds
                vc.didMove(toParentViewController: self)
                
                if widthForPanGestureRecognizer > 0 {
                    let panView = UIView(frame: CGRect(x: 0, y: CGFloat(heightOffsetForPanGestureRecognizer), width: CGFloat(widthForPanGestureRecognizer), height: self.view.frame.size.height))
                    panView.backgroundColor = UIColor.clear
                    panView.addGestureRecognizer(self.createPanGestureRecognizer())
                    
                    vc.view.addSubview(panView)
                } else {
                    vc.view.addGestureRecognizer(self.createPanGestureRecognizer())
                }
            }
            
            self.bringSideViewToFront()
        }
    }
    
    /**
     A view controller that represents the sidebar menu.
     
     A view controller, that is assigned to this property, is hidden under the edge of the screen. When user makes a swipe gesture, it follows the finger and becomes visible.
     
     Usually you have to set it only once, when you prepare an instance of `SOContainerViewController` to be presented.
     */
    open var sideViewController: UIViewController? {
        get {
            return _sideViewController
        }
        set {
            _sideViewController?.view.removeFromSuperview()
            _sideViewController?.removeFromParentViewController()
            
            _sideViewController = newValue
            
            if let vc = _sideViewController {
                vc.willMove(toParentViewController: self)
                self.addChildViewController(vc)
                self.view.addSubview(vc.view)
                vc.didMove(toParentViewController: self)
                
                vc.view.addGestureRecognizer(self.createPanGestureRecognizer())
                
                var menuFrame = vc.view.frame
                menuFrame.size.width = self.sideMenuWidth
                menuFrame.size.height = self.view.bounds.size.height
                menuFrame.origin.x = menuSide == .left ? -menuFrame.size.width : view.frame.maxX + menuFrame.size.width
                vc.view.frame = menuFrame
            }
            
            self.bringSideViewToFront()
        }
    }
    
    open var isSideViewControllerPresented: Bool {
        get {
            guard let sideVC = self.sideViewController else {
                return false
            }
            
            return (menuSide == .left) ? (sideVC.view.frame.origin.x == SideViewControllerOpenedLeadingOffset) :
                (view.frame.width - sideVC.view.frame.maxX == SideViewControllerOpenedLeadingOffset)
        }
        set {
            guard let sideVC = self.sideViewController else {
                return
            }
            
            var frame = sideVC.view.frame
            if menuSide == .left {
                frame.origin.x = newValue ? SideViewControllerOpenedLeadingOffset : -frame.size.width
            } else {
                frame.origin.x = newValue ? view.frame.maxX - frame.width - SideViewControllerOpenedLeadingOffset : self.view.frame.width
            }
            
            let animations = { () -> () in
                sideVC.view.frame = frame
                self.contentCoverView.alpha = newValue ? 1.0 : 0.0
            }
            
            UIView.animate(withDuration: SideViewControllerOpenAnimationDuration, delay: 0, options: UIViewAnimationOptions.beginFromCurrentState, animations: animations, completion: nil)
        }
    }
    
    /**
     Determines where the side menu should come from.
     */
    open var menuSide: SOSide = .left
    
    /**
     
     */
    open var topViewControllerDimColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5) {
        didSet {
            self.contentCoverView.backgroundColor = self.topViewControllerDimColor
        }
    }
    
    //
    // MARK: Initialization
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.contentCoverView = UIView()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        self.contentCoverView = UIView()
        super.init(coder: aDecoder)
    }
    
    //
    // MARK: View controller life cycle
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        self.contentCoverView.frame = self.view.bounds
        self.contentCoverView.backgroundColor = self.topViewControllerDimColor
        self.contentCoverView.alpha = 0.0
        
        let tapOnContentCoverViewGesture = UITapGestureRecognizer(target: self, action: #selector(SOContainerViewController.contentCoverViewClicked))
        self.contentCoverView.addGestureRecognizer(tapOnContentCoverViewGesture)
        
        let panOnContentCoverVewGesture = UIPanGestureRecognizer(target: self, action: #selector(SOContainerViewController.contentCoverViewClicked))
        self.contentCoverView.addGestureRecognizer(panOnContentCoverVewGesture)
        
        self.view.addSubview(self.contentCoverView)
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.updateSideMenuFrame()
        self.contentCoverView.frame = self.view.bounds
    }
    
    private func updateSideMenuFrame() {
        guard let sideView = self.sideViewController?.view else {
            return
        }
        
        var frame = sideView.frame
        frame.size.width = self.sideMenuWidth
        if self.isSideViewControllerPresented {
            frame.origin.x = self.menuSide == .left ? 0.0 : self.view.frame.width - self.sideMenuWidth
        } else {
            frame.origin.x = self.menuSide == .left ? -self.sideMenuWidth : self.view.frame.width
        }
        sideView.frame = frame
    }
    
    //
    // MARK: Gesture recognizer delegate
    
    open func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let panGestureRecognizer = gestureRecognizer as! UIPanGestureRecognizer
        let translation = panGestureRecognizer.translation(in: self.view)
        return self.vectorIsMoreHorizontal(translation)
    }
    
}

//
// MARK: - Utils

extension SOContainerViewController {
    
    fileprivate func bringSideViewToFront() {
        self.view.bringSubview(toFront: self.contentCoverView)
        
        if let vc = self.sideViewController {
            self.view.bringSubview(toFront: vc.view)
        }
    }
    
    fileprivate func createPanGestureRecognizer() -> UIPanGestureRecognizer! {
        let gestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(SOContainerViewController.moveMenu(_:)))
        gestureRecognizer.edges = self.menuSide == .left ? .left : .right
        return gestureRecognizer
    }

}

//
// MARK: - UIPanGesture Geometry Utils

extension SOContainerViewController {
    
    fileprivate func vectorIsMoreHorizontal(_ point: CGPoint) -> Bool {
        if fabs(point.x) > fabs(point.y) {
            return true
        }
        return false
    }
    
    fileprivate func viewPulledOutMoreThanHalfOfItsWidth(_ viewController: UIViewController) -> Bool {
        let frame = viewController.view.frame
        
        if menuSide == .left{
            return fabs(frame.origin.x) < frame.size.width / 2
        }
        
        if menuSide == .right{
            return fabs(frame.origin.x) < self.view.frame.width - frame.size.width / 2
        }
        
        return false
        
    }
    
    fileprivate func moveSidebarToVector(_ sidebar: UIView, vector: CGPoint) {
        let calculatedXPosition = menuSide == .left ? min(sidebar.frame.size.width / 2.0, sidebar.center.x + vector.x) :
            max(sidebar.frame.size.width / 2.0, sidebar.center.x + vector.x)
        
        var shouldMove = false
        if self.menuSide == .left {
            shouldMove = calculatedXPosition < sidebar.frame.width / 2
        } else if self.menuSide == .right {
            shouldMove = calculatedXPosition - sidebar.frame.width / 2 > self.view.frame.width - sidebar.frame.width - SideViewControllerOpenedLeadingOffset
        }
        
        
        if shouldMove {
            sidebar.center = CGPoint(x: calculatedXPosition, y: sidebar.center.y)
        }
    }

}

//
// MARK: - Actions

extension SOContainerViewController {
    
    @IBAction internal func contentCoverViewClicked() {
        if self.isSideViewControllerPresented {
            self.isSideViewControllerPresented = false
        }
    }
    
    @IBAction internal func moveMenu(_ panGesture: UIPanGestureRecognizer) {
        panGesture.view?.layer.removeAllAnimations()
        
        let translatedPoint = panGesture.translation(in: self.view)
        
        if panGesture.state == UIGestureRecognizerState.changed {
            if let sidebarView = self.sideViewController?.view {
                self.moveSidebarToVector(sidebarView, vector: translatedPoint)
            }
            
            panGesture.setTranslation(CGPoint(x: 0, y: 0), in: self.view)
            
            if let view = self.sideViewController?.view {
                self.contentCoverView.alpha = 1.0 - abs(view.frame.origin.x) / view.frame.size.width
            }
        } else if panGesture.state == UIGestureRecognizerState.ended {
            if let sidebar = self.sideViewController {
                self.isSideViewControllerPresented = self.viewPulledOutMoreThanHalfOfItsWidth(sidebar)
            }
        }
    }

}
