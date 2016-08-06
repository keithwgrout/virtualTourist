//
//  todo.swift
//  VirtualTourist
//
//  Created by KEITH GROUT on 6/23/16.
//  Copyright © 2016 keithwgrout. All rights reserved.
//

import Foundation



/*

 
 Facebook Tutorials
 Youtube Tutorials
 Async Tutorials
 Core Data Tutorials
 
 
 Questions:
 
     1. What is a smart way to get new images when i press "New Collection"
     Currently I'm just redownloading the same images?
 
         Possible solutions:
 
         A. Download more images to start, and only display the first 21
         
         B. Download new images and compare them against what is already in cache using the url string.
            If the new image is the same as what is in cache, initiate a new download requesting more images. and repeat.
 
 
    2. How can I store my photos in Core Data
        Possible solutions:
    
 // Storing
 
 
 Is there a suggested point to convert the photos into Core Data Objects? Will doing that right from the start be expensive?
 Should I do it in a background queue?
 
        A.  Pass Pin from Map View to Photo Album View.
            Get Context
            iterate through my cache and for each photo
            Create a new Photo Entity by calling the photo initializer and passing in the context
            add the photo to the pins Photo property which is an nsset
            call context.save
 
 // Retrieving
        A.  Pass Pin from Map View to Photo Album View.
            On ViewDidLoad in PhotoAlbumVC I either do a fetch request on photos
                or
            I just access the photos property of the pin that i just passed over... leaning toward that
 
            If they don't exist... then i download them
 
 
    3. Deleting them from the collection view and core data
        
        
        I will call context.save() at some point in order to save the photo, which presumably i will have added to the pins Photo property.
        Will there be two separate Photo Objects saved? 
        One in the pins photo array and then the actual photo object itself savd in the context
 
 
        

 
 
            
 
    
 
 
 
 
 
 */


 
 