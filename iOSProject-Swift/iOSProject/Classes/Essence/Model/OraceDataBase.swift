//
//  OraceDataBase.swift
//  iOSProject
//
//  Created by CmST0us on 2018/5/5.
//  Copyright © 2018年 eric3u. All rights reserved.
//

import Foundation

class OraceDataBase: NSObject {
    
}

extension OraceDataBase: DataBaseConnectionProtocol {
    func start() {
        Logger.shared.output("start link")
    }
    func end() {
        Logger.shared.output("end link")
        
    }
    func suspend() {
         Logger.shared.output("suspend")
    }
}
