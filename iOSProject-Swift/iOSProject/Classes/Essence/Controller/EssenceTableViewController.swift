//
//  EssenceTableViewController.swift
//  iOSProject
//
//  Created by CmST0us on 2018/5/4.
//  Copyright © 2018年 eric3u. All rights reserved.
//

import UIKit

class EssenceTableViewController: BaseStaticTableViewController {
    
    let sectionsDataSource: [[String: Any]] = [
        [
            "header": "生命周期, RunTime",
            "items":[
                [
                    "title": "ViewController的生命周期",
                    "subTitle": nil,
                    "destViewController": NSStringFromClass(LifeCycleTableViewController.self)
                ],
                [
                    "title": "运行时RunTime 的知识运用",
                    "subTitle": nil,
                    "destViewController": NSStringFromClass(RunTimeTableViewController.self)
                ],
                [
                    "title": "Protocol 的实现类",
                    "subTitle": nil,
                    "destViewController": NSStringFromClass(ProtocolTableViewController.self)
                ],
                [
                    "title": "Block 内存释放",
                    "subTitle": nil,
                    "destViewController": NSStringFromClass(BlockLoopTableViewController.self)
                ]
            ]
        ],
        [
            "header": "NSThread, GCD, NSOperation, Lock, RunLoop",
            "items": [
                [
                    "title": "NSThread 多线程",
                    "subTitle": nil,
                    "destViewController": NSStringFromClass(NSThreadTableViewController.self)
                ],
                [
                    "title": "GCD 多线程",
                    "subTitle": nil,
                    "destViewController": NSStringFromClass(GCDTableViewController.self)
                ],
                [
                    "title": "NSOperation 多线程",
                    "subTitle": nil,
                    "destViewController": NSStringFromClass(NSOperationTableViewController.self)
                ],
                [
                    "title": "同步锁知识",
                    "subTitle": nil,
                    "destViewController": NSStringFromClass(LockTableViewController.self)
                ],
                [
                    "title": "RunLoop",
                    "subTitle": nil,
                    "destViewController": NSStringFromClass(RunLoopTableViewController.self)
                ]
            ]
        ]
    ]
    
    // MARK: Public Member
    
    // MARK: Private Member
    
    // MARK: Public Method
    
    // MARK: Private Method
    private func setupItem() {
        for s in  sectionsDataSource{
            let section = BaseItemSection(withItems: [], andHeaderTitle: s["header"] as? String, footerTitle: s["footer"] as? String)
            if let items = s["items"] as? [[String: Any]] {
                for item in items {
                    let wordItem = BaseWordArrowItem(withTitle: item["title"] as? String, subTitle: item["subTitle"] as? String)
                    wordItem.destinationViewControllerClass = NSClassFromString(item["destViewController"] as? String ?? "")
                    section.items.append(wordItem)
                }
            }
            self.sections.append(section)
        }
    }
}

// MARK: - Life Cycle Method
extension EssenceTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
}

// MARK: - Table View Data Source And Delegate
extension EssenceTableViewController {
    
    
}

// MARK: - StoryBoard Method
extension EssenceTableViewController {
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

