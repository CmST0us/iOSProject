//
//  CALayerCreateNewLayerViewController.swift
//  iOSProject
//
//  Created by CmST0us on 2018/5/7.
//  Copyright © 2018年 eric3u. All rights reserved.
//

import UIKit

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

