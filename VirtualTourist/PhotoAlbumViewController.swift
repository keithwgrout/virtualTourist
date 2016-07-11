//
//  PhotoAlbumViewController.swift
//  VirtualTourist
//
//  Created by KEITH GROUT on 7/1/16.
//  Copyright © 2016 keithwgrout. All rights reserved.
//

import UIKit
import MapKit

class PhotoAlbumViewController: UIViewController {


    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var photo: UIImageView!
    
    var photoBBox: [String: String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        map.scrollEnabled = false
        setMapCoords()
        FlickrClient.sharedInstance.getPhotos(withBBox: photoBBox!)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setMapCoords(){
        // get the tapped pin
        // get the lat and lon
        // create center from lat and lon
        // set the lat and lon delta to .01 or something
        // create span from lat and lon delta
        // create region from center and span
        // set region
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension PhotoAlbumViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 7
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath)
        return cell
    }

    
    
}

