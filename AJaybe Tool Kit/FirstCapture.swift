//
//  FirstCapture.swift
//  AJaybe Tool Kit
//
//  Created by  Handa Zhang on 5/9/16.
//  Copyright © 2016 Handa Zhang. All rights reserved.
//

import UIKit
import AVFoundation
import CoreMotion
import CoreLocation

class FirstCapture : UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let imagePicker: UIImagePickerController! = UIImagePickerController()
    let currentImage : UIImageView! = UIImageView()
    @IBOutlet weak var crosshair: UIImageView!
    
    var showHelp : Bool = false
    var canTake : Bool = false
    @IBOutlet var helpLabel: UILabel!
    @IBOutlet var blockingButton: UIButton!
    @IBOutlet var RetakeButton: UIButton!
    @IBOutlet var usePhotoButton: UIButton!
    @IBOutlet var captureButton: UIButton!
    
    var azimuth : Double = 0
    var roll : Double = 0
    var pitch : Double = 0
    
    let motionManager = CMMotionManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (UIImagePickerController.isSourceTypeAvailable(.Camera)) {
            if UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil {
                //Initiate imagePicker
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .Camera
                imagePicker.cameraCaptureMode = .Photo
                imagePicker.cameraFlashMode = .Off
                imagePicker.showsCameraControls = false
                imagePicker.delegate = self
                imagePicker.view.frame.origin.y = 60;
                self.view.addSubview(imagePicker.view);
                
                currentImage.frame = imagePicker.view.frame;
                currentImage.frame.size.height = currentImage.frame.size.height - 170;
                currentImage.hidden = true
                self.view.addSubview(currentImage)
                
                if motionManager.deviceMotionAvailable {
                    motionManager.deviceMotionUpdateInterval = 0.1;
                    motionManager.startDeviceMotionUpdates()
                }
                
                locationManager.startUpdatingHeading()
                canTake = true
            } else {
                print("No rear camera")
            }
        } else {
            print("Camera inaccessable")
        }
    }
    
    @IBAction func usePhoto(sender: AnyObject) {
        //Store data
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setDouble(azimuth, forKey: "FirstAzi")
        defaults.setDouble(pitch, forKey: "FirstPit")
        defaults.setDouble(roll, forKey: "FirstRoll")
        
        //Stop updates
        motionManager.stopDeviceMotionUpdates()
        locationManager.stopUpdatingHeading()
        
        //Go to next view
        let secondIns = self.storyboard?.instantiateViewControllerWithIdentifier("SecondInstruction") as! SecondInstruction
        self.presentViewController(secondIns, animated: false, completion: nil)
    }
    
    @IBAction func retakePic(sender: AnyObject) {
        //Retake pic and configuration
        currentImage.image = nil
        currentImage.hidden = true
        RetakeButton.hidden = true
        usePhotoButton.hidden = true
        captureButton.hidden = false
    }
    
    @IBAction func clickHelpButton(sender: AnyObject) {
        if showHelp {
            showHelp = false
            helpLabel.hidden = true
            blockingButton.hidden = true
        } else {
            showHelp = true
            helpLabel.hidden = false
            blockingButton.hidden = false
        }
    }
    
    @IBAction func hideHelp(sender: AnyObject) {
        if showHelp {
            showHelp = false
            helpLabel.hidden = true
            blockingButton.hidden = true
        }
    }
    
    @IBAction func returnToLastView(sender: AnyObject) {
        motionManager.stopDeviceMotionUpdates()
        locationManager.stopUpdatingHeading()
        
        dismissViewControllerAnimated(false, completion: {})
    }
    
    @IBAction func capturePhoto(sender: AnyObject) {
        //Capture photo
        if canTake == false {
            return
        }
        //If help is showing, hide help
        if showHelp {
            showHelp = false
            helpLabel.hidden = true
            blockingButton.hidden = true
        } else {
            //store location and motion data
            if locationManager.heading != nil {
                azimuth = (locationManager.heading?.magneticHeading)!
                print((locationManager.heading?.magneticHeading))
            }
            if motionManager.deviceMotion != nil {
                roll = (motionManager.deviceMotion?.attitude.roll)!*180/M_PI
                pitch = (motionManager.deviceMotion?.attitude.pitch)!*180/M_PI
                print((motionManager.deviceMotion?.attitude.roll)!*57.3)
                print((motionManager.deviceMotion?.attitude.pitch)!*57.3)
                //print((motionManager.deviceMotion?.attitude.yaw)!*57.3)
            }
            imagePicker.takePicture()
            captureButton.hidden = true
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage:UIImage = (info[UIImagePickerControllerOriginalImage]) as? UIImage {
            //Delegate after taking photo
            currentImage.image = pickedImage
            currentImage.hidden = false
            RetakeButton.hidden = false
            usePhotoButton.hidden = false
        }
        imagePicker.dismissViewControllerAnimated(false, completion: {
        })
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(false, completion: {
        })
    }
}