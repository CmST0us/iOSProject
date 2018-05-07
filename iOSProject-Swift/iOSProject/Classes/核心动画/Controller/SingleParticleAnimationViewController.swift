//
//  SingleParticleAnimationViewController.swift
//  iOSProject
//
//  Created by CmST0us on 2018/5/7.
//  Copyright © 2018年 eric3u. All rights reserved.
//

import UIKit

class SingleParticleAnimationViewController: CALayerViewController {
    
    // MARK: Public Member
    
    // MARK: Private Member
    
    // MARK: Public Method
    var particleAnimationView: ParticleAnimationView!
    // MARK: Private Method
    
}

// MARK: - Life Cycle Method
extension SingleParticleAnimationViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "手指移动划线"
        self.particleAnimationView = ParticleAnimationView(frame: self.view.bounds)
        self.view.addSubview(self.particleAnimationView)
        self.particleAnimationView.startAnimate()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

// MARK: - StoryBoard Method
extension SingleParticleAnimationViewController {
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

