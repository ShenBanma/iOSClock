//
//  ContentViewTwo.swift
//  IOSClockDemo
//
//  Created by 沈家瑜 on 15/8/25.
//  Copyright (c) 2015年 沈家瑜. All rights reserved.
//

import UIKit

class TimeInformation: NSObject, NSCoding{
    let timeLong: String
    let timeDate: String
    
    init(timeLong: String, timeDate: String){
        self.timeDate = timeDate
        self.timeLong = timeLong
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(timeLong, forKey: "timeLong")
        aCoder.encodeObject(timeDate, forKey: "timeDate")
    }
    
    required init(coder aDecoder: NSCoder) {
        timeDate = aDecoder.decodeObjectForKey("timeDate") as! String
        timeLong = aDecoder.decodeObjectForKey("timeLong") as! String
    }
}

class ContentViewTwo: UIView,UITableViewDelegate, UITableViewDataSource {
    
    var timeInformationArray: [TimeInformation] = []
    
    var tableView: UITableView!
    
    var view1: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        if let array = NSUserDefaults.standardUserDefaults().objectForKey("array") as? NSData {
            timeInformationArray = NSKeyedUnarchiver.unarchiveObjectWithData(array) as! [TimeInformation]
        }
        let w = frame.width
        let h = frame.height
        let label = UILabel(frame: CGRect(x: w / 2 - 50, y: 5, width: 100, height: 40))
        label.text = "历史记录"
        label.textAlignment = .Center
        label.textColor = UIColor.orangeColor()
        label.backgroundColor = UIColor.clearColor()
        label.font = UIFont.boldSystemFontOfSize(25 * UIScreen.mainScreen().bounds.width / 500)
        tableView = UITableView(frame: CGRect(x: 5, y: 50, width: w - 10, height: h - 55))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clearColor()
        tableView.separatorStyle = .None
        view1 = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: 10))
        view1.backgroundColor = UIColor.clearColor()
        self.addSubview(label)
        self.addSubview(tableView)

    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return timeInformationArray.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        } else {
            return 10
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return view1
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("cell") as? UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cell")
        }
        cell?.layer.cornerRadius = 10
        cell?.selectionStyle = UITableViewCellSelectionStyle.None
        cell?.layer.borderWidth = 2
        cell?.layer.borderColor = UIColor.orangeColor().CGColor
        cell?.backgroundColor = UIColor(white: 1, alpha: 0.2)
        cell?.textLabel?.text = timeInformationArray[indexPath.section].timeLong
        cell?.textLabel?.textColor = UIColor.orangeColor()
        cell?.detailTextLabel?.text = timeInformationArray[indexPath.section].timeDate
        cell?.detailTextLabel?.textColor = UIColor.orangeColor()
        
        return cell!
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
