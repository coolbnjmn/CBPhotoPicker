//
//  CBPhotoPickerViewController.swift
//  CBPhotoPicker
//
//  Created by Benjamin Hendricks on 11/14/15.
//  Copyright © 2015 coolbnjmn. All rights reserved.
//

import UIKit
import Photos

public class CBPhotoPickerViewController: UIViewController {
    
    static let kReuseIdentifier = "cbPhotoPickerCell"
    
    var previewImageView: UIImageView?
    var photoCollectionView: UICollectionView?
    
    var previewPhotoFrame : CGRect = CGRectZero
    
    var photoCollectionViewFlowLayout: UICollectionViewFlowLayout?
    var photoAsset : PHFetchResult?

    var originalFrame : CGRect

    public required init(frame: CGRect) {
        originalFrame = frame
        super.init(nibName: nil, bundle: nil)
    }
    
    public override func loadView() {
        view = UIView(frame: originalFrame)
        previewImageView = UIImageView(frame: CGRectMake(0, 0, originalFrame.width, originalFrame.height/2))
        previewImageView?.backgroundColor = UIColor.redColor()
        previewImageView?.userInteractionEnabled = true
        photoCollectionViewFlowLayout = UICollectionViewFlowLayout()
        photoCollectionViewFlowLayout?.itemSize = CGSizeMake(originalFrame.width/3, originalFrame.width/3)
        photoCollectionViewFlowLayout?.minimumInteritemSpacing = 0
        photoCollectionViewFlowLayout?.minimumLineSpacing = 0
        photoCollectionView = UICollectionView(frame: CGRectMake(0, originalFrame.height/2, originalFrame.width, originalFrame.height/2), collectionViewLayout: photoCollectionViewFlowLayout ?? UICollectionViewFlowLayout())
        photoCollectionView?.backgroundColor = UIColor.clearColor()
        if let previewImageView = previewImageView {
            view.addSubview(previewImageView)
        }
        if let photoCollectionView = photoCollectionView {
            view.addSubview(photoCollectionView)
 
        }
       
    }

    required public init?(coder aDecoder: NSCoder) {
        self.originalFrame = CGRectZero
        super.init(coder: aDecoder)
    }
    
