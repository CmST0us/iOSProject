//
//  DataBaseConnectionProtocol.swift
//  iOSProject
//
//  Created by CmST0us on 2018/5/5.
//  Copyright © 2018年 eric3u. All rights reserved.
//

import Foundation


/// NSObjectProtocol表明继承此协议只能有NSObject的子类实现
/// @objc表明协议支持runtime获取相关方法，支持optional
@objc
protocol DataBaseConnectionProtocol: NSObjectProtocol {
    func start()
    func end()
    
    @objc optional func suspend()
}
