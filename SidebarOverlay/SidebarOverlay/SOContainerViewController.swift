//
//  SOContainerViewController.swift
//  SidebarOverlay
//
//  Created by Alexander Perechnev on 12/23/15.
//  Copyright © 2015 Alexander Perechnev. All rights reserved.
//

import UIKit


let LeftViewControllerRightIndent: CGFloat = 56.0
let LeftViewControllerOpenedLeftOffset: CGFloat = 0.0
let SideViewControllerOpenAnimationDuration: NSTimeInterval = 0.24


public protocol SOContainerViewControllerDelegate {
    
    func leftViewControllerPulledOut(pulledOut: Bool)
    
}


public extension UIViewController {
    
    func so_container() -> SOContainerViewController? {
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


public class SOContainerViewController: UIViewController {
    
    public var delegate: SOContainerViewControllerDelegate?
    
    public var topViewController: UIViewController? {
        didSet {
            oldValue?.view.removeFromSuperview()
            oldValue?.removeFromParentViewController()
            
            if let topVC = self.topViewController {
                topVC.willMoveToParentViewController(self)
                
                self.addChildViewController(topVC)
                self.view.addSubview(topVC.view)
                
                topVC.didMoveToParentViewController(self)
                
                topVC.view.addGestureRecognizer(self.createPanGestureRecognizer())
                
                self.view.bringSubviewToFront(self.view)
            }
            
            if let vc = self.leftViewController {
                self.view.bringSubviewToFront(vc.view)
            }
        }
    }
    
    public var leftViewController: UIViewController? {
        didSet {
            self.view.addSubview((self.leftViewController?.view)!)
            self.addChildViewController(self.leftViewController!)
            self.leftViewController?.didMoveToParentViewController(self)
            
            self.view.bringSubviewToFront((self.leftViewController?.view)!)
            
            var menuFrame = self.leftViewController?.view.frame
            menuFrame?.size.width = self.view.frame.size.width - LeftViewControllerRightIndent
            menuFrame?.origin.x = -(menuFrame?.size.width)!
            self.leftViewController?.view.frame = menuFrame!
            
            self.leftViewController?.view.addGestureRecognizer(self.createPanGestureRecognizer())
        }
    }
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(self.createPanGestureRecognizer())
    }
    
    public func setMenuOpened(opened: Bool) {
        var frameToApply = self.leftViewController?.view.frame
        frameToApply?.origin.x = opened ? LeftViewControllerOpenedLeftOffset : -(self.leftViewController?.view.frame.size.width)!
        
        let animations: () -> () = {
            self.leftViewController?.view.frame = frameToApply!
        }
        
        UIView.animateWithDuration(SideViewControllerOpenAnimationDuration, delay: 0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: animations, completion: nil)
        
        self.delegate?.leftViewControllerPulledOut(opened)
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
            
            self.setMenuOpened(isMenuPulledEnoghToOpenIt)
        }
    }
    
    private func createPanGestureRecognizer() -> UIPanGestureRecognizer! {
        let  panGestureRecognizer = UIPanGestureRecognizer.init(target: self, action: "moveMenu:")
        panGestureRecognizer.maximumNumberOfTouches = 1
        panGestureRecognizer.minimumNumberOfTouches = 1
        return panGestureRecognizer
    }
    
}
