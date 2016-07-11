//
//  Photo+CoreDataProperties.swift
//  VirtualTourist
//
//  Created by KEITH GROUT on 6/28/16.
//  Copyright © 2016 keithwgrout. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Photo {

    @NSManaged var image: NSData?
    @NSManaged var pin: NSSet?

}
