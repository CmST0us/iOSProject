//
//  RunTimeTableViewController.swift
//  iOSProject
//
//  Created by CmST0us on 2018/5/4.
//  Copyright © 2018年 eric3u. All rights reserved.
//

import UIKit


/// 这里需要注意的是objc_getAssociatedObject()中的key是靠内存地址来做key的所以一定要static
struct RunTimeAssociatedKey {
    static var UIButtonBlockKey = "UIButtonBlockKey"
    static var workKey = "workKey"
}


class RunTimeTableViewController: BaseStaticTableViewController {
    
    // MARK: Public Member
    
    // MARK: Private Member
    var myButton: UIButton!
    // MARK: Public Method
    deinit {
        Logger.shared.console("deinit")
    }
    
    // MARK: Private Member
    private func dynamicAddMethod() {
        Logger.shared.console("动态加载的方法")
    }
    
    private func setupHeaderButton() {
        myButton = UIButton()
        myButton.backgroundColor = UIColor.blue
        myButton.frame.size.height = 50
        self.myButton.setTitle("方法替换或交换(UIButton+BaseBlock)", for: .normal)
        self.tableView.tableHeaderView = myButton
        
        // 使用了objc_getAssociatedObject()
        // objc_setAssociatedObject() 存取block
        self.myButton.addActionHandler { (tag) in
            self.showInfoAlert(withTitle: "提示", message: "按钮添加了actionBlock", cancelMessage: "查看UIButton+BaseBlock查看详细")
        }
        
    }
    
