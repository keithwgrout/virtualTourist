//
//  PhotoAlbumViewController.swift
//  VirtualTourist
//
//  Created by KEITH GROUT on 7/1/16.
//  Copyright © 2016 keithwgrout. All rights reserved.


import UIKit
import MapKit

class PhotoAlbumViewController: UIViewController {

    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    @IBAction func reloadData(sender: UIBarButtonItem) {
        collectionView?.reloadData()
    }
    
    var photoURLs = [NSURL]()
    var photoBBox: [String: String]?
    var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("4. PAVC viewDidLoad: PASS ")

        // TODO: implement cache
        
        FlickrClient.sharedInstance.getPhotoURLs(withBBox: photoBBox!) { (photos) in
            self.photoURLs = photos
            dispatch_async(dispatch_get_main_queue(), {
                self.collectionView.reloadData()
            })
        }
        
        
        
    }
}














class PhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("Cell Created")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
}












var imageCache = [String:UIImage]()







extension PhotoAlbumViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        print("cellForItemAtIndexPath called: PASS")
        let cell: PhotoCell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! PhotoCell
        var imageURL: NSURL?
        imageURL = self.photoURLs[indexPath.item]
        
        
        
        // if image exists in cache, we will just load the image
        // otherwise, we will download the image and then store it in the cache
        if let image = imageCache[imageURL!.absoluteString] {
            cell.imgView.image = image
        } else {
            //        ******************************          INITIATE DOWNLOAD             ******************************
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
                let imageData = NSData(contentsOfURL: imageURL!)
                let image = UIImage(data: imageData!)
                imageCache[imageURL!.absoluteString] = image
                dispatch_async(dispatch_get_main_queue(), {
                    cell.imgView.image = image
                })
            }
            //        ******************************          END INITIATE DOWNLOAD         ******************************
        }
        


        
        
        return cell
    }
    
        
    
    
    
    //     ******************************         DATA SOURCE METHODS            ******************************

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoURLs.count
    }
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        count += 1
        print("will display cell: \(count)\n")
    }

    
    
}

