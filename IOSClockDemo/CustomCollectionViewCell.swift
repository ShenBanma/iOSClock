//
//  CustomCollectionViewCell.swift
//  IOSClockDemo
//
//  Created by 沈家瑜 on 15/8/25.
//  Copyright (c) 2015年 沈家瑜. All rights reserved.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    var label: UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        let w = frame.width
        let h = frame.height
        label = UILabel(frame: CGRect(x: w / 2 - 80, y: h / 2 - 30, width: 160, height: 60))
        label.backgroundColor = UIColor.clearColor()
        label.textColor = UIColor.orangeColor()
        label.textAlignment = .Center
        label.font = UIFont.boldSystemFontOfSize(25 * UIScreen.mainScreen().bounds.width / 500)
        self.contentView.addSubview(label)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
