//
//  CBImageView.swift
//  CBPhotoPicker
//
//  Created by Benjamin Hendricks on 11/15/15.
//  Copyright © 2015 coolbnjmn. All rights reserved.
//

import UIKit

extension CGRect {
    func scale(scale: CGFloat) -> CGRect {
        return CGRectMake(origin.x * scale, origin.y * scale, size.width * scale, size.height * scale)
    }
}

public class CBImageView: UIScrollView {
    var imageView: UIImageView?
    var animator : UIDynamicAnimator?
    
    public var overlayDelegate : CBOverlayViewDelegate?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        self.clipsToBounds = false
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.alwaysBounceHorizontal = true
        self.alwaysBounceVertical = true
        self.bouncesZoom = true
        self.maximumZoomScale = 10
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        self.delegate = self
        imageView = UIImageView(frame: self.frame)
        
        if let imageView = imageView {
            imageView.userInteractionEnabled = true
            self.addSubview(imageView)
        }
    }
    
    func setupScrollView() {
        if var frame = self.imageView?.frame, let imageSize = imageView?.image?.size {
            if imageSize.height > imageSize.width {
                frame.size.width = self.bounds.size.width
                frame.size.height = (self.bounds.size.width / imageSize.width) * imageSize.height
            } else {
                frame.size.height = self.bounds.size.height
                frame.size.width = (self.bounds.size.height / imageSize.height) * imageSize.width
            }
            
            self.imageView?.frame = frame
        }
        
        if let imageSize = imageView?.image?.size {
            self.contentSize = imageSize
            
            if imageSize.width  > imageSize.height {
                self.contentOffset = CGPointMake(imageSize.width/4, 0)
            } else {
                self.contentOffset = CGPointMake(0, imageSize.height/4)
            }
            self.zoomScale = self.minimumZoomScale
            
        }
    }
    
    class func cbScaleRect(rect : CGRect, scale: CGFloat) -> CGRect {
        return CGRectMake(rect.origin.x * scale, rect.origin.y * scale, rect.size.width * scale, rect.size.height * scale)
    }
    
    func calculateRectForCropArea() -> CGRect? {
        if let imageView = imageView, let image = imageView.image {
            var sizeScale : CGFloat = image.size.width / imageView.frame.size.width
            sizeScale *= self.zoomScale
            let visibleRect = self.convertRect(self.bounds, toView: self.imageView)
            return CBImageView.cbScaleRect(visibleRect, scale: sizeScale)
        }
        return nil
    }
    
    public func capture() -> UIImage? {
        let visibleRect = self.calculateRectForCropArea()
        if let visibleRect = visibleRect, let image = self.imageView?.image {
            if let ref : CGImageRef = CGImageCreateWithImageInRect(self.imageView?.image?.CGImage, visibleRect) {
                let cropped : UIImage = UIImage(CGImage: ref, scale: image.scale, orientation: image.imageOrientation)
                return cropped
            }
        }
        return nil
    }
}

extension CBImageView : UIScrollViewDelegate {
    public func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
    public func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        overlayDelegate?.hideOverlay()
    }
    
    public func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        overlayDelegate?.showOverlay()
    }
}

