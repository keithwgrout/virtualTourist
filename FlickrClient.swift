//
//  FlickrClient.swift
//  VirtualTourist
//
//  Created by KEITH GROUT on 7/5/16.
//  Copyright © 2016 keithwgrout. All rights reserved.
//

import Foundation
import UIKit


class FlickrClient {
    
    static let sharedInstance = FlickrClient()
    private init(){}
    
    var img: UIImage? = nil
    
    let session = NSURLSession.sharedSession()

    
    func getPhotos(withBBox bbox:[String:String]) {
        
        // create session
        // build url
        
        let BBOX = bbox["minLon"]! + "," + bbox["minLat"]! + "," + bbox["maxLon"]! + "," + bbox["maxLat"]!
        
        
        let url =
            Constants.requestURL +
            Methods.FlickrPhotosSearch +
            Parameters.returnJSON +
            Parameters.api_key + "&nojsoncallback=1" + Parameters.bbox + BBOX
        
        
        let requestURL = NSURL(string: url)
        let request = NSURLRequest(URL: requestURL!)
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            print("2: background thread 1")
            var jsonObject: AnyObject?
        
            do{
                jsonObject = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
            } catch{
                jsonObject = nil
                print("error")
            }
            
            let photoObj = jsonObject!
            let photoDict = photoObj["photos"] as! [String:AnyObject]
            
            // here we have an array of photo objects
            // [photo objects]
            // each photo object has information needed to form a photoURL
            // a request to the photoURL will bring back photoData
            // the photoData can be converted to an image
            // i think we only want to store the actual image (not the data, or photo object)
            // WHERE AND WHEN DO WE STORE THEM?
            // I think i should iterate through the photo array,
            // and one by one create photoStrings
            
            // then i can initiate a download from flickr, to get the photo data
            // then
            // i can store an array of photos inside pavc
            // i will pass a closure into flickrClient.getPhotos from pavc
            // and i can use that to get the photos into my photoalbum
            
            // then, inside the same function i should request the photo from the url
            // then i can repeat until i have all of the images
            // i can add them to the collection view as they come in,
            // and store them when they all finish downloading
            
            let photoArray = photoDict["photo"] as! [[String:AnyObject]]
            
            print(photoArray.count)
            for photo in photoArray {
                let farmID = String(photo["farm"]!)
                let serverID = String(photo["server"]!)
                let photoID = String(photo["id"]!)
                let secret = String(photo["secret"]!)
                
                let photoString = "https://farm"+farmID+".staticflickr.com/"+serverID+"/"+photoID+"_"+secret+".jpg"
                let photoURL = NSURL(string: photoString)
            }
            
            

            
            
            
//            let photoTask = self.session.dataTaskWithURL(photoURL!, completionHandler: { (dat, res, err) in
//                print("4")
//                
//                dispatch_async(dispatch_get_main_queue(), { 
//                    let image = UIImage(data: dat!)
//                    self.img = image
//
//                })
//
//                
//            })
//            photoTask.resume()
//            print("3")
        }
        task.resume()
        print("1")
    }
    

}
