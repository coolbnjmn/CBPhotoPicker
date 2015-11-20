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
            let photoPicker = CBPhotoPickerViewController(frame: view.frame, aspectRatio: 1, placeholder: nil, cbPhotoPickerStyle: style)
            photoPicker.delegate = self
            self.presentViewController(photoPicker, animated: true, completion: {
            })
        }
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


