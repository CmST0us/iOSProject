//
//  CoreAnimationTableViewController.swift
//  iOSProject
//
//  Created by CmST0us on 2018/5/7.
//  Copyright © 2018年 eric3u. All rights reserved.
//

import UIKit

class CoreAnimationTableViewController: BaseStaticTableViewController {
    
    // MARK: Public Member
    
    // MARK: Private Member
    let sectionsDataSource: [[String: Any]] = [
        [
            "header": "核心动画",
            "items": [
                [
                    "title": "CALayer基本使用",
                    "subTitle": nil,
                    "destViewController": NSStringFromClass(CALayerBaseUseViewController.self)
                ],
                [
                    "title": "CALayer隐式图层",
                    "subTitle": nil,
                    "destViewController": NSStringFromClass(CALayerCreateNewLayerViewController.self)
                ],
                [
                    "title": "时钟",
                    "subTitle": nil,
                    "destViewController": NSStringFromClass(ClockViewController.self)
                ],
            ]
        ]
    ]
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
extension CoreAnimationTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

// MARK: - Table View Data Source And Delegate
extension CoreAnimationTableViewController {
    

}

// MARK: - StoryBoard Method
extension CoreAnimationTableViewController {
    

    
}

