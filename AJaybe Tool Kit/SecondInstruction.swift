//
//  SecondInstruction.swift
//  AJaybe Tool Kit
//
//  Created by  Handa Zhang on 5/10/16.
//  Copyright © 2016 Handa Zhang. All rights reserved.
//

import UIKit

class SecondInstruction: UIViewController {
    @IBOutlet var textField: UITextField!
    
    @IBOutlet var firstButton: UIButton!
    @IBOutlet var secondButton: UIButton!
    
    var isMeter : Bool = true
    var dist : Double = 0
    
    @IBAction func returnToLast(sender: AnyObject) {
        dismissViewControllerAnimated(false, completion: {})
    }
    
    @IBAction func clickNext(sender: AnyObject) {
        //Check for input
        if textField.text?.isEmpty == true {
            return
        }
        //Store input
        dist = Double(textField.text!)!
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(isMeter, forKey: "isMeter")
        defaults.setDouble(dist, forKey: "gapDist")
        
        //Go to next scene
        let secondCap = self.storyboard?.instantiateViewControllerWithIdentifier("SecondCapture") as! SecondCapture
        self.presentViewController(secondCap, animated: false, completion: nil)
    }
    
    @IBAction func changeUnit(sender: AnyObject) {
        if isMeter == true {
            isMeter = false
            firstButton.titleLabel?.text = "Inches/"
            firstButton.setTitle("Inches/", forState: UIControlState.Normal)
            secondButton.titleLabel?.text = "meters"
            secondButton.setTitle("meters", forState: UIControlState.Normal)
        } else {
            isMeter = true
            firstButton.titleLabel?.text = "Meters/"
            firstButton.setTitle("Meters/", forState: UIControlState.Normal)
            firstButton.frame.size.width = 105
            secondButton.titleLabel?.text = "inches"
            secondButton.setTitle("inches", forState: UIControlState.Normal)
        }
    }
}

