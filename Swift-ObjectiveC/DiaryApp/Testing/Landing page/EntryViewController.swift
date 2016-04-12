//
//  EntryViewController.swift
//  Testing
//
//  Created by Nathan Liu on 10/03/2016.
//  Copyright © 2016 Liu Empire. All rights reserved.
//

import UIKit

class EntryViewController: SuperViewController {
    
    let transitionManager = TransitionManager()
    
    private var name: String = ""
    private var date: String = ""
    private let indentSize: CGFloat = 10
    private let buffer: CGFloat = 10
    var storeArray: [Person] = [Person]()
    
    func setName(name: String) -> Void {
        self.name = name
    }
    
    func setDate(date: String) -> Void {
        self.date = date
    }
    
    func getImage() throws -> UIImage {
        return UIImage(data: NSData(contentsOfURL: NSURL(string:"https://www.smokeybarn.co.uk/media/coffee.jpg")!)!)!
    }
    
    func backButtonPressed(sender: AnyObject?) {
        
        transitionManager.setRight1(false)
        
        let newViewController: ViewController = ViewController()
        newViewController.personArray = storeArray
        newViewController.transitioningDelegate = self.transitionManager
        self.presentViewController(newViewController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configNavBar(name, includeBackButton: true)
        
        let image: UIImageView = UIImageView(frame: CGRectMake(0, self.navBarHeight, UIScreen.mainScreen().bounds.width , UIScreen.mainScreen().bounds.height * 0.3))
        image.contentMode = .ScaleToFill
        image.image = UIImage(named: "loading.001.png")
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), {
            
            do {
                try image.image = self.getImage()
            } catch {
                // Handle exception when image is not available
            }
            
        })
        
        self.view!.addSubview(image)
        
        var bounds = self.navBarHeight + image.bounds.height
        
        var dateLabel: UILabel = UILabel(frame: CGRectMake(indentSize, bounds + buffer, UIScreen.mainScreen().bounds.width, 20))
        dateLabel = configDefaultLabel(dateLabel, title: date, alignment: .Left)
        view.addSubview(dateLabel)
        
        bounds = bounds + buffer
        
        let entry: UITextView = UITextView(frame: CGRectMake(indentSize, bounds + buffer + buffer, UIScreen.mainScreen().bounds.width - (2*indentSize), UIScreen.mainScreen().bounds.height - bounds - 20))
        entry.text = "Antibiotics, also called antibacterials, are a type of antimicrobial[1] used in the treatment and prevention of bacterial infection.[2][3] They may either kill or inhibit the growth of bacteria. A limited number of antibiotics also possess antiprotozoal activity.[4][5] Antibiotics are not effective against viruses such as the common cold or influenza, and may be harmful when taken inappropriately. In 1928, Alexander Fleming identified penicillin, the first chemical compound with antibiotic properties. Fleming was working on a culture of disease-causing bacteria when he noticed the spores of little green mold in one of his culture plates. He observed that the presence of the mold killed or prevented the growth of the bacteria. Antibiotics revolutionized medicine in the 20th century, and have together with vaccination led to the near eradication of diseases such as tuberculosis in the developed world. Their effectiveness and easy access led to overuse, especially in livestock raising, prompting bacteria to develop resistance. This has led to widespread problems with antimicrobial and antibiotic resistance, so much as to prompt the World Health Organization to classify antimicrobial resistance as a \"serious threat [that] is no longer a prediction for the future, it is happening right now in every region of the world and has the potential to affect anyone, of any age, in any country\".[6] The era of antibacterial chemotherapy began with the discovery of arsphenamine, first synthesized by Alfred Bertheim and Paul Ehrlich in 1907, used to treat syphilis.[7][8] The first systemically active antibacterial drug, prontosil was discovered in 1933 by Gerhard Domagk,[8][9] for which he was awarded the 1939 Nobel Prize.[10] All classes of antibiotics in use today were first discovered prior to the mid 1980s.[11]"
        entry.backgroundColor = UIColor.clearColor()
        entry.textColor = UIColor.whiteColor()
        entry.editable = false
        view.addSubview(entry)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
