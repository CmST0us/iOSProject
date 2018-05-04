//
//  BaseItemSection.swift
//  iOSProject
//
//  Created by CmST0us on 2018/5/4.
//  Copyright © 2018年 eric3u. All rights reserved.
//

import UIKit

class BaseItemSection: NSObject {
    
    /// Section 头部文本
    var headerTitle: String?
    
    
    /// Section 尾部文本
    var footerTitle: String?
    
    
    /// Section 中的item
    var items: [BaseWordItem]
    
    init(withItems items: [BaseWordItem], andHeaderTitle headerTitle: String?, footerTitle: String?) {
        self.items = items
        self.headerTitle = headerTitle
        self.footerTitle = footerTitle
        
        super.init()
    }
}
