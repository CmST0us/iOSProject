//
//  CALayerCreateNewLayerViewController.swift
//  iOSProject
//
//  Created by CmST0us on 2018/5/7.
//  Copyright © 2018年 eric3u. All rights reserved.
//

import UIKit
import QuartzCore

class CALayerCreateNewLayerViewController: CALayerViewController {
    
    // MARK: Public Member
    
    // MARK: Private Member
    lazy var myLayer: CALayer = {
        let l = CALayer()
        l.position = CGPoint(x: 200, y: 150)
        l.anchorPoint = CGPoint.zero
        l.bounds = CGRect(x: 0, y: 0, width: 80, height: 80)
        l.backgroundColor = UIColor.green.cgColor
        self.view.layer.addSublayer(l)
        return l
    }()
    // MARK: Public Method
    
    // MARK: Private Method
    
}

// MARK: - Life Cycle Method
extension CALayerCreateNewLayerViewController {
    
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
extension CALayerCreateNewLayerViewController {
    

    
}


// MARK: - Touch Event
extension CALayerCreateNewLayerViewController {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.myLayer.transform = CATransform3DMakeRotation(rad(CGFloat(arc4random_uniform(360) + 1)), 0, 0, 1)
        // position 用anchorPoint来计算坐标
        self.myLayer.position = CGPoint(x: CGFloat(arc4random_uniform(200) + 20), y: CGFloat(arc4random_uniform(400) + 50))
        self.myLayer.cornerRadius = CGFloat(arc4random_uniform(50))
        self.myLayer.borderColor = UIColor.red.cgColor
        self.myLayer.borderWidth = CGFloat(arc4random_uniform(10))
        
    }

}
