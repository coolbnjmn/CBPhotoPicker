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
    
    deinit {
        self.imageView?.image = nil
        self.imageView = nil
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
            imageView.contentMode = .ScaleAspectFit
            self.addSubview(imageView)
        }
    }
    
    func loadNewImage(image: UIImage) {
        // reset everything
        zoomScale = minimumZoomScale
        if let superviewFrame = superview?.frame {
            contentSize = superviewFrame.size
        }
        self.imageView?.image = image
        setupScrollView()
    }
    
    func setupScrollView() {
        if let imageSize = imageView?.image?.size where imageSize.width > imageView?.frame.size.width || imageSize.height > imageView?.frame.size.height {
            self.contentSize = imageSize
            self.zoomScale = self.minimumZoomScale
        }
        
        if let image = imageView?.image {
            let widthScaleFactor = self.bounds.width / image.size.width
            let heightScaleFactor = self.bounds.height / image.size.height
            
            var imageViewXOrigin: CGFloat = 0
            let imageViewYOrigin: CGFloat = 0
            var imageViewHeight : CGFloat
            var imageViewWidth : CGFloat
            
            if widthScaleFactor > heightScaleFactor {
                imageViewWidth = image.size.width * widthScaleFactor
                imageViewHeight = image.size.height * widthScaleFactor
            } else {
                imageViewWidth = image.size.width * heightScaleFactor
                imageViewHeight = image.size.height * heightScaleFactor
                imageViewXOrigin = -1 * (imageViewWidth - self.bounds.width) / CGFloat(2)
            }
            
            self.imageView?.frame = CGRectMake(imageViewXOrigin,
                imageViewYOrigin,
                imageViewWidth,
                imageViewHeight);
        }
    }


    public func capture() -> UIImage? {
        return superview?.snapshot
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

