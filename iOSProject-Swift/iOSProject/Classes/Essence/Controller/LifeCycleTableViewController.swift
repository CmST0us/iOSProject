//
//  LifeCycleTableViewController.swift
//  iOSProject
//
//  Created by CmST0us on 2018/5/4.
//  Copyright © 2018年 eric3u. All rights reserved.
//

import UIKit

class LifeCycleTableViewController: BaseStaticTableViewController {
    
    // MARK: Public Member
    
    // MARK: Private Member
    
    // MARK: Public Method
    
    // MARK: Private Member
    func life(_ s: String) {
        let item = BaseWordItem(withTitle: s, subTitle: nil)
        let _ = self.addItem(item)
        
        tableView.reloadData()
    }
}

// MARK: - Life Cycle Method
extension LifeCycleTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        life(#function)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        life(#function)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.life(#function)
    }

//    应为life中会重新加载tableView的数据，导致不断调用这两个方法。解除注释以，并下断点以查看这两个方法的生命周期
    
//    override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//        self.life(#function)
//    }
//
//    override func viewDidLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//        self.life(#function)
//    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.life(#function)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.life(#function)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.life(#function)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.life(#function)
    }
    
}

// MARK: - Table View Data Source And Delegate
extension LifeCycleTableViewController {
    
    
}

// MARK: - StoryBoard Method
extension LifeCycleTableViewController {
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

