//
//  UserProtocol.swift
//  iOSProject
//
//  Created by CmST0us on 2018/5/5.
//  Copyright © 2018年 eric3u. All rights reserved.
//

import Foundation

struct DataBaseConnectionIdentifier {
    init(rawValue: String) {
        identifier = rawValue
    }
    var identifier: String
}

class UserProtocol: NSObject {
    func connect(_ dataBase: DataBaseConnectionProtocol, withIdentifier: DataBaseConnectionIdentifier) {
        Logger.shared.output("start connect")
        dataBase.start()
        if dataBase.responds(to: #selector(dataBase.suspend)) {
            dataBase.suspend!()
        }
        dataBase.end()
        Logger.shared.output("end connect")
    }
}
