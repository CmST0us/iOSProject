//
//  NSOperationTableViewController.swift
//  iOSProject
//
//  Created by CmST0us on 2018/5/4.
//  Copyright © 2018年 eric3u. All rights reserved.
//

import UIKit

fileprivate let descriptionLabelText = """
理论知识：
NSOperation是苹果提供给我们的一套多线程解决方案。实际上NSOperation是基于GCD更高一层的封装，但是比GCD更简单易用、代码可读性也更高。
NSOperation需要配合NSOperationQueue来实现多线程。因为默认情况下，NSOperation单独使用时系统同步执行操作，并没有开辟新线程的能力，只有配合NSOperationQueue才能实现异步执行

------------------------------------------------------------------------------------------
步骤3
创建任务：先将需要执行的操作封装到一个NSOperation对象中。
创建队列：创建NSOperationQueue对象。
将任务加入到队列中：然后将NSOperation对象添加到NSOperationQueue中。

------------------------------------------------------------------------------------------
创建队列
NSOperationQueue一共有两种队列：主队列、其他队列
主队列 NSOperationQueue *queue = [NSOperationQueue mainQueue]; 凡是添加到主队列中的任务（NSOperation），都会放到主线程中执行
其他队列（非主队列） NSOperationQueue *queue = [[NSOperationQueue alloc] init]; 就会自动放到子线程中执行 同时包含了：串行、并发功能
------------------------------------------------------------------------------------------
NSOperation是个抽象类，并不能封装任务。我们只有使用它的子类来封装任务。我们有三种方式来封装任务。
使用子类NSInvocationOperation
使用子类NSBlockOperation
定义继承自NSOperation的子类，通过实现内部相应的方法来封装任务

------------------------------------------------------------------------------------------
其它知识点
- (void)cancel; NSOperation提供的方法，可取消单个操作
- (void)cancelAllOperations; NSOperationQueue提供的方法，可以取消队列的所有操作
- (void)setSuspended:(BOOL)b; 可设置任务的暂停和恢复，YES代表暂停队列，NO代表恢复队列
- (BOOL)isSuspended; 判断暂停状态

"""
class NSOperationTableViewController: BaseStaticTableViewController {
    
    // MARK: Public Member
    
    // MARK: Private Member
    
    // MARK: Public Method
    deinit {
        Logger.shared.console("deinit")
    }
    // MARK: Private Member
    private func setupDescription() {
        let label = UILabel()
        label.frame.size.width = kScreenWidth
        label.numberOfLines = 0
        label.text = descriptionLabelText
        self.tableView.tableFooterView = label
        label.sizeToFit()
    }
}

// MARK: - Life Cycle Method
extension NSOperationTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupDescription()
        
        let _ = self
            .addItem(BaseWordItem(withTitle: "使用子类NSBlockOperation", subTitle: " 主线程和子线程执行", operation: { (indexPath) in
                /// 在Swift中使用BlockOperation来创建一个Operation
                let op = BlockOperation(block: {
                    //在主线程
                    print("1--当前执行线程----\(Thread.current.description)")
                })
                
                //在新开的线程
                op.addExecutionBlock {
                    print("2--当前执行线程----\(Thread.current.description)")
                }
                
                op.addExecutionBlock {
                    print("3--当前执行线程----\(Thread.current.description)")
                }
                
                op.addExecutionBlock {
                    print("4--当前执行线程----\(Thread.current.description)")
                }
                
                /// 使用start来执行
                op.start()
            }))
            .addItem(BaseWordItem(withTitle: "NSBlockOperation", subTitle: "子执行 加入非主线程", operation: { (indexPath) in
                let operationQueue = OperationQueue.init()
                
                let op = BlockOperation(block: {
                    //在子线程
                    print("1--当前执行线程----\(Thread.current.description)")
                })
                //在新开的子线程
                op.addExecutionBlock {
                    print("2--当前执行线程----\(Thread.current.description)")
                }
                
                op.addExecutionBlock {
                    print("3--当前执行线程----\(Thread.current.description)")
                }
                
                op.addExecutionBlock {
                    print("4--当前执行线程----\(Thread.current.description)")
                }
                
                // 使用queue的时候，使用addOperation就可以执行
                // 会新开一个线程
                operationQueue.addOperation(op)
            }))
            .addItem(BaseWordItem(withTitle: "maxConcurrentOperationCount设置", subTitle: "并发或串行", operation: { (indexPath) in
                let operationQueue = OperationQueue()
                
                //说明：
                //    maxConcurrentOperationCount默认情况下为-1，表示不进行限制，默认为并发执行。
                //    当maxConcurrentOperationCount为1时，进行串行执行。
                //    当maxConcurrentOperationCount大于1时，进行并发执行，当然这个值不应超过系统限制，即使自己设置一个很大的值，系统也会自动调整
                
                operationQueue.maxConcurrentOperationCount = 1
                
                let op = BlockOperation(block: {
                    print("当前执行线程----\(Thread.current.description)")
                })
                
                for i in 0 ..< 20 {
                    op.addExecutionBlock {
                        print("\(String(i))--当前执行线程----\(Thread.current.description)")
                    }
                }
                
                operationQueue.addOperation(op)
                
            }))
            .addItem(BaseWordItem(withTitle: "操作依赖", subTitle: nil, operation: { (indexPath) in
                let queue = OperationQueue()
                
                let op0 = BlockOperation(block: {
                    print("op0----当前线程----\(Thread.current.description)")
                })
                let op1 = BlockOperation(block: {
                    print("op1----当前线程----\(Thread.current.description)")
                })
                let op2 = BlockOperation(block: {
                    print("op2----当前线程----\(Thread.current.description)")
                })
                
                op0.addDependency(op1)
                op0.addDependency(op2)
                
                queue.addOperation(op0)
                queue.addOperation(op1)
                queue.addOperation(op2)
                
            }))
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

// MARK: - Table View Data Source And Delegate
extension NSOperationTableViewController {
    
    
}

// MARK: - StoryBoard Method
extension NSOperationTableViewController {
    

}

