//
//  CBPhotoPickerViewController.swift
//  CBPhotoPicker
//
//  Created by Benjamin Hendricks on 11/14/15.
//  Copyright © 2015 coolbnjmn. All rights reserved.
//

import UIKit
import Photos

public protocol CBPhotoPickerViewControllerDelegate {
    /**
     handleCancel
     
     Delegate method used when the photo picker cancels it's operations. Not used right now
     - Parameters : none
     - Returns: none
    */
    func handleCancel()
    
    /**
    handleSuccess

    Delegate method used to return a cropped image to the presenting view controller. Used right now on a triple tap on the iamge view
    - Parameters : 
        - resultImage : UIImage that is the cropped image in the right aspect ratio

    - Returns: 
        none
    */
    func handleSuccess(resultImage: UIImage?)
}

public class CBPhotoPickerViewController: UIViewController {
    
    static let kReuseIdentifier = "cbPhotoPickerCell"
    
    var previewImageView: CBImageView?
    var photoCollectionView: UICollectionView?
    var previewPhotoFrame : CGRect = CGRectZero
    
    var photoCollectionViewFlowLayout: UICollectionViewFlowLayout?
    var photoAsset : PHFetchResult?

    var originalFrame : CGRect
    var imageAspectRatio : CGFloat

    var delegate : CBPhotoPickerViewControllerDelegate?
    
    /**
     init
     Init -- this is how to create a photo picker!
     Pass in the size you want it to be (probably the presenting view controller's frame), and an aspect ratio for the image you're looking to pick. This value can be 1 for a 1:1 image, 1.33 for a 4:3 image, or whatever value you want!
     The views will properly resize to only show a preview view the size the final image would be. 
     
     - Parameters: 
        - frame: The frame of the view controller to create
        - aspectRatio: The aspect ratio of the image to pick, which is what the return image will be cropped as
     
     - Returns: A brand new photo picker
    */
    public required init(frame: CGRect, aspectRatio: CGFloat) {
        originalFrame = frame
        if aspectRatio <= 0 {
            imageAspectRatio = 1
        } else {
            imageAspectRatio = aspectRatio  
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    /**
     Method that overrides normal load view, and this creates the main view for this view controller, and sets up all the views
    */
    public override func loadView() {
        view = UIView(frame: originalFrame)
        let previewImageHeight : CGFloat = originalFrame.width/imageAspectRatio
        previewImageView = CBImageView(frame: CGRectMake(0, 0, originalFrame.width, previewImageHeight))
        previewImageView?.userInteractionEnabled = true
        previewImageView?.imageView?.contentMode = .ScaleAspectFit
        previewImageView?.backgroundColor = UIColor.clearColor()
        photoCollectionViewFlowLayout = UICollectionViewFlowLayout()
        photoCollectionViewFlowLayout?.itemSize = CGSizeMake(originalFrame.width/3, originalFrame.width/3)
        photoCollectionViewFlowLayout?.minimumInteritemSpacing = 0
        photoCollectionViewFlowLayout?.minimumLineSpacing = 0
        photoCollectionView = UICollectionView(frame: CGRectMake(0, previewImageHeight, originalFrame.width, originalFrame.height-previewImageHeight), collectionViewLayout: photoCollectionViewFlowLayout ?? UICollectionViewFlowLayout())
        photoCollectionView?.backgroundColor = UIColor.darkGrayColor()
        
        
        if let previewImageView = previewImageView {
            view.addSubview(previewImageView)
        }
        if let photoCollectionView = photoCollectionView {
            view.addSubview(photoCollectionView)
        }
        
    }

    /**
    init
     
     required init for all view controllers, but don't use this one! You need a frame for a photo picker to work!
     */
    required public init?(coder aDecoder: NSCoder) {
        self.originalFrame = CGRectZero
        self.imageAspectRatio = 1
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
        
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "handleExit:")
        tapGestureRecognizer.numberOfTapsRequired = 3
        previewImageView?.addGestureRecognizer(tapGestureRecognizer)
        PHPhotoLibrary.sharedPhotoLibrary().registerChangeObserver(self)
        
        photoCollectionView?.registerNib(UINib(nibName: "CBPhotoPickerCell", bundle: nil), forCellWithReuseIdentifier: "cbPhotoPickerCell")
        super.viewDidLoad()

    }
    
    override public func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        previewPhotoFrame = previewImageView?.frame ?? CGRectZero
    }
    
    public func handleDone() -> UIImage? {
        if let image = self.previewImageView?.capture() {
            return image
        }
        return nil
    }
    
    public func handleExit(recognizer: UIGestureRecognizer) {
        delegate?.handleSuccess(handleDone())
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
                    self.previewImageView?.imageView?.transform = CGAffineTransformIdentity
                    self.previewImageView?.imageView?.image = image
                }
                
                if let cell = collectionView.cellForItemAtIndexPath(indexPath) {
                    cell.layer.borderColor = UIColor.blueColor().CGColor
                    cell.layer.borderWidth = 2
                }
            })
        }
    
        public func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
            if let cell = collectionView.cellForItemAtIndexPath(indexPath) {
                cell.layer.borderWidth = 0
                cell.layer.borderColor = UIColor.clearColor().CGColor
            }
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

