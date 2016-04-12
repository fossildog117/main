//
//  SuperViewController.swift
//  Testing
//
//  Created by Nathan Liu on 05/03/2016.
//  Copyright © 2016 Liu Empire. All rights reserved.
//

import UIKit

class SuperViewController: UIViewController {
    
    final let navBarHeight: CGFloat = 72
    
    var personArray: [Person] = [
        
        Person.init(name: "Nathan", date: "24th December 2015", color: UIColor.grayColor()),
        Person.init(name: "Harri", date: "1st January 2016", color: UIColor.darkGrayColor()),
        Person.init(name: "Hello", date: "8th Febuary 2016", color: UIColor.brownColor()),
        Person.init(name: "Bill", date: "9th Febuary 2016", color: UIColor.orangeColor()),
        Person.init(name: "Astrid", date: "14th Febuary 2016", color: UIColor.redColor()),
        
    ]
    
    // ---------------------------------------
    // Colour picker taken from stack overflow
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    // ---------------------------------------
    
    func configDefaultLabel(label: UILabel, title: String, alignment: NSTextAlignment) -> UILabel {
        
        label.text = title
        label.numberOfLines = 1
        label.baselineAdjustment = .AlignBaselines
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 10.0 / 12.0
        label.clipsToBounds = true
        label.backgroundColor = UIColor.clearColor()
        label.textColor = UIColor.whiteColor()
        label.textAlignment = alignment
        
        return label
        
    }
    
    func configNavBar(title: String, includeBackButton: Bool) -> Void {
        
        let navigationBar = Items.init(colour: UIColor.blackColor())
        view.addSubview(navigationBar.getView("UIView") )
        
        let navBarConstraints = ConstraintSet.init()
        navBarConstraints.add("V:|[navBar(\(navBarHeight))]", opt: [], met: nil)
        navBarConstraints.add("H:|[navBar]|", opt: [], met: nil)
        navigationBar.make(navigationBar.getView("UIView") ,set: navBarConstraints, name: "navBar")
        
        var fromLabel: UILabel = UILabel(frame: CGRectMake((UIScreen.mainScreen().bounds.size.width)/4, navBarHeight/4, (UIScreen.mainScreen().bounds.size.width)/2, navBarHeight/2))
        
        fromLabel = configDefaultLabel(fromLabel, title: title, alignment: .Center)
        
        navigationBar.getView("UIView").addSubview(fromLabel)
        
        if includeBackButton == true {
            
            let iconPos:CGFloat = 10
            
            let backButton: UIButton = UIButton()
            backButton.frame = CGRectMake(5, navBarHeight/4, (UIScreen.mainScreen().bounds.size.width)/4, navBarHeight/2)
            backButton.backgroundColor = UIColor.clearColor()
            backButton.layer.borderWidth = 0
            backButton.addTarget(self, action: "backButtonPressed:", forControlEvents: .TouchUpInside)
            navigationBar.getView("UIView").addSubview(backButton)
            
            
            // -------------------------------------------------------------------------------------------------
            // The unicode character for '<' was not the same size as normal text so I implemented two subviews
            // one subview for the unicode character where we can control the font size and the other subview
            // for the "Back" string. In retrospect I think an image implementation may have been better in terms of
            // UI however it's always interesting to see unicode being used
            
            let backIcon: UILabel = UILabel(frame: CGRectMake(iconPos, navBarHeight/8 - 2, iconPos, iconPos * 2))
            backIcon.backgroundColor = UIColor.clearColor()
            backIcon.textColor = UIColor.whiteColor()
            backIcon.text = "\u{2039}"
            backIcon.font = UIFont(name: "Helvetica", size: 36)
            backButton.addSubview(backIcon)
            
            var backLabel: UILabel = UILabel(frame: CGRectMake(iconPos + 10, navBarHeight/8, iconPos * 4, iconPos * 2))
            backLabel = configDefaultLabel(backLabel, title: " Back", alignment: .Left)
            backButton.addSubview(backLabel)
            
            // -------------------------------------------------------------------------------------------------
            
        }
        
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        self.view.backgroundColor = UIColor.blackColor()
        return .LightContent
    }
    
//    func loadDefaultSettings() -> Void {
//        ViewController().getView().backgroundColor = UIColor.blackColor()
//        navigationBar.barTintColor = UIColor.blackColor()
//        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
//    }

}

