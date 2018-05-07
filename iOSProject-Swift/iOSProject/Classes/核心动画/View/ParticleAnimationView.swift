//
//  ParticleAnimationView.swift
//  iOSProject
//
//  Created by CmST0us on 2018/5/7.
//  Copyright © 2018年 eric3u. All rights reserved.
//


// 完 全 没 用




//
import UIKit

class ParticleAnimationView: UIView {
    
    static var instanceCount = 0
    
    var path: UIBezierPath!
    var dotLayer: CALayer!
    var repLayer: CAReplicatorLayer!
    
    override func draw(_ rect: CGRect) {
        if path != nil {
            path.stroke()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        repLayer = CAReplicatorLayer()
        repLayer.frame = self.bounds
        self.layer.addSublayer(repLayer)
        
        dotLayer = CALayer()
        let wh = CGFloat(10)
        dotLayer.frame = CGRect(x: 0, y: -1000, width: wh, height: wh)
        dotLayer.cornerRadius = wh / 2
        dotLayer.backgroundColor = UIColor.blue.cgColor
        repLayer.addSublayer(dotLayer)
        path = UIBezierPath()
    }
    
    func startAnimate() {
        dotLayer.removeAnimation(forKey: "CAKeyframeAnimation")
        dotLayer.isHidden = false
        
        let ani = CAKeyframeAnimation()
        ani.keyPath = "position"
        ani.path = path.cgPath
        ani.duration = 4
        ani.repeatCount = Float.infinity
        dotLayer.add(ani, forKey: "CAKeyframeAnimation")
        
        repLayer.instanceCount = ParticleAnimationView.instanceCount
        repLayer.instanceDelay = 0.1
    }
    
    func redraw() {
        path = UIBezierPath()
        self.setNeedsDisplay()
        ParticleAnimationView.instanceCount = 0
        dotLayer.isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Touch Event
extension ParticleAnimationView {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.redraw()
        
        if let touch = touches.first {
            let cur = touch.location(in: self)
            path.move(to: cur)
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let cur = touch.location(in: self)
            path.addLine(to: cur)
            self.setNeedsDisplay()
            ParticleAnimationView.instanceCount += 1
        }
    }
}
