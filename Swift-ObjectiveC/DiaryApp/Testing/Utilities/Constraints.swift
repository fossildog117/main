//
//  Table.swift
//  Testing
//
//  Created by Nathan Liu on 05/03/2016.
//  Copyright © 2016 Liu Empire. All rights reserved.
//

import UIKit

class Constraint {
    
    private var format: String
    private var option: NSLayoutFormatOptions
    private var metric: [String : AnyObject]?
    
    internal func getFormat() -> String {
        return format
    }
    
    internal func getOption() -> NSLayoutFormatOptions {
        return option
    }
    
    internal func getMetric() -> [String : AnyObject]? {
        return metric
    }
    
    init(format: String, option: NSLayoutFormatOptions, metric: [String : AnyObject]?) {
        self.format = format
        self.option = option
        self.metric = metric
    }
}

class ConstraintSet {
    
    private var constraints: [Constraint]
    
    internal func getConstraintAtIndex(i: Int) -> Constraint {
        return constraints[i]
    }
    
    internal func getConstraintArray() -> [Constraint] {
        return constraints
    }
    
    internal func add(form: String, opt: NSLayoutFormatOptions, met: [String : AnyObject]?) -> Void {
        let cons = Constraint.init(format: form, option: opt, metric: met)
        constraints.append(cons)
    }
    
    init() {
        self.constraints = [Constraint]()
    }
}
