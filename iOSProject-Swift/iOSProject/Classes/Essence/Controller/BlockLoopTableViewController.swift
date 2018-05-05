//
//  BlockLoopTableViewController.swift
//  iOSProject
//
//  Created by CmST0us on 2018/5/4.
//  Copyright © 2018年 eric3u. All rights reserved.
//

import UIKit

class BlockLoopTableViewController: BaseStaticTableViewController {
    
    // MARK: Public Member
    
    // MARK: Private Member
    var myBlockView: UIView!
    // MARK: Public Method
    deinit {
        Logger.shared.console("deinit")
    }
    // MARK: Private Member
    private func loadPage() {
        Logger.shared.output("刷新数据源")
    }
    
    private func myBlockButtonAction() {
        
        BlockLoopOperation.operate { [weak self] in
            self?.showInfoAlert(withTitle: "成功执行完成", message: nil)
        }
        let operation = BlockLoopOperation()
        
        operation.logAddress = { [weak self] (address) in
            self?.showInfoAlert(withTitle: address, message: nil)
        }
        
    }
    
    private func myModalButtonAction() {
        let modalVC = ModalBlockTableViewController()
        modalVC.successBlock = {
            self.loadPage()
        }
        self.navigationController?.pushViewController(modalVC, animated: true)
    }
    
    private func myButtonAction() {
        let childBlockVC = ChildBlockTableViewController()
        childBlockVC.successBlock = {
            self.loadPage()
        }
        self.navigationController?.pushViewController(childBlockVC, animated: true)
    }
}

// MARK: - Life Cycle Method
extension BlockLoopTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myBlockView = UIView()
        myBlockView.backgroundColor = UIColor.red
        myBlockView.frame.size.height = 100
        self.tableView.tableHeaderView = myBlockView
        
        myBlockView.addGestureRecognizer(UITapGestureRecognizer().added { [weak self] in
            self?.showInfoAlert(withTitle: "tap", message: "点击了")
        })
        
        if let _ = self.addItem(BaseWordItem(withTitle: "跳转子页", subTitle: nil, operation: { [weak self] (indexPath) in
                self?.myButtonAction()
            }))
            .addItem(BaseWordItem(withTitle: "弹出模态窗口", subTitle: nil, operation: { [weak self] (indexPath) in
                self?.myModalButtonAction()
            }))
            .addItem(BaseWordItem(withTitle: "响应Block", subTitle: nil, operation: { [weak self] (indexPath) in
                self?.myBlockButtonAction()
            }))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

// MARK: - Table View Data Source And Delegate
extension BlockLoopTableViewController {
    
    
}

// MARK: - StoryBoard Method
extension BlockLoopTableViewController {
    

}

