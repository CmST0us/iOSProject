//
//  RunTimeTest.swift
//  iOSProject
//
//  Created by CmST0us on 2018/5/4.
//  Copyright © 2018年 eric3u. All rights reserved.
//

import UIKit



/// RunTimeTableViewController 使用的测试类
/// 注意在Swift中只有为变量加上@objc才能使用class_copyPropertyList()获取到属性列表
/// 对于协议，加上@objc才能被class_copyProtocolList()找到

@objc
protocol RunTimeTestProtocol {
    func foo()
}


class RunTimeTest: NSObject, RunTimeTestProtocol {
    
    @objc
    var schoolName: String = ""
    
    @objc
    var name: String = ""

    @objc
    var age: NSNumber = NSNumber(value: 0)
    
    
    var _schoolName: String = ""
    
    var _userHeight: CGFloat = 0
    
    var _count: NSNumber!
    
    @objc
    func showUserName(_ userName: String) {
        print("用户名是：\(userName)")
    }
    
    @objc
    static func show() {
        print("static show method")
    }
    
    func foo() {
        print("foo")
    }
    
}

extension RunTimeTest {
    
    var workName: String {
        get {
            return (objc_getAssociatedObject(self, &RunTimeAssociatedKey.workKey) as? String) ?? ""
        }
        
        set {
            objc_setAssociatedObject(self, &RunTimeAssociatedKey.workKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
}
