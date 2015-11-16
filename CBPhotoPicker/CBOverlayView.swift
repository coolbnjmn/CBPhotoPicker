//
//  CBOverlayView.swift
//  CBPhotoPicker
//
//  Created by Benjamin Hendricks on 11/15/15.
//  Copyright © 2015 coolbnjmn. All rights reserved.
//

import UIKit

public class CBOverlayView: UIView {
    var horizontalGridLines : [UIView] = []
    var verticalGridLines : [UIView] = []
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        userInteractionEnabled = false
        setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var lineView : (()->UIView) =  {
        let newLine = UIView(frame: CGRectZero)
        newLine.backgroundColor = UIColor.whiteColor()
        self.addSubview(newLine)
        return newLine
    }
    
    public func setup() {
        horizontalGridLines = [lineView(), lineView()]
        verticalGridLines = [lineView(), lineView()]
        
        let thickness : CGFloat = 1 / UIScreen.mainScreen().scale
        let numberOfLines : CGFloat = CGFloat(horizontalGridLines.count)
    
        let horizontalPadding : CGFloat = (self.bounds.height - (thickness * numberOfLines)) / (numberOfLines + 1)
        let verticalPadding : CGFloat = (self.bounds.width - (thickness * numberOfLines)) / (numberOfLines + 1)
        for var i = 0; i < horizontalGridLines.count; i++ {
            let horizontalLineView = horizontalGridLines[i]
            let verticalLineView = verticalGridLines[i]
            
            var horizontalFrame = CGRectZero
            var verticalFrame = CGRectZero
            horizontalFrame.size.height = thickness
            horizontalFrame.size.width = self.bounds.width
            horizontalFrame.origin.y = (horizontalPadding * CGFloat(i+1)) + (thickness * CGFloat(i))
            horizontalLineView.frame = horizontalFrame
            
            verticalFrame.size.height = self.bounds.height
            verticalFrame.size.width = thickness
            verticalFrame.origin.x = (verticalPadding * CGFloat(i+1)) + (thickness * CGFloat(i))
            verticalLineView.frame = verticalFrame
        }
    }
}
