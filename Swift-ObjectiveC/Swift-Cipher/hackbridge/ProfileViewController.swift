//
//  ProfileViewController.swift
//  hackbridge
//
//  Created by Nathan Liu on 30/01/2016.
//  Copyright © 2016 Liu Empire. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    var candidate: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print(candidate)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
