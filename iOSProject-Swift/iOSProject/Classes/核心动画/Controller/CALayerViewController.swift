//
//  CALayerViewController.swift
//  iOSProject
//
//  Created by CmST0us on 2018/5/7.
//  Copyright © 2018年 eric3u. All rights reserved.
//

import UIKit

class CALayerViewController: BaseViewController {
    
    // MARK: Public Member
    
    // MARK: Private Member
    lazy var redView: UIView = {
        let v = UIView(frame: CGRect(x: 100, y: 100, width: 100, height: 250))
        self.view.addSubview(v)
        v.backgroundColor = UIColor.red
        return v
    }()
    
    lazy var blueLayer: CALayer = {
        let l = CALayer()
        self.view.layer.addSublayer(l)
        l.backgroundColor = UIColor.blue.cgColor
        l.frame = CGRect(x: 150, y: 200, width: 100, height: 60)
        return l
    }()
    
    // MARK: Public Method
    
    // MARK: Private Method
    
}

// MARK: - Life Cycle Method
extension CALayerViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

// MARK: - StoryBoard Method
extension CALayerViewController {
    
    
}