    private func setupItem() {
        let _ = self
            .addItem(BaseWordItem(withTitle: "获取类信息", subTitle: "关键字class_get", operation: { [weak self] (indexPath) in
                
                // 类名
                let className = "类名\(String(cString: class_getName(RunTimeTest.self)))"
                // 父类名
                let superClassName = "父类是\(String(cString: class_getName(class_getSuperclass(RunTimeTest.self))))"
                // 是否元类
                let isMetaClass = class_isMetaClass(RunTimeTest.self) ? "是元类" : "不是元类"
                // 元类类名
                let metaClass: AnyClass = objc_getMetaClass(class_getName(RunTimeTest.self)) as! AnyClass
                let metaClassName = "元类是：\(String(cString: class_getName(metaClass)))"
                // 变量实例大小
                let instanceSize = "变量实例大小：\(String(class_getInstanceSize(RunTimeTest.self)))"
                self?.showInfoAlert(withTitle: "获取类信息", message: "\(className)\n\(superClassName)\n\(isMetaClass)\n\(metaClassName)\n\(instanceSize)", cancelMessage: "明白")
                
            }))
            .addItem(BaseWordItem(withTitle: "获取类的对应属性", subTitle: "class_copyPropertyList", operation: { [weak self] (indexPath) in
                
                var propertyListCount: UInt32 = 0
                var propertyListString = ""
                if let propertyListRaw = class_copyPropertyList(RunTimeTest.self, &propertyListCount) {
                    for i in 0 ..< Int(propertyListCount) {
                        let propertyNameRaw = property_getName(propertyListRaw[i])
                        propertyListString += "属性名称为：\(String(cString: propertyNameRaw))\n"
                        let propertyAttribute = property_getAttributes(propertyListRaw[i])!
                        propertyListString += "属性类型修饰符为：\(String(cString: propertyAttribute))\n"
                    }
                    free(propertyListRaw)
                }
                
                if let property = class_getProperty(RunTimeTest.self, "name") {
                    let string = String(cString: property_getName(property))
                    propertyListString += "存在属性\(string)\n"
                }
                
                self?.showInfoAlert(withTitle: "获取类的对应属性", message: propertyListString)
                
            }))
            .addItem(BaseWordItem(withTitle: "获取类成员变量", subTitle: "class_copyIvarList", operation: { [weak self] (indexPath) in
                var ivarString = ""
                var ivarCount = UInt32(0)
                
                if let ivarList = class_copyIvarList(RunTimeTest.self, &ivarCount) {
                    for i in 0 ..< Int(ivarCount) {
                        let ivar = ivarList[i]
                        let ivarName = ivar_getName(ivar)!
                        ivarString += "成员变量：\(String(cString: ivarName))\n"
                    }
                    free(ivarList)
                }
                
                self?.showInfoAlert(withTitle: "获取类的成员变量", message: ivarString)
            }))
            .addItem(BaseWordItem(withTitle: "动态修改变量", subTitle: "objcet_setIvar", operation: { [weak self] (indexPath) in
                var messageString = ""
                let runTimeTest = RunTimeTest()
                runTimeTest._count = NSNumber(value: 10)
                messageString += "修改前变量是\(String(describing: runTimeTest._count.stringValue))\n"
                
                var ivarCount = UInt32(0)
                if let ivarList = class_copyIvarList(RunTimeTest.self, &ivarCount) {
                    for i in 0 ..< Int(ivarCount) {
                        let ivar = ivarList[i]
                        let ivarName = String(cString: ivar_getName(ivar)!)
                        // 注意加不加下划线。具体可以参考上面获取到的ivar来决定。
                        
                        // 这里注意只能设置NSObject对象，否则会由于内存引用计数问题导致数据出错
                        // 暂时只知道setIvar只能传入AnyObject
                        // 另外，有参考到一份有用的资料http://swifter.tips/any-anyobject/
                        
                        if ivarName == "_count" {
                            object_setIvar(runTimeTest, ivar, NSNumber(value: 20))
                        }
                    }
                    free(ivarList)
                }
                
                messageString += "修改后的变量是\(String(describing: runTimeTest._count.stringValue))"
                
                self?.showInfoAlert(withTitle: "动态修改变量", message: messageString)
            }))
            .addItem(BaseWordItem(withTitle: "获取方法", subTitle: "class_copyMethodList", operation: { [weak self] (indexPath) in
                
                /// 获取实例方法
                var messageSting = ""
                var methodCount = UInt32(0)
                if let methodList = class_copyMethodList(RunTimeTest.self, &methodCount) {
                    for i in 0 ..< Int(methodCount) {
                        let method = methodList[i]
                        let methodName = NSStringFromSelector(method_getName(method))
                        messageSting += "实例方法： \(methodName)\n"
                    }
                    free(methodList)
                }
                
                /// 获取类方法
                if let classMethodList = class_copyMethodList(object_getClass(RunTimeTest.self), &methodCount) {
                    for i in 0 ..< Int(methodCount) {
                        let classMethod = classMethodList[i]
                        let classMethodName = NSStringFromSelector(method_getName(classMethod))
                        messageSting += "类方法：\(classMethodName)\n"
                    }
                    free(classMethodList)
                }
                
                /// 判断类方法是否存在
                if let classMethod = class_getClassMethod(RunTimeTest.self, NSSelectorFromString("show")) {
                    messageSting += "类方法\(NSStringFromSelector(method_getName(classMethod)))存在\\n"
                } else {
                    messageSting += "类方法不存在\n"
                }
                
                self?.showInfoAlert(withTitle: "动态获取方法", message: messageSting)
            }))
            .addItem(BaseWordItem(withTitle: "获取类的协议列表", subTitle: "class_copyProtocolList", operation: { [weak self] (indexPath) in
                var messageString = ""
                var protocolCount = UInt32(0)
                
                /// 注意只有协议继承了NSObjectProtocol才能使用Runtime
                if let protocolList = class_copyProtocolList(RunTimeTest.self, &protocolCount) {
                    for i in 0 ..< Int(protocolCount) {
                        let protocolName = String(cString: protocol_getName(protocolList[i]))
                        messageString += "协议名称: \(protocolName)\n"
                    }
                }
                self?.showInfoAlert(withTitle: "类的协议", message: messageString)
            }))
            .addItem(BaseWordItem(withTitle: "分类动态增加属性", subTitle: "objc_setAssociatedObject", operation: { [weak self] (indexPath) in
                let test = RunTimeTest()
                test.workName = "已动态增加"
                
                self?.showInfoAlert(withTitle: "动态增加分类属性", message: "workName: \(test.workName)", cancelMessage: "查看RunTimeTest以查看详细")
            }))
            .addItem(BaseWordItem(withTitle: "动态交换两个方法的实现", subTitle: "method_exchangeImplementations", operation: { [weak self] (indexPath) in
                var messageString = ""
                
                
                /// 动态交换的方法必须在方法前加dynamic 不然的话Swift会做静态优化将方法变为静态调用
                let method1 = class_getInstanceMethod(RunTimeTest.self, NSSelectorFromString("showUserName:"))!
                let method2 = class_getInstanceMethod(RunTimeTest.self, NSSelectorFromString("showUserAge:"))!

                method_exchangeImplementations(method1, method2)
                
                let myRunTimeTest = RunTimeTest()
                messageString += myRunTimeTest.showUserName("asdf")
                messageString += myRunTimeTest.showUserAge("1234")

                self?.showInfoAlert(withTitle: "交换方法", message: messageString)
            }))
        
    }
    
