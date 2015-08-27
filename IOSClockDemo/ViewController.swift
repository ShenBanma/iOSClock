//
//  ViewController.swift
//  IOSClockDemo
//
//  Created by 沈家瑜 on 15/8/25.
//  Copyright (c) 2015年 沈家瑜. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate, SelectResultDelegate {
    var fromRotation: Double = 0
    
    var smallFromRotation: Double = 0
    
    var bigPointView : UIView!
    
    var smallPointView: UIView!
    
    var secondPointView: UIView!
    
    var timer1: NSTimer?
    
    var timer2: NSTimer?
    
    var scrollView: UIScrollView!
    
    var page: UIPageControl!
    
    var textLabel: UILabel!
    
    var autoFinish = true
    
    var tableView:ContentViewTwo!
    
    var saveTime: String = ""
    
    var indexNumer = 0
    
    var isStarting = false
    
    var time: Int = 0 {
        didSet {
            if time >= 0 {
                var timeString = ""
                let m = time / 60
                let s = time % 60
                
                if m < 10 {
                    timeString = "0\(m)"
                }else if m >= 10 {
                    timeString = "\(m)"
                }
                
                if s < 10 {
                    timeString += ":0\(s)"
                } else if s >= 10 {
                    timeString += ":\(s)"
                }
                
                textLabel.text = timeString
                
                if autoFinish && time == 0 {
                    let alert = UIAlertView(title: "计时结束", message: "你已经完成计时，请到历史记录查看", delegate: nil, cancelButtonTitle: "我知道了")
                    alert.show()
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "MM-dd HH:mm:ss"
                    let date = NSDate()
                    let timeDate = dateFormatter.stringFromDate(date)
                    tableView.timeInformationArray.insert(TimeInformation(timeLong: saveTime, timeDate: "计时结束:" + timeDate), atIndex: 0)
                    tableView.tableView.reloadData()
                    let array = NSKeyedArchiver.archivedDataWithRootObject(tableView.timeInformationArray) as NSData
                    NSUserDefaults.standardUserDefaults().setObject(array, forKey: "array")
                    reload()
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
//        startRotate()
    }
    
    func initView() {
        let w = view.bounds.width
        let h = view.bounds.height
        let imageView = UIImageView(frame: CGRect(x: w * 1 / 10, y: 20, width: w * 4 / 5, height: w * 4 / 5))
        imageView.image = UIImage(named: "clock")
        imageView.layer.cornerRadius = w * 2 / 5
        imageView.clipsToBounds = true
        
        let smallImageView = UIImageView(frame: CGRect(x: w * (1 / 2 - 1 / 5), y: 20 + imageView.bounds.height / 2, width: imageView.bounds.width / 2, height: imageView.bounds.width / 2))
        smallImageView.image = UIImage(named: "clock")
        smallImageView.layer.cornerRadius = imageView.bounds.width / 4
        smallImageView.clipsToBounds = true
        
        bigPointView = UIView(frame: imageView.bounds)
        bigPointView.backgroundColor = UIColor.clearColor()
        smallPointView = UIView(frame: smallImageView.bounds)
        smallPointView.backgroundColor = UIColor.clearColor()
        secondPointView = UIView(frame: imageView.bounds)
        secondPointView.backgroundColor = UIColor.clearColor()
        
        let bigPoint = UIView(frame: CGRect(x: bigPointView.bounds.width / 2 - 1, y: 5, width: 2 , height: bigPointView.bounds.height / 2 - 5))
        bigPoint.backgroundColor = UIColor.blackColor()
        bigPoint.alpha = 0.8
        bigPoint.layer.shouldRasterize = true
        let smallPoint = UIView(frame: CGRect(x: smallPointView.bounds.width / 2 - 1, y: 3, width: 2 , height: smallPointView.bounds.height / 2 - 3))
        smallPoint.backgroundColor = UIColor.blackColor()
        smallPoint.alpha = 0.8
        smallPoint.layer.shouldRasterize = true
        let secondPoint = UIView(frame: CGRect(x: bigPointView.bounds.width / 2 - 2, y: bigPointView.bounds.height * 2 / 5, width: 4, height: bigPointView.bounds.height / 10))
        secondPoint.backgroundColor = UIColor.redColor()
        secondPoint.alpha = 0.5
        secondPoint.layer.shouldRasterize = true
        
        let blur = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let effectView = UIVisualEffectView(effect: blur)
        effectView.frame = view.bounds
        
        bigPointView.addSubview(bigPoint)
        secondPointView.addSubview(secondPoint)
        smallPointView.addSubview(smallPoint)
        
        imageView.addSubview(bigPointView)
        imageView.addSubview(secondPointView)
        smallImageView.addSubview(smallPointView)
        
        let view1 = UIView(frame: imageView.frame)
        view1.layer.cornerRadius = imageView.bounds.width / 2
        view1.backgroundColor = UIColor.yellowColor()
        
        let view2 = UIView(frame: smallImageView.frame)
        view2.layer.cornerRadius = smallImageView.bounds.width / 2
        view2.backgroundColor = UIColor.redColor()
        
        view.backgroundColor = UIColor.orangeColor()
        
        scrollView = UIScrollView(frame: CGRect(x: 10, y: 20 + imageView.bounds.height + 20, width: w - 20, height: h - 60 - imageView.bounds.height))
        scrollView.backgroundColor = UIColor(white: 1, alpha: 0.1)
        scrollView.layer.cornerRadius = 10
        scrollView.contentSize = CGSize(width: scrollView.bounds.width * 2, height: scrollView.bounds.height)
        scrollView.pagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self

        let collectionView = ContentViewOne(frame: CGRect(x: 0, y: 0, width: scrollView.bounds.width, height: scrollView.bounds.height))
        scrollView.addSubview(collectionView)
        collectionView.delegate = self
        
        tableView = ContentViewTwo(frame: CGRect(x: scrollView.bounds.width, y: 0, width: scrollView.bounds.width, height: scrollView.bounds.height))
        scrollView.addSubview(tableView)
        
        page = UIPageControl(frame: CGRect(x: w / 2 - 15, y: 20 + imageView.bounds.height + 20 + scrollView.bounds.height, width: 30, height: 20))
        page.numberOfPages = 2
        page.currentPage = 0
        page.addTarget(self, action: "changeValue:", forControlEvents: UIControlEvents.ValueChanged)
        
        textLabel = UILabel(frame: CGRect(x: w * 1 / 10 + w * 2 / 25 + 15, y: 20 + imageView.bounds.height * 1 / 4, width: w - (w * 1 / 10 + w * 2 / 25) * 2 - 30, height: imageView.bounds.height * 1 / 4 - 10))
        textLabel.backgroundColor = UIColor.clearColor()
        textLabel.layer.cornerRadius = 30
        textLabel.text = "00:00"
        textLabel.font = UIFont.boldSystemFontOfSize(40 * UIScreen.mainScreen().bounds.width / 500)
        textLabel.textAlignment = .Center
        
        view.addSubview(view1)
        view.addSubview(view2)
    
        view.addSubview(effectView)
        view.addSubview(textLabel)
        view.addSubview(imageView)
        view.addSubview(smallImageView)
        view.addSubview(scrollView)
        view.addSubview(page)
        
    }
    
    func changeValue(sender: UIPageControl) {
        if sender.currentPage == 0 {
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        } else if sender.currentPage == 1 {
            scrollView.setContentOffset(CGPoint(x: scrollView.bounds.width, y: 0), animated: true)
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.x == 0 {
            page.currentPage = 0
        } else if scrollView.contentOffset.x == scrollView.bounds.width {
            page.currentPage = 1
        }
    }
    
    func secondRotation() {
        var animatSecond = secondPointView.layer.pop_animationForKey("secondRotation") as? POPBasicAnimation
        if animatSecond != nil {
            animatSecond!.fromValue = 0
            animatSecond!.toValue = M_PI * 2
        }else {
            animatSecond = POPBasicAnimation(propertyNamed: kPOPLayerRotation)
            animatSecond?.fromValue = 0
            animatSecond?.toValue = 2 * M_PI
            animatSecond?.duration = 1
            animatSecond?.repeatCount = 1
            animatSecond?.timingFunction = CAMediaTimingFunction(name: "linear")
            secondPointView.layer.pop_addAnimation(animatSecond, forKey: nil)
        }
    }
    
    func startRotate() {
        secondRotation()
        timer1 = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "bigPointRotate", userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(timer1!, forMode: NSRunLoopCommonModes)
        
//        timer2 = NSTimer.scheduledTimerWithTimeInterval(60, target: self, selector: "smallPointRotate", userInfo: nil, repeats: true)
//        NSRunLoop.currentRunLoop().addTimer(timer2!, forMode: NSRunLoopCommonModes)
    }
    
    func bigPointRotate() {
        secondRotation()
        if saveTime == "1秒" {
            fromRotation += M_PI / 30
            time--
            return
        }
        indexNumer++
        if indexNumer % 60 == 0 {
            smallPointRotate()
            indexNumer = 0
        }
        
        var animat = bigPointView.layer.pop_animationForKey("rotation") as? POPSpringAnimation
        if animat != nil {
            animat!.fromValue = fromRotation
            animat!.toValue = fromRotation + M_PI / 30
        } else {
            animat = POPSpringAnimation(propertyNamed: kPOPLayerRotation)
            animat!.fromValue = fromRotation 
            animat!.toValue = fromRotation + M_PI / 30
            animat!.springBounciness = 15
            animat!.springSpeed = 10
            animat!.autoreverses = false
            bigPointView.layer.pop_addAnimation(animat, forKey: "rotation")
        }
        fromRotation += M_PI / 30
        time--
        
    }
    
    func smallPointRotate() {
        var animat = smallPointView.layer.pop_animationForKey("smallRotation") as? POPSpringAnimation
        if animat != nil {
            animat!.fromValue = smallFromRotation
            animat!.toValue = smallFromRotation + M_PI / 30
        } else {
            animat = POPSpringAnimation(propertyNamed: kPOPLayerRotation)
            animat!.fromValue = smallFromRotation
            animat!.toValue = smallFromRotation + M_PI / 30
            animat!.springBounciness = 15
            animat!.springSpeed = 10
            smallPointView.layer.pop_addAnimation(animat, forKey: "smallRotation")
        }
        smallFromRotation += M_PI / 30
    }
    
    func getSelectResult(index: Int) {
        switch index {
        case 0:start()
        case 1:stop()
        case 2:reload()
        case 3:addOneSecond()
        case 4:addOneMinute()
        default: break
        }
    }
    
    func stopRotate() {
        timer1?.invalidate()
        timer2?.invalidate()
    }
    
    func start() {
        if time != 0 && !isStarting {
            isStarting = true
            autoFinish = true
            savingTime()
            notificationAfterTime(time)
            startRotate()
        }
    }
    
    func stop() {
        isStarting = false
        stopRotate()
    }
    
    func reload() {
        stop()
        isStarting = false
        autoFinish = false
        time = 0
        indexNumer = 0
        saveTime = ""
        let animat = POPSpringAnimation(propertyNamed: kPOPLayerRotation)
        animat.fromValue = fromRotation % (2 * M_PI)
        animat.toValue = 0
        animat.springBounciness = 0
        animat.springSpeed = 0
        animat.autoreverses = false
        bigPointView.layer.pop_addAnimation(animat, forKey: nil)
        
        let animat1 = POPSpringAnimation(propertyNamed: kPOPLayerRotation)
        animat1.fromValue = smallFromRotation % (2 * M_PI)
        animat1.toValue = 0
        animat1.springBounciness = 0
        animat1.springSpeed = 0
        animat1.autoreverses = false
        smallPointView.layer.pop_addAnimation(animat1, forKey: nil)
        
        fromRotation = 0
        smallFromRotation = 0
    }
    
    func addOneSecond() {
        time++
    }
    
    func addOneMinute() {
        time += 60
    }
    
    func savingTime() {
        let m = time / 60
        let s = time % 60
        var string = ""
        if m == 0 {
            string = "\(s)秒"
        }else {
            string = "\(m)分\(s)秒"
        }
        saveTime = string
    }
    
    func notificationAfterTime(second: Int) {
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        
        let notification = UILocalNotification()
        notification.fireDate = NSDate(timeIntervalSinceNow: (second as NSNumber).doubleValue)
        
        notification.timeZone = NSTimeZone.systemTimeZone()
        notification.alertBody = "计时完成!"
        
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

