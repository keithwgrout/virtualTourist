//
//  PhotoAlbumViewController.swift
//  VirtualTourist
//
//  Created by KEITH GROUT on 7/1/16.
//  Copyright © 2016 keithwgrout. All rights reserved.


import UIKit
import MapKit

class PhotoAlbumViewController: UIViewController {
    
    @IBOutlet weak var imagesLabel: UILabel!
    @IBOutlet weak var newPhotosButton: UIBarButtonItem!
    var count = 0
    
    var photoBBox: [String: String]?
    var pin: Pin?
    var allPhotos = [Photo]()
    let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBAction func reloadData(sender: UIBarButtonItem) {
        collectionView.reloadData()
        newPhotosButton.enabled = false
        
        // Delete My Current Photos
        if pin?.photos?.count > 0 {
            for index in 0...pin!.photos!.count - 1 {
                let object = pin?.photos?.objectAtIndex(index) as! Photo
                appDel.managedObjectContext.deleteObject(object)
            }
            appDel.saveContext()
            getPhotos()
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getPhotos()
    }
    
    override func viewWillAppear(animated: Bool) {
        imagesLabel.hidden = true
        
    }
}









extension PhotoAlbumViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: PhotoCell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! PhotoCell
        
        cell.spinner.startAnimating()
        
        if indexPath.item < pin?.photos?.count {
            cell.cellPhoto = (pin?.photos?.objectAtIndex(indexPath.item) as! Photo)
        }
        
        if let photo = cell.cellPhoto {
            var imageURL: NSURL?
            
            // if image exists in core data, we will just load the image
            // otherwise, we will download the image and then store it in core data
            if let imageData = photo.image {
                cell.imgView.image = UIImage(data: imageData)
                cell.spinner.stopAnimating()
                cell.spinner.hidesWhenStopped = true
            } else {
                //        ******************************          INITIATE DOWNLOAD             ******************************
                if let imageString = photo.url {
                    imageURL = NSURL(string: imageString)
                } else {
                    print("error")
                }
                dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
                    let imgData = NSData(contentsOfURL: imageURL!)
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        cell.spinner.stopAnimating()
                        cell.spinner.hidesWhenStopped = true
                        photo.image = imgData
                        let image = UIImage(data: (photo.image!))
                        cell.imgView.image = image
                        
                    })
                }
                //        ******************************          END INITIATE DOWNLOAD         ******************************
            }
        }
        
        
        appDel.saveContext()
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let object = pin?.photos?.objectAtIndex(indexPath.item) as! Photo
        appDel.managedObjectContext.deleteObject(object)
        appDel.saveContext()
        
        // remove object from collection view
        collectionView.deleteItemsAtIndexPaths([indexPath])
    }
    
    //     ******************************         DATA SOURCE METHODS            ******************************
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (pin?.photos?.count)!
    }
    
    func getPhotos(){
        if pin?.photos?.array.isEmpty == true {
            FlickrClient.sharedInstance.getPhotoURLs(withBBox: photoBBox!) { (photos) in
                
                dispatch_async(dispatch_get_main_queue(), {
                    let context = self.appDel.managedObjectContext
                    
                    if photos.count == 0 {
                        self.imagesLabel.hidden = false
                    }
                    self.newPhotosButton.enabled = true
                    for (index, url) in photos.enumerate() {
                        if index <= 20 {
                            let photo = Photo(context: context)
                            photo.url = url.absoluteString
                            photo.pin = self.pin
                        }
                    }
                    self.collectionView.reloadData()
                })
            }
        } else {
        }
    }
}



class PhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    var cellPhoto: Photo?
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
}





