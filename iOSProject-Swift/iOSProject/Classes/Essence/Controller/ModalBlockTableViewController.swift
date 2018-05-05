//
//  ModalBlockTableViewController.swift
//  iOSProject
//
//  Created by CmST0us on 2018/5/4.
//  Copyright © 2018年 eric3u. All rights reserved.
//

import UIKit

class ModalBlockTableViewController: BaseStaticTableViewController {
    
    // MARK: Public Member
    typealias SuccessBlock = (() -> Void)
    var successBlock: SuccessBlock? = nil
    
    // MARK: Private Member
    
    // MARK: Public Method
    deinit {
        Logger.shared.console("deinit")
    }
    // MARK: Private Member
    
}

// MARK: - Life Cycle Method
extension ModalBlockTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
            if let block = self.successBlock {
                block()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

// MARK: - Table View Data Source And Delegate
extension ModalBlockTableViewController {
    
}

// MARK: - StoryBoard Method
extension ModalBlockTableViewController {
    

    
}

