//
//  NavBar.swift
//  Testing
//
//  Created by Nathan Liu on 05/03/2016.
//  Copyright © 2016 Liu Empire. All rights reserved.
//

import UIKit

class Items {
    
    private let view: UIView
    
    internal func getView(type: String) -> UIView {
        
        switch type {
        case "UIScrollView" :
            return view as! UIScrollView
        case "UIView":
            return view as UIView
        default:
            return view as UIView
        }
    }
    
    init(colour: UIColor, scroll: Bool) {
        view = UIScrollView()
        view.backgroundColor=colour
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    init(colour: UIColor) {
        view = UIView()
        view.backgroundColor=colour
        view.translatesAutoresizingMaskIntoConstraints = false
    }

    func make(view1: UIView, set: ConstraintSet, name: String) -> Void {
        
        let views = [name : view1]
        
        for i in 0 ..< set.getConstraintArray().count {
            let h = NSLayoutConstraint.constraintsWithVisualFormat(set.getConstraintAtIndex(i).getFormat(), options: set.getConstraintAtIndex(i).getOption(), metrics: set.getConstraintAtIndex(i).getMetric(), views: views)
            NSLayoutConstraint.activateConstraints(h)
        }
    }
}
