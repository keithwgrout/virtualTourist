//
//  FlickrConstants.swift
//  VirtualTourist
//
//  Created by KEITH GROUT on 7/5/16.
//  Copyright © 2016 keithwgrout. All rights reserved.
//


extension FlickrClient {
    
    struct Constants {
        static let apiKey = "74cf656c1f9f8752e3353fab981e4f88"
        static let secret = "79194b7ef23431ec"
        static let requestURL = "https://api.flickr.com/services/rest/?method="
    }
    
    struct Methods {
        static let FlickrPhotosSearch = "flickr.photos.search"
    }
    
    struct Parameters {
        static let returnJSON = "&format=json"
        static let api_key = "&api_key=" + Constants.apiKey
        static let noJSONCallback = "&nojsoncallback=1"
        static let bbox = "&bbox="
    }

}

// https://api.flickr.com/services/rest/?method=flickr.test.echo&name=value
