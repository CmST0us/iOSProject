//
//  UIButton+BaseBlock.swift
//  iOSProject
//
//  Created by CmST0us on 2018/5/4.
//  Copyright © 2018年 eric3u. All rights reserved.
//

import Foundation
import UIKit

typealias UIButtonTouchBlock = ((_ tag: Int) -> Void)

extension UIButton {
    
    func addActionHandler(_ handler: UIButtonTouchBlock) {
        objc_setAssociatedObject(self, &RunTimeAssociatedKey.UIButtonBlockKey, handler, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        self.addTarget(self, action: #selector(actionTouched(_:)), for: .touchUpInside)
    }
    
    @objc
    private func actionTouched(_ button: UIButton) {
        if let block = objc_getAssociatedObject(self, &RunTimeAssociatedKey.UIButtonBlockKey) as? UIButtonTouchBlock {
            block(tag)
        }
    }
}
