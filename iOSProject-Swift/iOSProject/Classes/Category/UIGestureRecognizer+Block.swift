//
//  UIGestureRecognizer+Block.swift
//  iOSProject
//
//  Created by CmST0us on 2018/5/5.
//  Copyright © 2018年 eric3u. All rights reserved.
//

import Foundation
import UIKit

fileprivate struct UIGestureRecognizerRunTimeKey {
    static var actionKey = "actionKey"
}

extension UIGestureRecognizer {
    typealias ActionBlock = (() -> Void)
    
    func added(_ block: ActionBlock) -> UIGestureRecognizer {
        objc_setAssociatedObject(self, &UIGestureRecognizerRunTimeKey.actionKey, block, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        self.addTarget(self, action: #selector(blockAction))
        return self
    }
    
    @objc
    private func blockAction() {
        if let block = objc_getAssociatedObject(self, &UIGestureRecognizerRunTimeKey.actionKey) as? ActionBlock {
            block()
        }
    }
}
