//
//  ClockViewController.swift
//  iOSProject
//
//  Created by CmST0us on 2018/5/7.
//  Copyright © 2018年 eric3u. All rights reserved.
//

import UIKit

class ClockViewController: CALayerViewController {
    
    // MARK: Public Member
    
    // MARK: Private Member
    let kClockWidth = 200.0
    let perMinuteAngle = 6.0
    let perSecondAngle = 6.0
    let perHourAngle = 30.0
    let perMinuteHourAngle = 0.5
    
    private var hourLayer: CALayer!
    private var minuteLayer: CALayer!
    private var secondLayer: CALayer!
    private var timer: Timer!
    
    private lazy var clockView: UIView = {
        let v = UIView(frame: CGRect(x: 100, y: 100, width: kClockWidth, height: kClockWidth))
        v.backgroundColor = UIColor.white
        v.layer.borderColor = UIColor.gray.cgColor
        v.layer.borderWidth = 1
        v.layer.cornerRadius = CGFloat(kClockWidth * 0.5)
        self.view.addSubview(v)
        return v
    }()
    // MARK: Public Method
    
    // MARK: Private Method
    private func setupHourLayer() {
        hourLayer = CALayer()
        hourLayer.anchorPoint = CGPoint(x: 0.5, y: 1)
        hourLayer.backgroundColor = UIColor.black.cgColor
        hourLayer.bounds = CGRect(x: 0, y: 0, width: 4, height: kClockWidth / 2 - 40)
        hourLayer.position = CGPoint(x: kClockWidth * 0.5, y: kClockWidth * 0.5)
        clockView.layer.addSublayer(hourLayer)
    }
    
    private func setupMinuteLayer() {
        minuteLayer = CALayer()
        minuteLayer.anchorPoint = CGPoint(x: 0.5, y: 1)
        minuteLayer.backgroundColor = UIColor.brown.cgColor
        minuteLayer.bounds = CGRect(x: 0, y: 0, width: 1, height: kClockWidth / 2 - 30)
        minuteLayer.position = CGPoint(x: kClockWidth * 0.5, y: kClockWidth * 0.5)
        clockView.layer.addSublayer(minuteLayer)
    }
    
    private func setupSecondLayer() {
        secondLayer = CALayer()
        secondLayer.anchorPoint = CGPoint(x: 0.5, y: 1)
        secondLayer.backgroundColor = UIColor.red.cgColor
        secondLayer.bounds = CGRect(x: 0, y: 0, width: 1, height: kClockWidth / 2 - 20)
        secondLayer.position = CGPoint(x: kClockWidth * 0.5, y: kClockWidth * 0.5)
        clockView.layer.addSublayer(secondLayer)
    }
    
    @objc
    private func updateClock() {
        let calendar = Calendar.current
        let cmp = calendar.dateComponents([.second, .minute, .hour], from: Date.init())
        
        let second = Double(cmp.second!)
        let hour = Double(cmp.hour!)
        let minute = Double(cmp.minute!)
        
        let secondAngle = second * perSecondAngle
        let minuteAngle = minute * perMinuteAngle
        let hourAngle = hour * perHourAngle + minute * perMinuteHourAngle
        
        // 隐式动画
        secondLayer.transform = CATransform3DMakeRotation(rad(CGFloat(secondAngle)), 0, 0, 1)
        minuteLayer.transform = CATransform3DMakeRotation(rad(CGFloat(minuteAngle)), 0, 0, 1)
        hourLayer.transform = CATransform3DMakeRotation(rad(CGFloat(hourAngle)), 0, 0, 1)
        
        
        
    }
}

// MARK: - Life Cycle Method
extension ClockViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupHourLayer()
        self.setupMinuteLayer()
        self.setupSecondLayer()
        
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateClock), userInfo: nil, repeats: true)
        self.updateClock()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.timer.invalidate()
        self.timer = nil
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

// MARK: - StoryBoard Method
extension ClockViewController {
    
    
}

