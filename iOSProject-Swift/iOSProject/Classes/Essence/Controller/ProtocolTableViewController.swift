//
//  ProtocolTableViewController.swift
//  iOSProject
//
//  Created by CmST0us on 2018/5/4.
//  Copyright © 2018年 eric3u. All rights reserved.
//

import UIKit

class ProtocolTableViewController: BaseStaticTableViewController {
    
    // MARK: Public Member
    
    // MARK: Private Member
    
    // MARK: Public Method
    
    // MARK: Private Method
    
}

// MARK: - Life Cycle Method
extension ProtocolTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Logger.shared.delegate = self
        let userProtocol = UserProtocol()
        userProtocol.connect(OraceDataBase(), withIdentifier: DataBaseConnectionIdentifier.init(rawValue: "id"))
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        Logger.shared.delegate = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}

// MARK: - Table View Data Source And Delegate
extension ProtocolTableViewController {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.numberOfLines = 0
        return cell
    }
}

// MARK: - StoryBoard Method
extension ProtocolTableViewController {
    
    
}

extension ProtocolTableViewController: LoggerDelegate {
    func log(msg: String) {
        let _ = self.addItem(BaseWordItem(withTitle: msg, subTitle: nil))
        self.tableView.reloadData()
    }
}
