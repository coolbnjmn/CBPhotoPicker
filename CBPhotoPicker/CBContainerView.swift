//
//  CBContainerView.swift
//  CBPhotoPicker
//
//  Created by Benjamin Hendricks on 11/24/15.
//  Copyright © 2015 coolbnjmn. All rights reserved.
//

import UIKit

public class CBContainerView: UIView {
    public var overlayView : CBOverlayView?
    public var imageView : CBImageView?
 
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setup() {
        imageView = CBImageView(frame: self.frame)
        overlayView = CBOverlayView(frame: self.frame)

        imageView?.setup()
        overlayView?.setup()
        imageView?.overlayDelegate = self
        if let imageView = imageView {
            self.addSubview(imageView)
        }
        if let overlayView = overlayView {
            overlayView.alpha = 0
            self.addSubview(overlayView)
        }
    }
}

extension CBContainerView : CBOverlayViewDelegate {
    public func showOverlay() {
        overlayView?.alpha = 1
    }

    public func hideOverlay() {
        overlayView?.alpha = 0
    }
}