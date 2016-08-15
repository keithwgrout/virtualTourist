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
    
    var photoURLs = [NSURL]()
    let session = NSURLSession.sharedSession()
    
    
    
    
    
    
    
    
    
    
    //  ************************          GET PHOTO URL'S             ******************

    func getPhotoURLs(withBBox bbox:[String:String], completionHandlerForGetPhotos: (photos:[NSURL])-> Void ) {
        let request = buildURLRequest(withBBox: bbox)
     
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
  
            let photoArray = self.photoArrayFromData(data)
            for photo in photoArray {
                let photoURL = self.photoURLFromPhotoDic(photo)
                self.photoURLs.append(photoURL)
                
            }
            completionHandlerForGetPhotos(photos: self.photoURLs)
            self.photoURLs.removeAll()
        }
        task.resume()
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // ************************          HELPERS          ******************
    
    func photoURLFromPhotoDic(photoDictionary: [String:AnyObject]) -> NSURL {
        let farmID = String(photoDictionary["farm"]!)
        let serverID = String(photoDictionary["server"]!)
        let photoID = String(photoDictionary["id"]!)
        let secret = String(photoDictionary["secret"]!)
        
        let photoString = "https://farm"+farmID+".staticflickr.com/"+serverID+"/"+photoID+"_"+secret+".jpg"
        return NSURL(string: photoString)!
    }
    func photoArrayFromData(data: NSData?) -> [[String:AnyObject]] {
        var jsonObject: AnyObject?
        
        do{
            jsonObject = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
        } catch{
            jsonObject = nil
            print("error")
        }
        
        let photoObj = jsonObject!
        let photoDict = photoObj["photos"] as! [String:AnyObject]
        
        let photoArray = photoDict["photo"] as! [[String:AnyObject]]
        return photoArray
    }
    func buildURLRequest(withBBox bbox:[String:String]) -> NSURLRequest{
        let BBOX = bbox["minLon"]! + "," + bbox["minLat"]! + "," + bbox["maxLon"]! + "," + bbox["maxLat"]!
        let url = Constants.requestURL +
            Methods.FlickrPhotosSearch +
            Parameters.returnJSON +
            Parameters.api_key + "&nojsoncallback=1" + Parameters.bbox + BBOX // + "&per_page=21"
        let requestURL = NSURL(string: url)
        return NSURLRequest(URL: requestURL!)
    }
} // end flickr client
 