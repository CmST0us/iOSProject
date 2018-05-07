//
//  ExitAbleThreadPort.swift
//  iOSProject
//
//  Created by CmST0us on 2018/5/7.
//  Copyright © 2018年 eric3u. All rights reserved.
//

import UIKit

class ExitAbleThreadPort: NSMachPort {
    
}

// MARK: - Port Delegate
extension ExitAbleThreadPort: NSMachPortDelegate {
    
    func handleMachMessage(_ msg: UnsafeMutableRawPointer) {
        Logger.shared.console("recv: msg \(msg.debugDescription)")
    }
    
}
