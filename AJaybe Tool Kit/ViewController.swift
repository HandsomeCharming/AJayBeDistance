//
//  ViewController.swift
//  AJaybe Tool Kit
//
//  Created by  Handa Zhang on 5/9/16.
//  Copyright © 2016 Handa Zhang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func observeMeasure(sender: AnyObject) {
        let firstCap = self.storyboard?.instantiateViewControllerWithIdentifier("FirstCapture") as! FirstCapture
        self.presentViewController(firstCap, animated: false, completion: nil)
    }
    
    @IBAction func gpsMeasure(sender: AnyObject) {
        let map = self.storyboard?.instantiateViewControllerWithIdentifier("MapMeasure") as! MapViewController
        self.presentViewController(map, animated: false, completion: nil)
    }
    
    func goToObserve() {
    }

}

