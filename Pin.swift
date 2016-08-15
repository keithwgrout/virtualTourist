//
//  Pin.swift
//  VirtualTourist
//
//  Created by KEITH GROUT on 6/28/16.
//  Copyright © 2016 keithwgrout. All rights reserved.
//

import Foundation
import CoreData

class Pin: NSManagedObject {
    

// Insert code here to add functionality to your managed object subclass
    
    convenience init(context: NSManagedObjectContext, latitude: Double, longitude: Double){
        
        if let ent = NSEntityDescription.entityForName("Pin", inManagedObjectContext: context){
            self.init(entity: ent, insertIntoManagedObjectContext: context)
            self.latitude = round(latitude * 100000) / 100000
            self.longitude = round(longitude * 100000) / 100000
        } else {
            fatalError("Unable to find entity name.")
        }
    }
    
}
