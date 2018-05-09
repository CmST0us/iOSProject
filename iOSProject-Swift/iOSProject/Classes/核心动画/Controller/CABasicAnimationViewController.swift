//
//  CABasicAnimationViewController.swift
//  iOSProject
//
//  Created by CmST0us on 2018/5/7.
//  Copyright © 2018年 eric3u. All rights reserved.
//

import UIKit

class CABasicAnimationViewController: CALayerViewController {
    
    // MARK: Public Member
    
    // MARK: Private Member
    
    // MARK: Public Method
    
    // MARK: Private Method
    
}

// MARK: - Life Cycle Method
extension CABasicAnimationViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

// MARK: - StoryBoard Method
extension CABasicAnimationViewController {
    

}


// MARK: - Touch Events
extension CABasicAnimationViewController {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // TODO 注意一下render tree.
        // 提供的 Key-Path 在此 https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/CoreAnimation_guide/Key-ValueCodingExtensions/Key-ValueCodingExtensions.html#//apple_ref/doc/uid/TP40004514-CH12-SW2
        let animation = CABasicAnimation(keyPath: "transform.scale")
        
        // 设置值
        animation.toValue = NSNumber(value: 0.2)
        
        animation.fromValue = NSNumber(value: 0.7)
        
        animation.beginTime = CACurrentMediaTime() + 2
        // 重复次数
        animation.repeatCount = 1
        
        // 是否在播放结束后移除动画
        animation.isRemovedOnCompletion = false
        
        // 让动画保持在最后
        /*
         kCAFillModeBackwards 先迅速进入fromValue状态，然后等待beginTime，再进行动画，动画结束后回到初始位置
         kCAFillModeForwards  先等待beginTime，然后，迅速今日fromValue状态，再进行动画，动画结束后保持结束后的状态
         kCAFillModeBoth      迅速进入fromValue,然后等待beginTime,动画结束后保持结束后的状态
         */
        animation.fillMode = kCAFillModeBoth
        
        // add 的参数是一个CAAnimation，CAAnimation是动画抽象类，其子类有属性动画CAProertyAnimation、CABasicAnimation等，所以这里的Key应该为子类提供（假设）
        self.redView.layer.add(animation, forKey: nil)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // 动画后的frame和layer.frame都是不变的
        // 用ViewDebugger看到的视图也表明了视图frame是不变的，那负责render动画后试图的是什么？-> fillMode的影响
        //
        // TODO 这里怎么不能弹出两个窗口了，用keyWindows.rootViewController试试
        // TODO 看看有什么方法可以把任务放到下一个RunLoop中，先不管
        
//        mainQueue {
//            self.showInfoAlert(withTitle: "动画后的frame", message: NSStringFromCGRect(self.redView.frame))
//        }
//
//        mainQueue {
//            self.showInfoAlert(withTitle: "动画后的layer.frame", message: NSStringFromCGRect(self.redView.layer.frame))
//        }
    }
    
}
