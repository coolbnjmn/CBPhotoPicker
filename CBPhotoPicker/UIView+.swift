//
//  UIView+.swift
//  CBPhotoPicker
//
//  Created by Benjamin Hendricks on 11/14/15.
//  Copyright © 2015 coolbnjmn. All rights reserved.
//

import UIKit

public class UIView_: NSObject {
}

extension UIView {
    var snapshot: UIImage {
        get {
            UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.mainScreen().scale)
            self.drawViewHierarchyInRect(self.bounds, afterScreenUpdates: true)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image
        }
    }
}