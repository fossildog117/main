//
//  ViewController.swift
//  Testing
//
//  Created by Nathan Liu on 05/03/2016.
//  Copyright © 2016 Liu Empire. All rights reserved.
//

import UIKit

class ViewController: TableViewControllerV2 {
    
    let transitionManager = TransitionManager()
    
    @IBAction func nextSegue(selectedIndexRow: Int) {
        
        transitionManager.setRight1(true)
        
        let newViewController: EntryViewController = EntryViewController()
        newViewController.setName(personArray[selectedIndexRow].getName())
        newViewController.setDate(personArray[selectedIndexRow].getDate())
        newViewController.view.backgroundColor = UIColor.blackColor()
        newViewController.storeArray = personArray
        
        newViewController.transitioningDelegate = self.transitionManager
        self.presentViewController(newViewController, animated: true, completion: nil)
        
    }
        
    func getPersonArrayAtIndex(i: Int) -> UIButton {
        return personArray[i].getButton()
    }
    
    func buttonPressed(sender: AnyObject?) {
        
        let selectedCell: UIButton = (sender as! UIButton)
        
        if ((sender?.isMemberOfClass(Person)) != nil) {
            for i in 0 ..< personArray.count {
                if personArray[i].getButton() == selectedCell {
                    personArray[i].setRead(true)
                    nextSegue(i)
                    print(personArray[i].getName())
                    self.view.setNeedsDisplay()
                    break
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configNavBar("My diary", includeBackButton: false)
        configTable(view, numberOfCells: CGFloat(personArray.count), cellHeight: 80, data: personArray)
        
        for i in 0 ..< personArray.count {
            if personArray[i].hasRead() == false {
                print(personArray[i].getName())
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}



