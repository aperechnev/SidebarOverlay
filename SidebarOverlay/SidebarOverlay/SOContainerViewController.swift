//
//  SOContainerViewController.swift
//  SidebarOverlay
//
//  Created by Alexander Perechnev on 12/23/15.
//  Copyright © 2015 Alexander Perechnev. All rights reserved.
//

import UIKit


public extension UIViewController {
    
    var so_containerViewController: SOContainerViewController? {
        var parentVC: UIViewController? = self
        
        repeat {
            if parentVC is SOContainerViewController {
                return parentVC as? SOContainerViewController
            }
            parentVC = parentVC!.parentViewController
        }
        while (parentVC != nil)
        
        return nil
    }
    
}


public class SOContainerViewController: UIViewController, UIGestureRecognizerDelegate {
    
    let LeftViewControllerRightIndent: CGFloat = 56.0
    let LeftViewControllerOpenedLeftOffset: CGFloat = 0.0
    let SideViewControllerOpenAnimationDuration: NSTimeInterval = 0.24
    
    var _topViewController: UIViewController?
    var _leftViewController: UIViewController?
    
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
            }
            
            UIView.animateWithDuration(SideViewControllerOpenAnimationDuration, delay: 0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: animations, completion: nil)
        }
    }
    
    public func moveMenu(panGesture: UIPanGestureRecognizer) {
        panGesture.view?.layer.removeAllAnimations()
        
        let translatedPoint = panGesture.translationInView(self.view)
        
        if panGesture.state == UIGestureRecognizerState.Changed {
            let menuView = self.leftViewController?.view
            var calculatedXPosition = (menuView?.center.x)! + translatedPoint.x
            
            calculatedXPosition = min((menuView?.frame.size.width)! / 2.0, calculatedXPosition)
            
            menuView?.center = CGPointMake(calculatedXPosition, (menuView?.center.y)!)
            panGesture.setTranslation(CGPointMake(0, 0), inView: self.view)
        }
        else if panGesture.state == UIGestureRecognizerState.Ended {
            let isMenuPulledEnoghToOpenIt = fabs((self.leftViewController?.view.frame.origin.x)!) < (self.leftViewController?.view.frame.size.width)! / 2
            
            self.isLeftViewControllerPresented = isMenuPulledEnoghToOpenIt
        }
    }
    
    public func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        let panGestureRecognizer = gestureRecognizer as! UIPanGestureRecognizer
        let translation = panGestureRecognizer.translationInView(self.view)
        if fabs(translation.x) > fabs(translation.y) {
            return true
        }
        return false
    }
    
    func createPanGestureRecognizer() -> UIPanGestureRecognizer! {
        return UIPanGestureRecognizer.init(target: self, action: "moveMenu:")
    }
    
    internal func brindLeftViewToFront() {
        if let vc = self.leftViewController {
            self.view.bringSubviewToFront(vc.view)
        }
    }
    
}