    private func setupDescription() {
        let descriptionString =
"""
***************************************************
// 获取类的类名
const char * class_getName ( Class cls );

// 获取类的父类
Class class_getSuperclass ( Class cls );

// 判断给定的Class是否是一个元类
BOOL class_isMetaClass ( Class cls );

// 获取实例大小
size_t class_getInstanceSize ( Class cls );

// 获取类中指定名称实例成员变量的信息
Ivar class_getInstanceVariable ( Class cls, const char *name );

// 获取类成员变量的信息
Ivar class_getClassVariable ( Class cls, const char *name );

// 添加成员变量
BOOL class_addIvar ( Class cls, const char *name, size_t size, uint8_t alignment, const char *types );

// 获取整个成员变量列表
Ivar * class_copyIvarList ( Class cls, unsigned int *outCount );

// 获取指定的属性
objc_property_t class_getProperty ( Class cls, const char *name );

// 获取属性列表
objc_property_t * class_copyPropertyList ( Class cls, unsigned int *outCount );

// 为类添加属性
BOOL class_addProperty ( Class cls, const char *name, const objc_property_attribute_t *attributes, unsigned int attributeCount );

// 替换类的属性
void class_replaceProperty ( Class cls, const char *name, const objc_property_attribute_t *attributes, unsigned int attributeCount );

// 添加方法
BOOL class_addMethod ( Class cls, SEL name, IMP imp, const char *types );

// 获取实例方法
Method class_getInstanceMethod ( Class cls, SEL name );

// 获取类方法
Method class_getClassMethod ( Class cls, SEL name );

// 获取所有方法的数组
Method * class_copyMethodList ( Class cls, unsigned int *outCount );

// 替代方法的实现
IMP class_replaceMethod ( Class cls, SEL name, IMP imp, const char *types );

// 返回方法的具体实现
IMP class_getMethodImplementation ( Class cls, SEL name );
IMP class_getMethodImplementation_stret ( Class cls, SEL name );

// 类实例是否响应指定的selector
BOOL class_respondsToSelector ( Class cls, SEL sel );

// 添加协议
BOOL class_addProtocol ( Class cls, Protocol *protocol );

// 返回类是否实现指定的协议
BOOL class_conformsToProtocol ( Class cls, Protocol *protocol );

// 返回类实现的协议列表
Protocol * class_copyProtocolList ( Class cls, unsigned int *outCount );

// 获取版本号
int class_getVersion ( Class cls );

// 设置版本号
void class_setVersion ( Class cls, int version );

***************************************************



***************************************************
 调用指定方法的实现
    id method_invoke ( id receiver, Method m, ... );

    // 调用返回一个数据结构的方法的实现
    void method_invoke_stret ( id receiver, Method m, ... );

    // 获取方法名
    SEL method_getName ( Method m );

    // 返回方法的实现
    IMP method_getImplementation ( Method m );

    // 获取描述方法参数和返回值类型的字符串
    const char * method_getTypeEncoding ( Method m );

    // 获取方法的返回值类型的字符串
    char * method_copyReturnType ( Method m );

    // 获取方法的指定位置参数的类型字符串
    char * method_copyArgumentType ( Method m, unsigned int index );

    // 通过引用返回方法的返回值类型字符串
    void method_getReturnType ( Method m, char *dst, size_t dst_len );

    // 返回方法的参数的个数
    unsigned int method_getNumberOfArguments ( Method m );

    // 通过引用返回方法指定位置参数的类型字符串
    void method_getArgumentType ( Method m, unsigned int index, char *dst, size_t dst_len );

    // 返回指定方法的方法描述结构体
    struct objc_method_description * method_getDescription ( Method m );

    // 设置方法的实现
    IMP method_setImplementation ( Method m, IMP imp );

    // 交换两个方法的实现
    void method_exchangeImplementations ( Method m1, Method m2 );

***************************************************



***************************************************
方法选择器 SEL
// 返回给定选择器指定的方法的名称
const char * sel_getName ( SEL sel );

// 在Objective-C Runtime系统中注册一个方法，将方法名映射到一个选择器，并返回这个选择器
SEL sel_registerName ( const char *str );

// 在Objective-C Runtime系统中注册一个方法
SEL sel_getUid ( const char *str );

// 比较两个选择器
BOOL sel_isEqual ( SEL lhs, SEL rhs );

***************************************************

"""
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = UIColor.black
        label.text = descriptionString
        label.frame.size.width = kScreenWidth
        label.sizeToFit()
        self.tableView.tableFooterView = label
    }
}

// MARK: - Life Cycle Method
extension RunTimeTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupHeaderButton()
        self.setupDescription()
        self.setupItem()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

// MARK: - Table View Data Source And Delegate
extension RunTimeTableViewController {
    
    
}

// MARK: - StoryBoard Method
extension RunTimeTableViewController {
    
}

