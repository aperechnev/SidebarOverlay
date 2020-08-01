//
//  SOSide.swift
//  SidebarOverlay
//
//  Created by Alexander Perechnev on 15.07.16.
//  Copyright © 2016 Alexander Perechnev. All rights reserved.
//


/**
 Enumeration that you can use to set the side where side view controller should be placed.
 
 - SeeAlso: `SOContainerViewController.menuSide`
 */
public enum SOSide {
    
    /**
     Use this case to place side view controller on the left side.
     */
    case left
    
    /**
     Use this case to place side view controller on the right side.
     */
    case right
    
}


@available(*, unavailable, renamed: "SOSide")
public typealias Side = SOSide
