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
    var animator : UIDynamicAnimator?
    var scale : CGFloat = 1
    
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
        pinchGestureRecognizer.delegate = self
        self.addGestureRecognizer(pinchGestureRecognizer)
        
        let rotationGestureRecognizer = UIRotationGestureRecognizer(target: self, action: "handleRotate:")
        rotationGestureRecognizer.delegate = self
        self.addGestureRecognizer(rotationGestureRecognizer)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "handlePan:")
        panGestureRecognizer.delegate = self
        self.addGestureRecognizer(panGestureRecognizer)
        
        let touchGestureRecognizer = UILongPressGestureRecognizer(target: self, action: "handleTap:")
        touchGestureRecognizer.delegate = self
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
            self.scale *= scale
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
            if let imageView = imageView {
                if shouldSnap(imageView.frame, superFrame: frame) {
                    let pushBehavior : UIPushBehavior = UIPushBehavior(items: [imageView], mode: UIPushBehaviorMode.Continuous)
                    pushBehavior.setTargetOffsetFromCenter(UIOffset(horizontal: 0, vertical: 0), forItem: imageView)
                    if let animator = self.animator {
                        animator.removeAllBehaviors()
                        animator.addBehavior(pushBehavior)
                    } else {
                        if let superview = self.superview {
                            self.animator = UIDynamicAnimator(referenceView: superview)
                            self.animator?.addBehavior(pushBehavior)
                        }
                    }
                    imageView.transform = CGAffineTransformScale(imageView.transform, scale, scale)
                }
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
            imageView.transform = CGAffineTransformTranslate(CGAffineTransformScale(imageView.transform, 1, 1), translation.x, translation.y)
            view.overlayView?.alpha = 1
            recognizer.setTranslation(CGPointZero, inView: imageView)
        } else if let view = recognizer.view as? CBImageView where state == .Ended {
            view.overlayView?.alpha = 0

            if let imageView = imageView {
                if shouldSnap(imageView.frame, superFrame: frame) {
                    let pushBehavior : UIPushBehavior = UIPushBehavior(items: [imageView], mode: UIPushBehaviorMode.Continuous)
                    pushBehavior.setTargetOffsetFromCenter(UIOffset(horizontal: 0, vertical: 0), forItem: imageView)
                    if let animator = self.animator {
                        animator.removeAllBehaviors()
                        animator.addBehavior(pushBehavior)
                    } else {
                        if let superview = self.superview {
                            self.animator = UIDynamicAnimator(referenceView: superview)
                            self.animator?.addBehavior(pushBehavior)
                        }
                    }
                    imageView.transform = CGAffineTransformScale(imageView.transform, scale, scale)
                }
            }

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
    
    func shouldSnap(frame : CGRect, superFrame : CGRect) -> Bool {
        if frame.origin.x > superFrame.origin.x || frame.origin.y > superFrame.origin.y || frame.origin.x+frame.size.width < superFrame.origin.x + superFrame.size.width || frame.origin.y + frame.size.height < superFrame.origin.y + superFrame.size.height {
            return true
        }
        return false
    }
}

extension CBImageView : UIGestureRecognizerDelegate {
    public func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if let _ = gestureRecognizer as? UIRotationGestureRecognizer, let _ = otherGestureRecognizer as?UIPinchGestureRecognizer {
            return true
        } else if let _ = otherGestureRecognizer as? UIRotationGestureRecognizer, let _ = gestureRecognizer as?UIPinchGestureRecognizer {
            return true
        }
        return false
    }

}

