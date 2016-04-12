//
//  Person.swift
//  Testing
//
//  Created by Nathan Liu on 05/03/2016.
//  Copyright © 2016 Liu Empire. All rights reserved.
//

import UIKit
    
class Person {
    
    private var name: String
    private var date: String
    private var cellColor: UIColor
    private var read: Bool
    private var button: UIButton
    private var tracker: Int = 0
    private let rowAtIndexPath1: Int
    
    internal func getName() -> String {
        return self.name
    }
    
    internal func getDate() -> String {
        return self.date
    }
    
    internal func getColor() -> UIColor {
        return self.cellColor
    }
    
    internal func hasRead() -> Bool {
        return self.read
    }
    
    internal func setRead(read: Bool) -> Void {
        self.read = read
    }
    
    internal func getButton() -> UIButton {
        return self.button
    }
    
    internal func rowAtIndexPath() -> Int {
        return self.rowAtIndexPath1
    }
    
    init (name: String, date: String, color: UIColor) {
        self.name = name
        self.date = date
        self.cellColor = color
        self.read = false
        self.button = UIButton()
        self.rowAtIndexPath1 = tracker
        tracker += 1
    }
}



