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
    deinit {
        Logger.shared.console("deinit")
    }
    // MARK: Private Method
    var timer: DispatchSourceTimer!
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
        let _ = self
            .addItem(BaseWordItem(withTitle: "dispatch_barrier_async", subTitle: "栅栏函数", operation: { (indexPath) in
                let queue = DispatchQueue(label: "queue-barrier", attributes: DispatchQueue.Attributes.concurrent)
                queue.async {
                    Thread.sleep(forTimeInterval: 1)
                    print("1, asynv get main queue")
                }
                queue.async {
                    Thread.sleep(forTimeInterval: 2)
                    print("2. async get global queue")
                }
                queue.sync {
                    print("3. sync get global")
                }
                
                /// 在Swift中，dispatch_barrier 已经变成了DispatchWorkItemFlags
                
                /**
                 /*
                 <一>什么是dispatch_barrier_async函数
                 
                 毫无疑问,dispatch_barrier_async函数的作用与barrier的意思相同,在进程管理中起到一个栅栏的作用
                 它等待所有位于barrier函数之前的操作执行完毕后执行,并且在barrier函数执行之后,barrier函数之后的操作才会得到执行
                 该函数需要同dispatch_queue_create函数生成的concurrent Dispatch Queue队列一起使用
                 
                 <二>dispatch_barrier_async函数的作用
                 
                 1.实现高效率的数据库访问和文件访问
                 
                 2.避免数据竞争
                 
                 <三>dispatch_barrier_async实例
                 */
 
                 */
                let workItem = DispatchWorkItem(flags: DispatchWorkItemFlags.barrier, block: {
                    print("----barrier----\(Thread.current.description)")
                })
                
                queue.async(execute: workItem)
                
                queue.async {
                    print("4, asycn get global")
                }
                
                queue.async {
                    print("5, sync get global")
                }
                
            }), section: 1)
            .addItem(BaseWordItem(withTitle: "dispatch_apply", subTitle: "快速迭代", operation: { (indexPath) in
                
                /*
                 这个函数提交代码块到一个分发队列,以供多次调用,会等迭代其中的任务全部完成以后,才会返回.
                 如果被提交的队列是并发队列,那么这个代码块必须保证每次读写的安全.
                 这个函数对并行的循环 还有作用,
                 
                 我理解就是类似遍历一个数组一样,当提交到一个并发的队列上的时候,这个遍历是并发运行的,速度很快.
                 
                 作者：机器人小雪
                 链接：https://www.jianshu.com/p/0243f317d79e
                 來源：简书
                 著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。
                 */
                print("快速迭代----开始")
                
                DispatchQueue.concurrentPerform(iterations: 8, execute: { (i) in
                    
                    print("迭代次数：\(String(i)), 线程：\(Thread.current.description)")
                })
                
                print("快速迭代----结束")
                
                /**
                 输出：
                 快速迭代----开始
                 迭代次数：2, 线程：<NSThread: 0x6000004683c0>{number = 6, name = (null)}
                 迭代次数：3, 线程：<NSThread: 0x60400086b080>{number = 7, name = (null)}
                 迭代次数：0, 线程：<NSThread: 0x600000069980>{number = 1, name = main}
                 迭代次数：1, 线程：<NSThread: 0x604000868f40>{number = 5, name = (null)}
                 迭代次数：4, 线程：<NSThread: 0x6000004683c0>{number = 6, name = (null)}
                 迭代次数：5, 线程：<NSThread: 0x60400086b080>{number = 7, name = (null)}
                 迭代次数：6, 线程：<NSThread: 0x600000069980>{number = 1, name = main}
                 迭代次数：7, 线程：<NSThread: 0x604000868f40>{number = 5, name = (null)}
                 快速迭代----结束
                 
                 说明：
                 系统自动对迭代做多线程并行优化
                 每个任务都要保证读写安全
                 */
                
            }), section: 1)
            .addItem(BaseWordItem(withTitle: "dispatch_group_t", subTitle: "队列组和线程通讯", operation: { [weak self] (indexPath) in
                let group = DispatchGroup()
                var image1: UIImage!
                
                let queue = DispatchQueue.global()
                
                queue.async(group: group) {
                    let url = URL(string: "http://img.pconline.com.cn/images/photoblog/9/9/8/1/9981681/200910/11/1255259355826.jpg")!
                    if let data = try? Data.init(contentsOf: url) {
                        image1 = UIImage(data: data)
                    }
                }
                
                var image2: UIImage!
                
                queue.async(group: group) {
                    let url = URL(string: "http://pic38.nipic.com/20140228/5571398_215900721128_2.jpg")!
                    if let data = try? Data.init(contentsOf: url) {
                        image2 = UIImage(data: data)
                    }
                }
                
                group.notify(queue: queue, execute: {
                    UIGraphicsBeginImageContext(CGSize(width: 100, height: 100))
                    image1.draw(in: CGRect(x: 0, y: 0, width: 50, height: 100))
                    image2.draw(in: CGRect(x: 50, y: 0, width: 50, height: 100))
                    let image = UIGraphicsGetImageFromCurrentImageContext()
                    
                    DispatchQueue.main.async {
                        let imageView = UIImageView(image: image)
                        imageView.frame = CGRect(x: 100, y: 100, width: 200, height: 200)
                        self?.view.addSubview(imageView)
                        
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                            imageView.removeFromSuperview()
                        }
                    }
                })
                
                /// group.notify 会在一组任务完成之后运行
                
            }), section: 1)
            .addItem(BaseWordItem(withTitle: "dispatch_source_t", subTitle: "GCD定时器", operation: { [weak self] (indexPath) in
                let queue = DispatchQueue.global()
                var count = 0
                self?.timer = DispatchSource.makeTimerSource(queue: queue)
                self?.timer.schedule(deadline: DispatchTime.now(), repeating: 1)
                
                self?.timer.setEventHandler(handler: DispatchWorkItem(block: {
                    print("计时器--------\(Thread.current.description)")
                    count += 1
                    if count == 10 {
                        self?.timer.cancel()
                        self?.timer = nil
                    }
                }))
                self?.timer.setCancelHandler(handler: DispatchWorkItem(block: {
                    print("计时器取消")
                }))
                self?.timer.resume()
            }), section: 1)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        if self.timer != nil {
            self.timer.cancel()
            self.timer = nil
        }

    }
}

// MARK: - Table View Data Source And Delegate
extension GCDTableViewController {
    
    
}

// MARK: - StoryBoard Method
extension GCDTableViewController {
    

}


