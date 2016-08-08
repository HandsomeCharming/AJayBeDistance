//
//  SecondCapture.swift
//  AJaybe Tool Kit
//
//  Created by  Handa Zhang on 5/10/16.
//  Copyright © 2016 Handa Zhang. All rights reserved.
//

import UIKit
import CoreMotion
import CoreLocation

class SecondCapture: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
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
                //Initialize imagePicker and add as subview
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
                
                //Add motion manager and location manager to capture motion and heading
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
        //Store captured data
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setDouble(azimuth, forKey: "SecondAzi")
        defaults.setDouble(pitch, forKey: "SecondPit")
        defaults.setDouble(roll, forKey: "SecondRoll")
        
        //Stop updates
        motionManager.stopDeviceMotionUpdates()
        locationManager.stopUpdatingHeading()
        
        //Go to next view
        let res = self.storyboard?.instantiateViewControllerWithIdentifier("Results") as! Results
        self.presentViewController(res, animated: false, completion: nil)
    }
    
    @IBAction func retakePic(sender: AnyObject) {
        //Retake picture and configurations
        currentImage.image = nil
        currentImage.hidden = true
        RetakeButton.hidden = true
        usePhotoButton.hidden = true
        captureButton.hidden = false
    }
    
    @IBAction func clickHelpButton(sender: AnyObject) {
        //Show help
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
        //Hide help
        if showHelp {
            showHelp = false
            helpLabel.hidden = true
            blockingButton.hidden = true
        }
    }
    
    @IBAction func returnToLastView(sender: AnyObject) {
        dismissViewControllerAnimated(false, completion: {})
    }
    
    @IBAction func capturePhoto(sender: AnyObject) {
        //capture photo and capture the heading and motion data.
        if canTake == false {
            return
        }
        if showHelp {
            showHelp = false
            helpLabel.hidden = true
            blockingButton.hidden = true
        } else {
            if motionManager.deviceMotion != nil {
                azimuth = (locationManager.heading?.magneticHeading)!
                roll = (motionManager.deviceMotion?.attitude.roll)!*180/M_PI
                pitch = (motionManager.deviceMotion?.attitude.pitch)!*180/M_PI
            }
            imagePicker.takePicture()
            captureButton.hidden = true
        }
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage:UIImage = (info[UIImagePickerControllerOriginalImage]) as? UIImage {
            //Delegate of after taking picture
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
