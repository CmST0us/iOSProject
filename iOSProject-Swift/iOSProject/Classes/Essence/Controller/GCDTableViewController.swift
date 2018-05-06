//
//  GCDTableViewController.swift
//  iOSProject
//
//  Created by CmST0us on 2018/5/4.
//  Copyright © 2018年 eric3u. All rights reserved.
//


import UIKit

fileprivate let gcdQueueDescription =
"""
+------+--------------+---------------+-------------+
|      |  全局并行队列  | 手动创建串行队列 |     主队列    |
+------+--------------+---------------+-------------+
|  sync| 没有开启新线程  | 没有开启新线程   |     死锁    |
|      |  串行执行任务  |   串行执行任务   |             |
+------+--------------+---------------+--------------+
| async| 有开启新线程   |  有开启新线程   | 没有有开启新线程 |
|      | 并行执行任务   |  串行执行任务   | 串行执行任务    |
+------+--------------+---------------+--------------+
"""

class GCDTableViewController: BaseStaticTableViewController {
    
    // MARK: Public Member
    
    // MARK: Private Member
    
    // MARK: Public Method
    
    // MARK: Private Member
    var timer: DispatchSource!
}

// MARK: - Life Cycle Method
extension GCDTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sections = [BaseItemSection(withItems: [], andHeaderTitle: "六种类型", footerTitle: nil)]
        let _ = self
            .addItem(BaseWordItem(withTitle: "并发队列 + 同步执行", subTitle: nil, operation: { (indexPath) in
                print("并发队列 + 同步执行----开始")
                
                let queue = DispatchQueue(label: "queue1", attributes: DispatchQueue.Attributes.concurrent)
                
                queue.sync {
                    for _ in 0 ..< 2 {
                        print("1--------\(Thread.current.description)")
                    }
                }
                print("Block 1----返回")
                queue.sync {
                    for _ in 0 ..< 2 {
                        print("2--------\(Thread.current.description)")
                    }
                }
                print("Block 2----返回")
                queue.sync {
                    for _ in 0 ..< 2 {
                        print("3--------\(Thread.current.description)")
                    }
                }
                print("Block 3----返回")
                print("并发队列 + 同步执行----结束")
                
                print("由于是并发队列，可以并发处理任务，下面开始测试----开始")
                DispatchQueue.global().async {
                    queue.sync {
                        for _ in 0 ..< 2 {
                            print("4--------\(Thread.current.description)")
                        }
                    }
                }
                print("由于是并发队列，可以并发处理任务，下面开始测试----Block4异步提交")
                DispatchQueue.global().async {
                    queue.sync {
                        for _ in 0 ..< 2 {
                            print("5--------\(Thread.current.description)")
                        }
                    }
                }
                print("由于是并发队列，可以并发处理任务，下面开始测试----Block5异步提交")
                
                /**
                 输出内容:
                 
                 并发队列 + 同步执行----开始
                 1--------<NSThread: 0x60400006e180>{number = 1, name = main}
                 1--------<NSThread: 0x60400006e180>{number = 1, name = main}
                 Block 1----返回
                 2--------<NSThread: 0x60400006e180>{number = 1, name = main}
                 2--------<NSThread: 0x60400006e180>{number = 1, name = main}
                 Block 2----返回
                 3--------<NSThread: 0x60400006e180>{number = 1, name = main}
                 3--------<NSThread: 0x60400006e180>{number = 1, name = main}
                 Block 3----返回
                 并发队列 + 同步执行----结束
                 由于是并发队列，可以并发处理任务，下面开始测试----开始
                 由于是并发队列，可以并发处理任务，下面开始测试----Block4异步提交
                 4--------<NSThread: 0x600000674c80>{number = 4, name = (null)}
                 由于是并发队列，可以并发处理任务，下面开始测试----Block5异步提交
                 5--------<NSThread: 0x60400066ac40>{number = 5, name = (null)}
                 4--------<NSThread: 0x600000674c80>{number = 4, name = (null)}
                 5--------<NSThread: 0x60400066ac40>{number = 5, name = (null)}
 
                 说明：
                 从线程名可以看到，所有任务都是在主线程执行的，并且每一个任务被提交后立即执行。执行完成后返回。
                 我们可以得出结论Dispatch.sync是将任务放到当前线程队列中执行的，这点也可以从4，5号任务的线程名中看出
                 使用sync时不会开启新的线程
                 */
            }))
            .addItem(BaseWordItem(withTitle: "并发队列 + 异步执行", subTitle: nil, operation: { (indexPath) in
                print("并发队列 + 异步执行----开始")
                
                let queue = DispatchQueue(label: "queue2", attributes: DispatchQueue.Attributes.concurrent)
                
                queue.async {
                    for _ in 0 ..< 2 {
                        print("1--------\(Thread.current.description)")
                    }
                }
                print("Block 1----返回")
                queue.async {
                    for _ in 0 ..< 2 {
                        print("2--------\(Thread.current.description)")
                    }
                }
                print("Block 2----返回")
                queue.async {
                    for _ in 0 ..< 2 {
                        print("3--------\(Thread.current.description)")
                    }
                }
                print("Block 3----返回")
                print("并发队列 + 异步执行----结束")
                
                /**
                 输出内容：
                 
                 并发队列 + 异步执行----开始
                 Block 1----返回
                 Block 2----返回
                 Block 3----返回
                 并发队列 + 异步执行----结束
                 1--------<NSThread: 0x6000008713c0>{number = 4, name = (null)}
                 2--------<NSThread: 0x60000087bc40>{number = 5, name = (null)}
                 3--------<NSThread: 0x6040002776c0>{number = 3, name = (null)}
                 1--------<NSThread: 0x6000008713c0>{number = 4, name = (null)}
                 2--------<NSThread: 0x60000087bc40>{number = 5, name = (null)}
                 3--------<NSThread: 0x6040002776c0>{number = 3, name = (null)}
 
                 说明：
                 在并发队列+异步执行中，除了主线程，又开启了新的线程，并且新线程交替运行
                 所有任务都是不是马上执行的，而是将任务添加到队列后才开始异步执行的
                 由于是并发队列，为每个任务都开启了新线程
                 */
                
            }))
            .addItem(BaseWordItem(withTitle: "串行队列 + 同步执行", subTitle: nil, operation: { (indexPath) in
                print("串行队列 + 同步执行----开始")
                
                let queue = DispatchQueue(label: "queue3")
                
                queue.sync {
                    for _ in 0 ..< 2 {
                        print("1--------\(Thread.current.description)")
                    }
                }
                print("Block 1----返回")
                queue.sync {
                    for _ in 0 ..< 2 {
                        print("2--------\(Thread.current.description)")
                    }
                }
                print("Block 2----返回")
                queue.sync {
                    for _ in 0 ..< 2 {
                        print("3--------\(Thread.current.description)")
                    }
                }
                print("Block 3----返回")
                print("串行队列 + 同步执行----结束")
                
                print("由于是串行队列，不能并发处理任务，下面开始测试----开始")
                DispatchQueue.global().async {
                    queue.async {
                        for _ in 0 ..< 2 {
                            print("4--------\(Thread.current.description)")
                        }
                    }
                }
                print("由于是串行队列，不能并发处理任务，下面开始测试----Block4异步提交")
                DispatchQueue.global().async {
                    queue.async {
                        for _ in 0 ..< 2 {
                            print("5--------\(Thread.current.description)")
                        }
                    }
                }
                print("由于是串行队列，不能并发处理任务，下面开始测试----Block5异步提交")
                
                /**
                 输出内容：
                 
                 串行队列 + 同步执行----开始
                 1--------<NSThread: 0x604000063440>{number = 1, name = main}
                 1--------<NSThread: 0x604000063440>{number = 1, name = main}
                 Block 1----返回
                 2--------<NSThread: 0x604000063440>{number = 1, name = main}
                 2--------<NSThread: 0x604000063440>{number = 1, name = main}
                 Block 2----返回
                 3--------<NSThread: 0x604000063440>{number = 1, name = main}
                 3--------<NSThread: 0x604000063440>{number = 1, name = main}
                 Block 3----返回
                 串行队列 + 同步执行----结束
                 由于是串行队列，不能并发处理任务，下面开始测试----开始
                 由于是串行队列，不能并发处理任务，下面开始测试----Block4异步提交
                 4--------<NSThread: 0x60000026e0c0>{number = 11, name = (null)}
                 由于是串行队列，不能并发处理任务，下面开始测试----Block5异步提交
                 4--------<NSThread: 0x60000026e0c0>{number = 11, name = (null)}
                 5--------<NSThread: 0x60000026e0c0>{number = 11, name = (null)}
                 5--------<NSThread: 0x60000026e0c0>{number = 11, name = (null)}
 
                 
                 说明：
                 所有任务都是在主线程中运行的，没有开启新的线程。并且由于是串行队列任务一个一个执行
                 所有任务添加到队列中马上执行
                 
                 */
            }))
            .addItem(BaseWordItem(withTitle: "串行队列 + 异步执行", subTitle: nil, operation: { (indexPath) in
                print("串行队列 + 异步执行----开始")
                
                let queue = DispatchQueue(label: "queue4")
                
                queue.async {
                    for _ in 0 ..< 2 {
                        print("1--------\(Thread.current.description)")
                    }
                }
                print("Block 1----返回")
                queue.async {
                    for _ in 0 ..< 2 {
                        print("2--------\(Thread.current.description)")
                    }
                }
                print("Block 2----返回")
                queue.async {
                    for _ in 0 ..< 2 {
                        print("3--------\(Thread.current.description)")
                    }
                }
                print("Block 3----返回")
                print("串行队列 + 异步执行----结束")
                
                /**
                 输出内容：
                 
                 串行队列 + 异步执行----开始
                 Block 1----返回
                 Block 2----返回
                 1--------<NSThread: 0x600000670f80>{number = 12, name = (null)}
                 Block 3----返回
                 1--------<NSThread: 0x600000670f80>{number = 12, name = (null)}
                 串行队列 + 异步执行----结束
                 2--------<NSThread: 0x600000670f80>{number = 12, name = (null)}
                 2--------<NSThread: 0x600000670f80>{number = 12, name = (null)}
                 3--------<NSThread: 0x600000670f80>{number = 12, name = (null)}
                 3--------<NSThread: 0x600000670f80>{number = 12, name = (null)}

                 
                 说明：
                 打开了新线程，由于是串行队列，任务也一个一个执行
                 任务被提交到队列之后才开始同步执行
                 
                 */
            }))
            .addItem(BaseWordItem(withTitle: "主队列 + 同步执行--相互等待", subTitle: "直接Crash", operation: { (indexPath) in
                
                print("主队列 + 同步执行----开始")
                
                let queue = DispatchQueue.main
                
                queue.sync {
                    for _ in 0 ..< 2 {
                        print("1--------\(Thread.current.description)")
                    }
                }
                print("Block 1----返回")
                queue.sync {
                    for _ in 0 ..< 2 {
                        print("2--------\(Thread.current.description)")
                    }
                }
                print("Block 2----返回")
                queue.sync {
                    for _ in 0 ..< 2 {
                        print("3--------\(Thread.current.description)")
                    }
                }
                print("Block 3----返回")
                print("主队列 + 同步执行----结束")
                
                /**
                 输出内容：
                 直接Crash
                 
                 说明：
                 会死锁
 
                 */
            }))
            .addItem(BaseWordItem(withTitle: "主队列 + 异步执行", subTitle: nil, operation: { (indexPath) in
                print("主队列 + 异步执行----开始")
                
                let queue = DispatchQueue.main
                
                queue.async {
                    for _ in 0 ..< 2 {
                        print("1--------\(Thread.current.description)")
                    }
                }
                print("Block 1----返回")
                queue.async {
                    for _ in 0 ..< 2 {
                        print("2--------\(Thread.current.description)")
                    }
                }
                print("Block 2----返回")
                queue.async {
                    for _ in 0 ..< 2 {
                        print("3--------\(Thread.current.description)")
                    }
                }
                print("Block 3----返回")
                print("主队列 + 异步执行----结束")
                
                /**
                 输出：
                 主队列 + 异步执行----开始
                 Block 1----返回
                 Block 2----返回
                 Block 3----返回
                 主队列 + 异步执行----结束
                 1--------<NSThread: 0x60400006be40>{number = 1, name = main}
                 1--------<NSThread: 0x60400006be40>{number = 1, name = main}
                 2--------<NSThread: 0x60400006be40>{number = 1, name = main}
                 2--------<NSThread: 0x60400006be40>{number = 1, name = main}
                 3--------<NSThread: 0x60400006be40>{number = 1, name = main}
                 3--------<NSThread: 0x60400006be40>{number = 1, name = main}
                 
                 说明：
                 所有任务在主线程运行，并且在提交后才会运行。主线程是串行线程，任务一个一个运行
 
                 */
                
            }))
            .addItem(BaseWordItem(withTitle: "全局队列 + 异步执行", subTitle: nil, operation: { (indexPath) in
                let queue = DispatchQueue.global()
                print("全局队列+异步执行----开始")
                for i in 0 ..< 10 {
                    queue.async {
                        print("\(String(i))--------\(Thread.current.description)")
                    }
                }
                print("全局队列+异步执行----结束")
                /**
                 输出：
                 全局队列+异步执行----开始
                 全局队列+异步执行----结束
                 0--------<NSThread: 0x600000662d80>{number = 11, name = (null)}
                 1--------<NSThread: 0x60400027a300>{number = 13, name = (null)}
                 2--------<NSThread: 0x60000046b4c0>{number = 12, name = (null)}
                 3--------<NSThread: 0x60400026da40>{number = 10, name = (null)}
                 4--------<NSThread: 0x604000479240>{number = 9, name = (null)}
                 5--------<NSThread: 0x60000066f5c0>{number = 8, name = (null)}
                 6--------<NSThread: 0x600000662d80>{number = 11, name = (null)}
                 7--------<NSThread: 0x60400027a300>{number = 13, name = (null)}
                 8--------<NSThread: 0x60000046b4c0>{number = 12, name = (null)}
                 9--------<NSThread: 0x60400026da40>{number = 10, name = (null)}

                 说明：
                    为每个任务开新线程，并且没有马上执行
                 */
            }))
        self.sections.append(BaseItemSection(withItems: [], andHeaderTitle: "多种GCD", footerTitle: nil))
        let _ = self.addItem(BaseWordItem(withTitle: "dispatch_barrier_async", subTitle: "栅栏函数", operation: { [weak self] (indexPath) in
            
            }), section: 1)
            .addItem(BaseWordItem(withTitle: "dispatch_apply", subTitle: "快速迭代", operation: { [weak self] (indexPath) in
                
            }), section: 1)
            .addItem(BaseWordItem(withTitle: "dispatch_group_t", subTitle: "队列组和线程通讯", operation: { [weak self] (indexPath) in
                
            }), section: 1)
            .addItem(BaseWordItem(withTitle: "dispatch_source_t", subTitle: "GCD定时器", operation: { [weak self] (indexPath) in
                
            }), section: 1)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

// MARK: - Table View Data Source And Delegate
extension GCDTableViewController {
    
    
}

// MARK: - StoryBoard Method
extension GCDTableViewController {
    

}


