//
//  MainTabBarController.swift
//  iOSProject
//
//  Created by CmST0us on 2018/5/4.
//  Copyright © 2018年 eric3u. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    // MARK: Public Member
    
    // MARK: Private Member
    
    // MARK: Public Method
    
    // MARK: Private Member
    private func setupChildViewControllers() {
        let essenceTableViewController = EssenceTableViewController()
        essenceTableViewController.title = "基础"
        let essenceNav = UINavigationController(rootViewController: essenceTableViewController)
        essenceNav.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 0)
        self.viewControllers = [essenceNav]
    }
    
    
}

// MARK: - Life Cycle Method
extension MainTabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        self.tabBar.tintColor = UIColor.red
        
        setupChildViewControllers()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension MainTabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true
    }
    
}

// MARK: - StoryBoard Method
extension MainTabBarController {
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

