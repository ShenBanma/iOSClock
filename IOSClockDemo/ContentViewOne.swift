//
//  ContentViewOne.swift
//  IOSClockDemo
//
//  Created by 沈家瑜 on 15/8/25.
//  Copyright (c) 2015年 沈家瑜. All rights reserved.
//

import UIKit

protocol SelectResultDelegate {
    func getSelectResult(index: Int)
}

class ContentViewOne: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var customFrame:CGRect!
    
    var delegate: SelectResultDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: frame, collectionViewLayout: collectionViewFlowLayout)
        collectionView.backgroundColor = UIColor.clearColor()
        collectionView.registerClass(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "customCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        self.addSubview(collectionView)
        customFrame = frame
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return 5
    }
    

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("customCell", forIndexPath: indexPath) as! CustomCollectionViewCell
        switch indexPath.row {
        case 0:
            cell.backgroundColor = UIColor(white: 1, alpha: 0.2)
            cell.label.text = "开始"
        case 1:
            cell.backgroundColor = UIColor(white: 1, alpha: 0.2)
            cell.label.text = "停止"
        case 2:
            cell.backgroundColor = UIColor(white: 1, alpha: 0.2)
            cell.label.text = "复位"
        case 3:
            cell.backgroundColor = UIColor(white: 1, alpha: 0.2)
            cell.label.text = "增加1秒"
        case 4:
            cell.backgroundColor = UIColor(white: 1, alpha: 0.2)
            cell.label.text = "增加1分"
        default:
            break
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let w = customFrame.width - 10
        let h = customFrame.height - 10
        switch indexPath.row {
        case 0:
            return CGSize(width: w, height: (h - 10) / 3)
        default:
            return CGSize(width: (w - 5) / 2, height: (h - 10) / 3)
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//        let animat = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY)
//        animat.fromValue = NSValue(CGPoint: CGPoint(x: 1, y: 1))
//        animat.toValue = NSValue(CGPoint: CGPoint(x: 0.8, y: 0.8))
//        animat.autoreverses = true
//        animat.springBounciness = 15
//        animat.springSpeed = 20
//        collectionView.cellForItemAtIndexPath(indexPath)?.layer.pop_addAnimation(animat, forKey: nil)
        delegate?.getSelectResult(indexPath.row)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 5
    }
    

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
