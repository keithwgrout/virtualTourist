//
//  Annotation.swift
//  VirtualTourist
//
//  Created by KEITH GROUT on 6/30/16.
//  Copyright © 2016 keithwgrout. All rights reserved.
//

import Foundation
import MapKit

class PinAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(withCoordinates coordinates: CLLocationCoordinate2D, andTitle title: String?) {
        self.coordinate = coordinates
        self.title = title
    }
}


