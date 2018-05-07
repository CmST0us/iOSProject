//
//  BaseStaticTableViewController.swift
//  iOSProject
//
//  Created by CmST0us on 2018/5/4.
//  Copyright © 2018年 eric3u. All rights reserved.
//

import UIKit

class BaseStaticTableViewController: UITableViewController {
    
    // MARK: Public Member
    /// section数据源
    var sections: [BaseItemSection] = []
    
    // MARK: Private Member
    
    // MARK: Public Method
    init() {
        super.init(style: .grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func addItem(_ item: BaseWordItem, section: Int = 0) -> BaseStaticTableViewController {
        if self.sections.count == 0 {
            self.sections.append(BaseItemSection(withItems: [], andHeaderTitle: nil, footerTitle: nil))
        }
        sections[section].items.append(item)
        return self
    }
    
    // MARK: Private Method
    
}

// MARK: - Life Cycle Method
extension BaseStaticTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

// MARK: - Table View Data Source And Delegate
extension BaseStaticTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.sections[section].items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let wordItem = self.sections[indexPath.section].items[indexPath.row]
        
        let cell = BaseStaticTableViewCell.cell(withTableView: tableView, cellStyle: .value1)
        cell.item = wordItem

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let wordItem = self.sections[indexPath.section].items[indexPath.row]
        
        if wordItem.operation != nil {
            wordItem.operation!(indexPath)
            return
        }
        
        if wordItem is BaseWordArrowItem {
            let wordArrowItem = wordItem as! BaseWordArrowItem
            if let destVCClass = wordArrowItem.destinationViewControllerClass {
                if let destVCType = destVCClass as? UIViewController.Type {
                    let destVC = destVCType.init()
                    destVC.title = wordItem.title
                    self.navigationController?.pushViewController(destVC, animated: true)
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sections[section].headerTitle
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return self.sections[section].footerTitle
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.sections[indexPath.section].items[indexPath.row].cellHeight
    }
}

// MARK: - StoryBoard Method
extension BaseStaticTableViewController {
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

