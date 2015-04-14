//
//  ViewController.swift
//  Maps
//
//  Created by Richard Tyran on 2/2/15.
//  Copyright (c) 2015 Richard Tyran. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

var onceToken: dispatch_once_t = 0

// add protocol delegate to the class

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    var lManager = CLLocationManager()
    var mapView = MKMapView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set view to full screen using view.frame:
        
        mapView.frame = view.frame
        mapView.delegate = self
        
        view.addSubview(mapView)
        
        lManager.requestWhenInUseAuthorization()
        
        lManager.delegate = self
        
        // the more accurate, the more battery runoff
        lManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // how often will location update:
        lManager.distanceFilter = 1000
        
        lManager.startUpdatingLocation()
        
        mapView.showsUserLocation = true
        
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        //        static dispatch_once_t onceToken;
        //
        //        dispatch_once (&onceToken, ^{
        //        // Do some work that happens once
        //        });
        
        // this prevents location from being printed multiple times
        
        dispatch_once(&onceToken) { () -> Void in
            
            println(locations.last)
            
            // "as?" is casting last as on optional CLLocation
            
            if let location = locations.last as? CLLocation {
                
                // self.mapView.centerCoordinate = location.coordinate
                
                // scale below is degrees
                
                let span = MKCoordinateSpanMake(0.001, 0.001)
                
                let region = MKCoordinateRegion(center: location.coordinate, span: span)
                
                self.mapView.setRegion(region, animated: true)
                
                let venues = FourSquareRequest.requestVenuesWithLocation(location)
                
                println(venues)
                
                self.createAnnotionsWithVenues(venues)
            
                // request to foursquare for venues with location
                
            }
            
        }
        
        lManager.stopUpdatingLocation()
        
    }
    
    func createAnnotionsWithVenues(venues: [AnyObject]) {
        
        for venue in venues as [[String:AnyObject]] {
            
            let locationName = venue["name"] as String
            
            println("my location's name is \(locationName)")
            
            let locationInfo = venue["location"] as [String:AnyObject]
            
            let lat = locationInfo["lat"] as CLLocationDegrees
            let lng = locationInfo["lng"] as CLLocationDegrees
            
            let coordinate = CLLocationCoordinate2DMake(lat,lng)
            
            let annotation = MKPointAnnotation()
            annotation.setCoordinate(coordinate)
            annotation.title = locationName
            
            mapView.addAnnotation(annotation)
            
        }
        
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        
        if (annotation.isKindOfClass(MKUserLocation)){
            return nil
        }
        var myPin = mapView.dequeueReusableAnnotationViewWithIdentifier("MyIdentifier") as? MKPinAnnotationView
        
        if myPin != nil {
            return myPin
        }
        
        myPin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "MyIdentifier")
        myPin?.pinColor = .Green
        myPin?.canShowCallout = true
        return myPin
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