    override public func viewDidLoad() {
        if let photoCollectionView = photoCollectionView {
            CBPhotoLibraryManager.sharedInstance.retrieveAllPhotos({ result in
                self.photoAsset = result
                self.photoCollectionView?.reloadData()
            })
            photoCollectionView.delegate = self
            photoCollectionView.dataSource = self
        }
        
        
        PHPhotoLibrary.sharedPhotoLibrary().registerChangeObserver(self)
        
        if let previewImageView = previewImageView {
            let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: "handlePinch:")
            previewImageView.addGestureRecognizer(pinchGestureRecognizer)
            
            let rotationGestureRecognizer = UIRotationGestureRecognizer(target: self, action: "handleRotate:")
            previewImageView.addGestureRecognizer(rotationGestureRecognizer)
            
            let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "handlePan:")
            previewImageView.addGestureRecognizer(panGestureRecognizer)
            view.sendSubviewToBack(previewImageView)
        }
        
        photoCollectionView?.registerNib(UINib(nibName: "CBPhotoPickerCell", bundle: nil), forCellWithReuseIdentifier: "cbPhotoPickerCell")
        super.viewDidLoad()

    }
    
    override public func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        previewPhotoFrame = previewImageView?.frame ?? CGRectZero
    }
    
    func cropToOverlayView(imageToCrop:UIImage, toRect rect:CGRect) -> UIImage {
        let imageRef:CGImageRef = CGImageCreateWithImageInRect(imageToCrop.CGImage, rect)!
        let cropped:UIImage = UIImage(CGImage:imageRef)
        return cropped
    }
    
    func nextButtonPressed(sender: AnyObject) {
        
        // TEMP... why no worky? Method doesn't even fire. Also wondering why these are all under extensions?
        // THIS IS WHERE WE CROP THE IMAGE FROM THE SNAPSHOT OF THE VIEW
        // Extensions are used to simplify the class logic to only view lifecycle stuff, and other code can live in the extension with the appropriate delegate/datasource impl. I just think it makes the code easier to read and sort through
        let pickedImage = view.snapshot
        let croppedImage : UIImage = cropToOverlayView(pickedImage, toRect: CGRectMake(0, 120, 2*pickedImage.size.width, 2*pickedImage.size.width/2))
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let destinationPath = documentsPath.stringByAppendingString("discoveryFeedImage.png")
        print("++++++++++++++: \(destinationPath)")
        UIImagePNGRepresentation(croppedImage)?.writeToFile(destinationPath, atomically: true)
        
    }
    
    func handlePinch(recognizer: UIPinchGestureRecognizer) {
        let state : UIGestureRecognizerState = recognizer.state
        
        if state == .Began || state == .Changed {
            let scale = recognizer.scale
            if let view = recognizer.view {
                view.transform = CGAffineTransformScale(view.transform, scale, scale)
            }
            recognizer.scale = 1.0
        }
    }
    
    func handleRotate(recognizer: UIRotationGestureRecognizer) {
        let state : UIGestureRecognizerState = recognizer.state
        
        if state == .Began || state == .Changed {
            let rotation = recognizer.rotation
            if let view = recognizer.view {
                view.transform = CGAffineTransformRotate(view.transform, rotation)
            }
            recognizer.rotation = 0
        }
    }
    
    
    func handlePan(recognizer: UIPanGestureRecognizer) {
        let state : UIGestureRecognizerState = recognizer.state
        
        if let view = recognizer.view where state == .Began || state == .Changed {
            let translation = recognizer.translationInView(view)
            view.transform = CGAffineTransformTranslate(view.transform, translation.x, translation.y)
            recognizer.setTranslation(CGPointZero, inView: view)
        }
        
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
    
extension CBPhotoPickerViewController : UICollectionViewDataSource, UICollectionViewDelegate {
        public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return photoAsset?.count ?? 0
        }
    
        public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            return UIEdgeInsetsMake(0,0,0,0) //top,left,bottom,right
        }
    
        public  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            return CGSizeMake(collectionView.bounds.width/3, collectionView.bounds.width/3)
        }
    
        public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CBPhotoPickerViewController.kReuseIdentifier, forIndexPath: indexPath) as? CBPhotoPickerCell
            
            if let cell = cell {
                CBPhotoLibraryManager.sharedInstance.thumbnailAtIndex(indexPath.item, size: CGSizeMake(cell.bounds.width, cell.bounds.height), completion: { (asset:PHAsset, image:UIImage?) in
                    if let image = image {
                        cell.cbImageView.image = image
                    }
                })
                
                return cell
            } else {
                return UICollectionViewCell()
            }
            
        }
        
        public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
            CBPhotoLibraryManager.sharedInstance.thumbnailAtIndex(indexPath.item, size: CGSizeMake(view.bounds.width, view.bounds.width), completion: {
                (asset: PHAsset, image: UIImage?) in
                if let image = image {
                    if image != self.previewImageView?.image {
                        self.previewImageView?.transform = CGAffineTransformIdentity
                    }
                    self.previewImageView?.image = image
                    
                }
            })
        }
    }

extension CBPhotoPickerViewController : PHPhotoLibraryChangeObserver {
        public func photoLibraryDidChange(changeInstance: PHChange) {
            checkIfAuthorized(PHPhotoLibrary.authorizationStatus())
        }
        
        public func checkIfAuthorized(status : PHAuthorizationStatus) {
            if status == .NotDetermined {
                PHPhotoLibrary.requestAuthorization({ (status) -> Void in
                    self.checkIfAuthorized(status)
                })
            } else if status == .Denied {
                // handle this appropriately
            } else if status == .Authorized {
                CBPhotoLibraryManager.sharedInstance.retrieveAllPhotos({ result in
                    self.photoAsset = result
                    dispatch_async(dispatch_get_main_queue(), {
                        self.photoCollectionView?.reloadData()
                    })
                })
            }
        }
}

