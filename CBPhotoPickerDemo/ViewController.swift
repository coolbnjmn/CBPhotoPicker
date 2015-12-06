//
//  ViewController.swift
//  CBPhotoPickerDemo
//
//  Created by Benjamin Hendricks on 11/14/15.
//  Copyright © 2015 coolbnjmn. All rights reserved.
//

import UIKit

class ViewController: UIViewController, CBPhotoPickerViewControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    var photoPicker: CBPhotoPickerViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.userInteractionEnabled = true
        let touchGestureRecognizer = UITapGestureRecognizer(target: self, action: "handleTap:")
        imageView.addGestureRecognizer(touchGestureRecognizer)
        // Do any additional setup after loading the view, typically from a nib.
    }

    func handleTap(recognizer: UITapGestureRecognizer) {
        let style = CBPhotoPickerStyle.customStyle(UIColor.blueColor(), tintColor: UIColor.whiteColor())
        if let style = style {
            photoPicker = CBPhotoPickerViewController(frame: view.frame, aspectRatio: 2, placeholder: nil, cbPhotoPickerStyle: style)
            if let photoPicker = photoPicker {
                photoPicker.delegate = self
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "handleExit:")
                tapGestureRecognizer.numberOfTapsRequired = 3
                self.presentViewController(photoPicker, animated: true, completion: {
                    photoPicker.previewImageView?.addGestureRecognizer(tapGestureRecognizer)
                })
            }
           
        }
    }
    
    func handleExit(recognizer: UIGestureRecognizer) {
        handleSuccess(photoPicker?.handleDone())
    }
    
    func handleSuccess(resultImage: UIImage?) {
        if let resultImage = resultImage {
            imageView.image = resultImage
        }
        self.dismissViewControllerAnimated(true, completion: {
        
        })
    }
    
    func handleCancel() {
        self.dismissViewControllerAnimated(true, completion: {
            
        })
    }
}


