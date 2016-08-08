//
//  ViewController.swift
//  PointsDistance
//
//  Created by Donghua Xue on 5/6/16.
//  Copyright © 2016 donghuaxue. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {


    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    var uilgr = UILongPressGestureRecognizer()
    var center = CLLocationCoordinate2D()
    var annotations = Array<MKPointAnnotation>() // manage all annotations setted by user
    
    @IBAction func currentLocationPressed(sender: UIButton) { //add a annotation of user's current location
        let annotation = MKPointAnnotation()
        annotation.coordinate = center
        if (annotations.count == 2) {                        // when user already has two annotations, remove the first one
            self.mapView.removeAnnotation(annotations[0])
            annotations.removeFirst()
        }
        self.mapView.addAnnotation(annotation)
        annotations.append(annotation)
        
        distanceCalculation()
        
    }
    
    @IBAction func returnToLastView(sender: AnyObject) {
        dismissViewControllerAnimated(false, completion: {})
    }
    
    func distanceCalculation(){     //calculate two points' distance
        if annotations.count == 2 {
            
            let firstLocation = CLLocation(latitude: annotations[0].coordinate.latitude, longitude: annotations[0].coordinate.longitude)
            let secondLocation = CLLocation(latitude: annotations[1].coordinate.latitude, longitude: annotations[1].coordinate.longitude)
            let distance = firstLocation.distanceFromLocation(secondLocation) //using distancefromlocation to easily get distance of two points
            self.distanceLabel.text = "\(Int(distance)) Meters"
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        distanceLabel.text = ""
        
        self.locationManager.delegate = self                                     //set corelocation delegate
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true
        
        uilgr = UILongPressGestureRecognizer(target: self, action: "addAnnotation:") // add longpressgesturerecognizer
        uilgr.minimumPressDuration = 1.0
        self.mapView.addGestureRecognizer(uilgr)
        
    }

    // MARK: - Location Delegate Methods
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) { //when user's location is available it will call this function
        let location = locations.last
        center = CLLocationCoordinate2DMake(location!.coordinate.latitude, location!.coordinate.longitude)
        let region = MKCoordinateRegionMake(center, MKCoordinateSpan(latitudeDelta: 1,longitudeDelta: 1)) //zoom to (1,1) scale of maps
        self.mapView.setRegion(region, animated: true)
        self.locationManager.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Errors: " + error.localizedDescription)
    }
    
 
    
    func addAnnotation(gestureRecognizer: UIGestureRecognizer) { // when there is a long press, it will put a annotation on maps
        if gestureRecognizer.state == UIGestureRecognizerState.Began { // to prevent multiple annotations putted with one long press
            
            let touchPoint = gestureRecognizer.locationInView(self.mapView)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = self.mapView.convertPoint(touchPoint, toCoordinateFromView: self.mapView)
            
            if (annotations.count == 2) {                      //maximum two annotations
                self.mapView.removeAnnotation(annotations[0]) // when already two annotations putted, remove the first one
                annotations.removeFirst()
            }
            self.mapView.addAnnotation(annotation) // add a new one
            annotations.append(annotation)
            
            distanceCalculation()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

