//
//  CBPhotoLibraryManager.swift
//  CBPhotoPicker
//
//  Created by Benjamin Hendricks on 11/14/15.
//  Copyright © 2015 coolbnjmn. All rights reserved.
//

import UIKit
import Photos

public class CBPhotoLibraryManager: NSObject {
    class var sharedInstance : CBPhotoLibraryManager {
        struct PhotoLibrary {
            static let instance : CBPhotoLibraryManager = CBPhotoLibraryManager()
        }
        return PhotoLibrary.instance
    }
    
    var photoAssets : PHFetchResult?
    
    func retrieveAllPhotos(completion : ((PHFetchResult)->Void)) {
        let fetch = PHFetchOptions()
        fetch.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        photoAssets = PHAsset.fetchAssetsWithMediaType(.Image, options: fetch)
        if let photoAssets = photoAssets {
            completion(photoAssets)
        }
    }
    
    func thumbnailAtIndex(index: Int, size: CGSize, completion : (PHAsset, UIImage?) -> Void) {
        if let asset : PHAsset = photoAssets?.objectAtIndex(index) as? PHAsset {
            PHImageManager.defaultManager().requestImageForAsset(asset, targetSize: size, contentMode: .AspectFill, options: nil, resultHandler: { (resultImage, info) -> Void in
                completion(asset, resultImage)
            })
        }
    }
}
