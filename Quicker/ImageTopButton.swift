//
//  ImageTopButton.swift
//  Quicker
//
//  Created by CuiLiang on 2018/7/12.
//  Copyright © 2018年 CuiLiang. All rights reserved.
//

import UIKit

@IBDesignable
class ImageTopButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override open var isHighlighted: Bool {
        didSet{
            backgroundColor = isHighlighted ? UIColor(red:0.8, green: 0.8, blue: 0.8, alpha: 1) : UIColor.white;
        }
    }

    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        let btnSize = self.frame.size
        
        let imageWidth = btnSize.width/2.5
        let topPading = (btnSize.height - imageWidth - 20)/2
        
        self.imageView?.frame = CGRect(x: (btnSize.width - imageWidth)/2,
                                       y: topPading,
                                       width: imageWidth,
                                       height: imageWidth)
        self.titleLabel?.frame = CGRect(x: 5,
                                        y: topPading + imageWidth + 2,
                                        width: btnSize.width-10,
                                        height: 20)
        
//        let size = self.frame.size
//        let imageSize = CGSize(width: 16, height: 16) //self.imageView!.intrinsicContentSize
//        let labelSize = self.titleLabel!.intrinsicContentSize
//        let buttonSize = self.frame.size;
//
//        let totalHeight = imageSize.height + labelSize.height
//        let heightDiff = size.height - totalHeight
//        let padding = heightDiff / 2
//
//
//
//        self.imageView!.center = CGPoint(x: size.width / 2, y: imageSize.height / 2 + padding - 5)
//        self.titleLabel!.center = CGPoint(x: size.width / 2, y: imageSize.height + padding + labelSize.height / 1.5 + 5)
//
        self.titleLabel?.textAlignment = .center
//        self.titleLabel?.frame = CGRect(x: 0, y: 20, width: buttonSize.width-20, height: 20)
    }
}
