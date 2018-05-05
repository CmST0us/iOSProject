//
//  DataBaseConnectionProtocol.swift
//  iOSProject
//
//  Created by CmST0us on 2018/5/5.
//  Copyright © 2018年 eric3u. All rights reserved.
//

import Foundation

@objc
protocol DataBaseConnectionProtocol: NSObjectProtocol {
    func start()
    func end()
    
    @objc optional func suspend()
}
