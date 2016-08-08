//
//  Results.swift
//  AJaybe Tool Kit
//
//  Created by  Handa Zhang on 5/10/16.
//  Copyright © 2016 Handa Zhang. All rights reserved.
//

import UIKit
import MessageUI

class Results: UIViewController, MFMessageComposeViewControllerDelegate {
    @IBOutlet var firstUnitLabel: UILabel!
    
    @IBOutlet var secondUnitLabel: UILabel!
    @IBOutlet var thirdUnitLabel: UILabel!
    @IBOutlet var firstUnitButton: UIButton!
    @IBOutlet var secondUnitButton: UIButton!
    @IBOutlet var thirdUnitButton: UIButton!
    
    @IBOutlet var stLabel: UILabel!
    @IBOutlet var verLabel: UILabel!
    @IBOutlet var horLabel: UILabel!
    var isMeter : Bool = true
    
    var horDist : Double = 0
    var verDist : Double = 0
    var stDist : Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calcDistance()
    }
    
    @IBAction func sendMessage(sender: AnyObject) {
        var messageVC = MFMessageComposeViewController()
        
        messageVC.body = String(format: "Horizontal Distance: %.2f, Vertical Distance: %.2f, Straight Distance: %.2f", horDist, verDist, stDist);
        messageVC.messageComposeDelegate = self;
        
        self.presentViewController(messageVC, animated: false, completion: nil)
    }
    
    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    func calcDistance() {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        let isM = defaults.boolForKey("isMeter")
        if isM == false {
            changeUnitWithoutChangingNumbers()
        }
        
        //Get data from captures
        let firstAzi = defaults.doubleForKey("FirstAzi")
        let firstPit = defaults.doubleForKey("FirstPit")
        let firstRoll = defaults.doubleForKey("FirstRoll")
        
        let secAzi = defaults.doubleForKey("SecondAzi")
        let secPit = defaults.doubleForKey("SecondPit")
        let secRoll = defaults.doubleForKey("SecondRoll")
        
        let gapDist = defaults.doubleForKey("gapDist")
        
        if abs(secAzi - firstAzi) > 90 && 360 - abs(secAzi - firstAzi) > 90 {
            print("Invalid input")
            return
        }
        
        //compute distance
        horDist = gapDist / tan(abs(secAzi - firstAzi)*M_PI/180)
        verDist = horDist / tan(-firstPit*M_PI/180)
        if abs(firstRoll) < 90 {
            verDist = -verDist
        }
        stDist = sqrt((horDist*horDist) + (verDist*verDist))
        
        //Change labels
        horLabel.text = String(format:"%.2f", horDist)
        verLabel.text = String(format:"%.2f",verDist)
        stLabel.text = String(format:"%.2f",stDist)
    }
    
    @IBAction func goToMainMenu(sender: AnyObject) {
        //Go to main menu
        let menu = self.storyboard?.instantiateViewControllerWithIdentifier("MainMenu") as! ViewController
        self.presentViewController(menu, animated: false, completion: nil)
    }
    
    func changeUnitWithoutChangingNumbers() {
        //changeUnitWithoutChangingNumbers, just change the labels
        if isMeter {
            isMeter = false
            firstUnitLabel.text = "Inches/"
            secondUnitLabel.text = "Inches/"
            thirdUnitLabel.text = "Inches/"
            firstUnitButton.setTitle("Meters", forState: UIControlState.Normal)
            secondUnitButton.setTitle("Meters", forState: UIControlState.Normal)
            thirdUnitButton.setTitle("Meters", forState: UIControlState.Normal)
        } else {
            isMeter = true
            firstUnitLabel.text = "Meters/"
            secondUnitLabel.text = "Meters/"
            thirdUnitLabel.text = "Meters/"
            firstUnitButton.setTitle("Inches", forState: UIControlState.Normal)
            secondUnitButton.setTitle("Inches", forState: UIControlState.Normal)
            thirdUnitButton.setTitle("Inches", forState: UIControlState.Normal)
        }
    }
    
    
    
    @IBAction func changeUnits(sender: AnyObject) {
        //Change units from meters to inches or from inches to meters
        //And change text in labels.
        if isMeter {
            isMeter = false
            firstUnitLabel.text = "Inches/"
            secondUnitLabel.text = "Inches/"
            thirdUnitLabel.text = "Inches/"
            firstUnitButton.setTitle("Meters", forState: UIControlState.Normal)
            secondUnitButton.setTitle("Meters", forState: UIControlState.Normal)
            thirdUnitButton.setTitle("Meters", forState: UIControlState.Normal)
            horDist = horDist*39.3701
            verDist = verDist*39.3701
            stDist = stDist*39.3701
            horLabel.text = String(format:"%.2f", horDist)
            verLabel.text = String(format:"%.2f",verDist)
            stLabel.text = String(format:"%.2f",stDist)
        } else {
            isMeter = true
            firstUnitLabel.text = "Meters/"
            secondUnitLabel.text = "Meters/"
            thirdUnitLabel.text = "Meters/"
            firstUnitButton.setTitle("Inches", forState: UIControlState.Normal)
            secondUnitButton.setTitle("Inches", forState: UIControlState.Normal)
            thirdUnitButton.setTitle("Inches", forState: UIControlState.Normal)
            horDist = horDist/39.3701
            verDist = verDist/39.3701
            stDist = stDist/39.3701
            horLabel.text = String(format:"%.2f", horDist)
            verLabel.text = String(format:"%.2f",verDist)
            stLabel.text = String(format:"%.2f",stDist)
        }
    }
}
