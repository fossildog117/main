//
//  TableViewControllerV2.swift
//  Testing
//
//  Created by Nathan Liu on 12/03/2016.
//  Copyright © 2016 Liu Empire. All rights reserved.
//

import UIKit

class TableViewControllerV2: SuperViewController {
    
    func makeTableCells(list: UIView, numberOfCells: CGFloat, cellHeight: CGFloat, personArray: Array<Person>) -> Void {
        
        var tracker = 0
        for var i:CGFloat = 0; i < (cellHeight*numberOfCells); i = i + cellHeight {
            
            let screenWidth: CGFloat = UIScreen.mainScreen().bounds.size.width
            let button = personArray[tracker].getButton()
            button.frame = CGRectMake(-10, i, screenWidth+20, cellHeight)
            
            // Add features of button
            button.backgroundColor = personArray[tracker].getColor()
            button.layer.borderWidth = 0.5
            button.layer.borderColor = UIColor.whiteColor().CGColor
            button.addTarget(self, action: "buttonPressed:", forControlEvents: .TouchUpInside)
            list.addSubview(button)
            
            // Width of label
            let labelWidth: CGFloat = UIScreen.mainScreen().bounds.width - UIScreen.mainScreen().bounds.width/4
            
            // Add name
            var name: UILabel = UILabel(frame: CGRectMake(UIScreen.mainScreen().bounds.width/4, cellHeight/4, labelWidth, 20))
            name = configDefaultLabel(name, title: personArray[tracker].getName(), alignment: .Left)
            button.addSubview(name)
            
            // Add date
            var date: UILabel = UILabel(frame: CGRectMake(UIScreen.mainScreen().bounds.width/4, cellHeight - cellHeight/2 + 5, labelWidth, 20))
            date = configDefaultLabel(date, title: personArray[tracker].getDate(), alignment: .Left)
            date.font = UIFont(name: "Helvetica", size: 14)
            button.addSubview(date)
            
            let readHeight: CGFloat = 40
            
            // Has the user read the message
            var notification: UILabel = UILabel(frame: CGRectMake(UIScreen.mainScreen().bounds.width/8, cellHeight/4 - 5, labelWidth, readHeight))
            notification = configDefaultLabel(notification, title: ".", alignment: .Left)
            notification.font = UIFont(name: "Avenir-Heavy", size: readHeight)
            
            if personArray[tracker].hasRead() == false {
                notification.textColor = UIColorFromRGB(0x33ccff)
            } else {
                notification.textColor = personArray[tracker].getColor()
            }
            
            button.addSubview(notification)

            tracker += 1
        }
        tracker = 0
    }
    
    func makeView(list: Items, numberOfCells: CGFloat, cellHeight: CGFloat, data: Array<Person>) -> Void {
        
        let width = UIScreen.mainScreen().bounds.width
        let tableView: UIView
        var height: CGFloat
        
        // If the number of cells is smaller than the screen size then a
        // dummy scroll feature is implemented so the scrolling can still occur
        if cellHeight * numberOfCells < UIScreen.mainScreen().bounds.height {
            height = UIScreen.mainScreen().bounds.height - navBarHeight + 1
            print(1)
        } else {
            height = cellHeight*numberOfCells - navBarHeight + 1
            print(0)
        }
        
        // making the UIView a subview of the ScrollView
        tableView = UIView(frame: CGRectMake(0, 0, width, height))
        list.getView("UIScrollView").addSubview(tableView)
        
        // This makes the table scroll
        let x = list.getView("UIScrollView") as! UIScrollView
        x.contentSize = CGSizeMake(width, height)
        
        makeTableCells(tableView, numberOfCells: numberOfCells, cellHeight: cellHeight, personArray: data)
        
    }
    
    func configTable(view: UIView, numberOfCells: CGFloat, cellHeight: CGFloat, data: Array<Person>) -> Void {
        
        let list = Items.init(colour: UIColor.blackColor(), scroll: true)
        let listConstraints = ConstraintSet.init()
        
        view.addSubview(list.getView("UIScrollView"))
        
        // Set constraints
        
        listConstraints.add("H:|[list]|", opt: [], met: nil)
        listConstraints.add("V:|-\(navBarHeight)-[list]|", opt: [], met: nil)
        list.make(list.getView("UIScrollView") as! UIScrollView, set: listConstraints, name: "list")
        
        // Allows scrolling when table cells are pressed
        let nothingTap: UITapGestureRecognizer = UITapGestureRecognizer()
        nothingTap.delaysTouchesBegan = true
        list.getView("UIScrollView").addGestureRecognizer(nothingTap)
        
        makeView(list, numberOfCells: numberOfCells, cellHeight: cellHeight, data: data)
        
    }

}
