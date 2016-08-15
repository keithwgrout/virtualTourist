//
//  PhotoAlbumViewController.swift
//  VirtualTourist
//
//  Created by KEITH GROUT on 7/1/16.
//  Copyright © 2016 keithwgrout. All rights reserved.


import UIKit
import MapKit

class PhotoAlbumViewController: UIViewController {
    
    var count = 0
    
    var photoBBox: [String: String]?
    var pin: Pin?
    var allPhotos = [Photo]()
    let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBAction func reloadData(sender: UIBarButtonItem) {
        print("New Collection")

        // Delete My Current Photos
        for index in 0...pin!.photos!.count - 1 {
            let object = pin?.photos?.objectAtIndex(index) as! Photo
            appDel.managedObjectContext.deleteObject(object)
        }
        appDel.saveContext()
        getPhotos()
    }
 
 
    override func viewDidLoad() {
        super.viewDidLoad()
        getPhotos()
    }
}














class PhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    var cellPhoto: Photo?
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
}



















extension PhotoAlbumViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
                print("cellForItem Called")
        let cell: PhotoCell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! PhotoCell
        
        if pin?.photos?.array.isEmpty == true {
            cell.spinner.startAnimating()
        } else {
            
            if indexPath.item < pin?.photos?.count {
                cell.cellPhoto = (pin?.photos?.objectAtIndex(indexPath.item) as! Photo)
            }
            
            if let photo = cell.cellPhoto {
                var imageURL: NSURL?
                
                // if image exists in core data, we will just load the image
                // otherwise, we will download the image and then store it in core data
                if let imageData = photo.image {
                    //                    print("We have an image in Core Data. Applying Image. ")
                    cell.imgView.image = UIImage(data: imageData)
                    cell.spinner.stopAnimating()
                    cell.spinner.hidesWhenStopped = true
                } else {
                    //        ******************************          INITIATE DOWNLOAD             ******************************
                    //                    print("unable to find any imageData for this photo")
                    if let imageString = photo.url {
                        imageURL = NSURL(string: imageString)
                    } else {
                        print("else it up")
                    }
                    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
                        //                        print("heading to background thread .")
                        let imgData = NSData(contentsOfURL: imageURL!)
                        //                        print("returned w/ data. creating image and adding to Photo.")
                        photo.image = imgData
                        
                        let image = UIImage(data: (photo.image!))
                        dispatch_async(dispatch_get_main_queue(), {
                            //                            print("Main Q. applying image view, killing spinner.")
                            cell.imgView.image = image
                            cell.spinner.stopAnimating()
                            cell.spinner.hidesWhenStopped = true
                        })
                    }
                    //        ******************************          END INITIATE DOWNLOAD         ******************************
                }
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
        let context = appDel.managedObjectContext
        if pin?.photos?.array.isEmpty == true {
            FlickrClient.sharedInstance.getPhotoURLs(withBBox: photoBBox!) { (photos) in
                
                dispatch_async(dispatch_get_main_queue(), {
                    for (index, url) in photos.enumerate() {
                        if index <= 20 {
                            let photo = Photo(context: context)
                            photo.url = url.absoluteString
                            self.allPhotos.append(photo)
                        }
                    }
                    self.pin?.photos = NSMutableOrderedSet(array: self.allPhotos)
                    self.collectionView.reloadData()
                })
            }
        } else {
        }
        
        
    }
    
    
    
}

