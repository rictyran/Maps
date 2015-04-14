//
//  FourSquareRequest.swift
//  Maps
//
//  Created by Richard Tyran on 2/2/15.
//  Copyright (c) 2015 Richard Tyran. All rights reserved.
//

// must import Frameworks into each file as needed

import UIKit
import CoreLocation

let API_URL = "https://api.foursquare.com/v2/"
let CLIENT_ID = "2Y0BSAMCBDCLIR0DXJO5BDR5QYUM3NK5DCQVTWPDYPY4I4HR"
let CLIENT_SECRET = "MWR5NNGX4FMOIQSCP4K5ONDO2TS4JBTWWZQ1TBDPRFPU3LDS"

class FourSquareRequest: NSObject {
    
    class func requestVenuesWithLocation(location: CLLocation) -> [AnyObject] {
        
        let requestString = API_URL + "venues/search?client_id=\(CLIENT_ID)&client_secret=\(CLIENT_SECRET)&v=20130815&ll=\(location.coordinate.latitude),\(location.coordinate.longitude)"
        
        // it's safer to write a conditional here (if let)
        
        println(requestString)
        
        if let url = NSURL(string: requestString) {
            
            let request = NSURLRequest(URL: url)
            
            if let data = NSURLConnection.sendSynchronousRequest(request, returningResponse: nil, error: nil) {
                
                if let returnInfo = NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers, error: nil) as? [String:AnyObject] {
                    
                    let responseInfo = returnInfo["response"] as [String:AnyObject]
                    
                    let venues = responseInfo["venues"] as [AnyObject]
                    
                    return venues
                    
                }
                
            }
            
        }
        
        // TODO: add implementation to return values
        return[]
        
    }
    
}
