//
//  BaseClosureWrapper.swift
//  iOSProject
//
//  Created by CmST0us on 2018/5/5.
//  Copyright © 2018年 eric3u. All rights reserved.
//

import Foundation

class BaseClosureWrapper<ClosureType> {
    var closure: ClosureType!
    init(withClosure closure: ClosureType) {
        self.closure = closure
    }
}
