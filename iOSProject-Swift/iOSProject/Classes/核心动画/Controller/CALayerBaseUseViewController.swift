//
//  CALayerBaseUseViewController.swift
//  iOSProject
//
//  Created by CmST0us on 2018/5/7.
//  Copyright © 2018年 eric3u. All rights reserved.
//

import UIKit

class CALayerBaseUseViewController: CALayerViewController {
    
    // MARK: Public Member
    
    // MARK: Private Member
    
    // MARK: Public Method
    
    // MARK: Private Method
    
}

// MARK: - Life Cycle Method
extension CALayerBaseUseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置阴影
        // Opacity: 不透明度
        self.redView.layer.shadowOpacity = 1
        
        // 阴影颜色
        self.redView.layer.shadowColor = UIColor.yellow.cgColor
        
        // 阴影半径
        self.redView.layer.shadowRadius = 10
        
        // 边框
        self.redView.layer.borderColor = UIColor.white.cgColor
        self.redView.layer.borderWidth = 1
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

// MARK: - StoryBoard Method
extension CALayerBaseUseViewController {
    

}


// MARK: - Touch Event
extension CALayerBaseUseViewController {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 图层渐变
        UIView.animate(withDuration: 1) {
            // 以(1, 1, 0)为轴旋转angle弧度
            self.redView.layer.transform = CATransform3DMakeRotation(rad(45), 1, 1, 0)
            //
//            self.redView.layer.transform = CATransform3DMakeScale(0.5, 0.5, 1)
        }
    }
    
}

/**
 CATransform3D 维护了一个4x4变化矩阵
 
 
 */
