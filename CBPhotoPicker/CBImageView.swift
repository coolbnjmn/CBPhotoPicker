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

public class CBImageView: UIView {
    var imageView: UIImageView?
    var overlayView : CBOverlayView?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        imageView = UIImageView(frame: self.frame)
        overlayView = CBOverlayView(frame: self.frame)
        if let imageView = imageView {
            imageView.userInteractionEnabled = true
            self.addSubview(imageView)
        }
        if let overlayView = overlayView {
            overlayView.userInteractionEnabled = false
            overlayView.alpha = 0
            self.addSubview(overlayView) 
        }
        
        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: "handlePinch:")
        self.addGestureRecognizer(pinchGestureRecognizer)
        
        let rotationGestureRecognizer = UIRotationGestureRecognizer(target: self, action: "handleRotate:")
        self.addGestureRecognizer(rotationGestureRecognizer)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "handlePan:")
        self.addGestureRecognizer(panGestureRecognizer)
        
        let touchGestureRecognizer = UILongPressGestureRecognizer(target: self, action: "handleTap:")
        touchGestureRecognizer.minimumPressDuration = 0.3
        self.addGestureRecognizer(touchGestureRecognizer)
    }
    
    public func capture() -> UIImage? {
        return self.snapshot
    }
    
    func handlePinch(recognizer: UIPinchGestureRecognizer) {
        let state : UIGestureRecognizerState = recognizer.state
        
        if state == .Began || state == .Changed {
            let scale = recognizer.scale
            if let view = recognizer.view as? CBImageView,
                let imageView = view.imageView {
                    view.overlayView?.alpha = 1
                    imageView.transform = CGAffineTransformScale(imageView.transform, scale, scale)
            }
            recognizer.scale = 1.0
        } else if state == .Ended {
            if let view = recognizer.view as? CBImageView {
                view.overlayView?.alpha = 0
            }
        }
    }
    
    func handleRotate(recognizer: UIRotationGestureRecognizer) {
        let state : UIGestureRecognizerState = recognizer.state
        
        if state == .Began || state == .Changed {
            let rotation = recognizer.rotation
            if let view = recognizer.view as? CBImageView,
                let imageView = view.imageView {
                    view.overlayView?.alpha = 1
                    imageView.transform = CGAffineTransformRotate(imageView.transform, rotation)
            }
            recognizer.rotation = 0
        } else if state == .Ended {
            if let view = recognizer.view as? CBImageView {
                view.overlayView?.alpha = 0
            }
        }
    }
    
    
    func handlePan(recognizer: UIPanGestureRecognizer) {
        let state : UIGestureRecognizerState = recognizer.state
        
        if let view = recognizer.view as? CBImageView, let imageView = view.imageView where state == .Began || state == .Changed {
            let translation = recognizer.translationInView(view)
            imageView.transform = CGAffineTransformTranslate(imageView.transform, translation.x, translation.y)
            view.overlayView?.alpha = 1
            recognizer.setTranslation(CGPointZero, inView: imageView)
        } else if let view = recognizer.view as? CBImageView where state == .Ended {
            view.overlayView?.alpha = 0
        }
        
    }
    
    func handleTap(recognizer: UILongPressGestureRecognizer) {
        let state : UIGestureRecognizerState = recognizer.state
        
        if let view = recognizer.view as? CBImageView where state == .Began || state == .Changed {
            view.overlayView?.alpha = 1
        } else if let view = recognizer.view as? CBImageView {
            view.overlayView?.alpha = 0
        }
    }
}

