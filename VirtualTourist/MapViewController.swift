//
//  ViewController.swift
//  VirtualTourist
//
//  Created by KEITH GROUT on 6/23/16.
//  Copyright © 2016 keithwgrout. All rights reserved.
//



import UIKit
import MapKit
import CoreData
import CoreLocation

class MapViewController: UIViewController {
    
    @IBOutlet weak var myMapView: MKMapView!
    let defaults = NSUserDefaults.standardUserDefaults()
    var photo: UIImage? = nil
    var BBox : [String:String]?
    
    
    func addPin(gestureRecognizer: UILongPressGestureRecognizer){
        if gestureRecognizer.state == UIGestureRecognizerState.Began {
            let touchPoint = gestureRecognizer.locationInView(myMapView)
            let coordinates = myMapView.convertPoint(touchPoint, toCoordinateFromView: myMapView)
            let annotation = PinAnnotation(withCoordinates: coordinates, andTitle: "PhotoPin")
            myMapView.addAnnotation(annotation)
            let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
            let context = appDel.managedObjectContext
            let newPin = Pin(context: context)
            newPin.latitude = coordinates.latitude
            newPin.longitude = coordinates.longitude
            
            do {
                try context.save()
            } catch {
                print("error could not save")
            }
        }
    }

    override func viewDidLoad() {
        
        print("0. MapViewController viewDidLoad: PASS")
        super.viewDidLoad()
        myMapView.delegate = self
        
        // ****** ADD GESTURE RECOGNIZER *******
        
        let longPress = UILongPressGestureRecognizer(target: self, action: .addPin)
        longPress.minimumPressDuration = 0.5
        myMapView.addGestureRecognizer(longPress)
        
        
        
        
        
        
        // ****** FETCH PINS, (if already saved) ******
        
        let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDel.managedObjectContext
        let request = NSFetchRequest(entityName: "Pin")
        var results: [AnyObject]?
        
        do {
            results = try context.executeFetchRequest(request)
        } catch {
            print("error fetching results")
        }
        
        
        
        
        
        // ****** ADD FETCHED PINS TO MAP, if available ******
        
        if let results =  results as! [Pin]? where results.count > 0 {
            for pin in results {
                let lat = pin.latitude as! CLLocationDegrees
                let lon = pin.longitude as! CLLocationDegrees
                let coords = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                let annotation = PinAnnotation(withCoordinates: coords, andTitle: "pin")
                myMapView.addAnnotation(annotation)
            }
        } else {
            print("no results yet")
        }
        
        
        // ****** LOAD THE MAPS LAST KNOWN COORDINATES, OTHERWISE STORE THE CURRENT COORDINATES ******

        // the region is what we need to set
        // nsuserDefaults can only store basic data types
        // so we need to store the doubles and turn them into a region
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
            let currentLatDelta = defaults.valueForKey("spanLatDelta") as! CLLocationDegrees
            let currentLonDelta = defaults.valueForKey("spanLonDelta") as! CLLocationDegrees
            let centerLat = defaults.valueForKey("latitude") as! CLLocationDegrees
            let centerLon = defaults.valueForKey("longitude") as! CLLocationDegrees
            
            let span = MKCoordinateSpan(latitudeDelta: currentLatDelta ,longitudeDelta: currentLonDelta )
            let center = CLLocationCoordinate2D(latitude: centerLat, longitude: centerLon)
            let region = MKCoordinateRegion(center: center, span: span)
            myMapView.setRegion(region, animated: true)
            
        } else {
            // get region from map
            defaults.setDouble(spanLatDelta, forKey: "spanLatDelta")
            defaults.setDouble(spanLonDelta, forKey: "spanLonDelta")
            defaults.setDouble(lat, forKey: "latitude")
            defaults.setDouble(lon, forKey: "longitude")
            defaults.setValue(true, forKey: "hasLaunched")
        }
    }

}

private extension Selector {

    static let addPin = #selector(MapViewController.addPin(_:))
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseID = "pin"
        
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseID) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
        }
        annotationView?.animatesDrop = true
        
        return annotationView
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        
        // we want photos from the area of the pin annotation
        // we need to pass in bbox coordinates as a parameter to our request
        // so first we can start off with the coordinates of the annotation
        // from there, we can make it easy and simply create a bbox based off
        // of our center
        
        let annotation = view.annotation!
        let coordinates = annotation.coordinate
        let lat = coordinates.latitude
        let lon = coordinates.longitude
        
        let coordinateDelta = 0.10
        
        let maxLat = String(lat + coordinateDelta)
        let maxLon = String(lon + coordinateDelta)
        let minLat = String(lat - coordinateDelta)
        let minLon = String(lon - coordinateDelta)
        
        
        self.BBox = ["minLon":minLon, "minLat":minLat, "maxLon":maxLon, "maxLat":maxLat ]
        
        print("1. about to perform segue: PASS")
        print("2. bbox created: PASS")
        
        performSegueWithIdentifier("PhotoAlbumSegue", sender: self)

        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.

        print("3. prepping Segue: PASS")
        
        let PAVC = segue.destinationViewController as! PhotoAlbumViewController
        PAVC.photoBBox = BBox
    }

    
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

