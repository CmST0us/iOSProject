//
//  BaseWordItem.swift
//  iOSProject
//
//  Created by CmST0us on 2018/5/4.
//  Copyright © 2018年 eric3u. All rights reserved.
//

import UIKit


class BaseWordItem: NSObject {
    
    typealias BaseWorkItemOperation = ((_ indexPath: IndexPath) -> Void)
    
    /// 标题
    var title: String?
    /// 标题字体
    var titleFont: UIFont = adaptedFontSize(16)
    /// 标题字体颜色
    var titleColor: UIColor = UIColor.black
    
    /// 副标题
    var subTitle: String?
    /// 副标题字体
    var subTitleFont: UIFont = adaptedFontSize(16)
    /// 副标题字体颜色
    var subTitleColor: UIColor = UIColor.black
    
    /// 左边的图片
    var image: UIImage? = nil

    /// cell的高度
    var cellHeight: CGFloat = 80
    
    /// 是否需要自定义cell。如果自定盈，则 tableview 返回默认cell，自己自定义cell返回
//    var needCustom: Bool
    
    /// cell点击时的操作
    var operation: BaseWorkItemOperation? = nil
    
    init(withTitle title: String?, subTitle: String?, operation: BaseWorkItemOperation? = nil) {
        self.title      = title
        self.subTitle   = subTitle
        self.operation  = operation
        
        super.init()
    }
    
}
