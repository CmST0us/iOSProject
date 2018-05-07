//
//  BlockLoopOperation.swift
//  iOSProject
//
//  Created by CmST0us on 2018/5/5.
//  Copyright © 2018年 eric3u. All rights reserved.
//

import UIKit

class BlockLoopOperation: NSObject {
    
    typealias SuccessBlock = (()-> Void)
    
    var address: String!
    
    var logAddress: ((_ address: String) -> Void)!
    
    static func operate(_ block: SuccessBlock) {
        block()
    }
    
    deinit {
        Logger.shared.console("deinit")
    }
}
