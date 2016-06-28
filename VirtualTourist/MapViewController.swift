//
//  ViewController.swift
//  VirtualTourist
//
//  Created by KEITH GROUT on 6/23/16.
//  Copyright © 2016 keithwgrout. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var myMapView: MKMapView!
    let defaults = NSUserDefaults.standardUserDefaults()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        myMapView.delegate = self
        
        // the region is what we need to set
        // nsuserDefaults can only store basic data types
        // so we need to store the doubles and turn the into a region
        let region = myMapView.region
        let currSpan = region.span
        let currCenter = region.center
        
        let spanLatDelta = currSpan.latitudeDelta
        let spanLonDelta = currSpan.longitudeDelta
        
        let lat = currCenter.latitude
        let lon = currCenter.longitude
        
        // we get the region from the map on the first launch,
        // otherwise we create it from the userdefaults
        
        // we need to determine if the app has launched
        // we can store a bool value to determine that
        
        if defaults.valueForKey("hasLaunched") != nil{
            // create region from nsuserdefaults
            print("not first launch")
            let currentLatDelta = defaults.valueForKey("spanLatDelta") as! CLLocationDegrees
            let currentLonDelta = defaults.valueForKey("spanLonDelta") as! CLLocationDegrees
            let centerLat = defaults.valueForKey("latitude") as! CLLocationDegrees
            let centerLon = defaults.valueForKey("longitude") as! CLLocationDegrees
            
            let span = MKCoordinateSpan(latitudeDelta: currentLatDelta ,longitudeDelta: currentLonDelta )
            let center = CLLocationCoordinate2D(latitude: centerLat, longitude: centerLon)
            let region = MKCoordinateRegion(center: center, span: span)
            myMapView.setRegion(region, animated: true)
            
        } else {
            print("first launch")
            // get region from map
            defaults.setDouble(spanLatDelta, forKey: "spanLatDelta")
            defaults.setDouble(spanLonDelta, forKey: "spanLonDelta")
            defaults.setDouble(lat, forKey: "latitude")
            defaults.setDouble(lon, forKey: "longitude")
            defaults.setValue(true, forKey: "hasLaunched")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        let region = mapView.region
        let currSpan = region.span
        let currCenter = region.center
        
        let spanLatDelta = currSpan.latitudeDelta
        let spanLonDelta = currSpan.longitudeDelta
        
        let lat = currCenter.latitude
        let lon = currCenter.longitude
        
        // 2. save the map info to nsuserdefaults every time the map changes
        defaults.setDouble(spanLatDelta, forKey: "spanLatDelta")
        defaults.setDouble(spanLonDelta, forKey: "spanLonDelta")
        defaults.setDouble(lat, forKey: "latitude")
        defaults.setDouble(lon, forKey: "longitude")

    }
}

