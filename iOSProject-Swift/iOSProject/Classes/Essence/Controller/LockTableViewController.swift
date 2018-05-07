//
//  LockTableViewController.swift
//  iOSProject
//
//  Created by CmST0us on 2018/5/4.
//  Copyright © 2018年 eric3u. All rights reserved.
//

import UIKit

class LockTableViewController: BaseStaticTableViewController {
    
    // MARK: Public Member
    
    // MARK: Private Member
    var lock: NSLock!
    var threads: [Thread] = []
    var myMutableList: [String] = []
    var printString: String = ""
    var actionRow: Int = 0
    // MARK: Public Method
    deinit {
        Logger.shared.console("deinit")
    }
    // MARK: Private Method
    @objc
    private func updateImage() {
        print("执行完了，在此线程----\(Thread.current.isMainThread ? "主" : "子" )")
    }
    
    @objc
    private func loadAction(_ index: NSNumber) {
        let thread = Thread.current
        print("loadAction在此线程中运行----\(thread.name ?? "")")
        
        
        var name: String = ""
        switch self.actionRow {
        case 1:
            // 创建的100条线程会同时访问。小概率发生数据竞争！（可以快速点击cell触发）
            // 应该上锁
            if self.myMutableList.count > 0 {
                name = self.myMutableList.removeLast()
            }
            print("当前要加载的图片名称\(name)")
            self.printString += "当前要加载的图片名称\(name)\n"
        case 2:
            lock.lock()
            if self.myMutableList.count > 0 {
                name = self.myMutableList.removeLast()
            }
            print("当前要加载的图片名称\(name)")
            self.printString += "当前要加载的图片名称\(name)\n"
            lock.unlock()
        case 3:
            /// 在Swift中@synchronized这样写
            objc_sync_enter(self)
            if self.myMutableList.count > 0 {
                name = self.myMutableList.removeLast()
                print("当前要加载的图片名称\(name)")
                self.printString += "当前要加载的图片名称\(name)\n"
            }
            objc_sync_exit(self)
        default:
            break
        }
        
        self.performSelector(onMainThread: #selector(updateImage), with: nil, waitUntilDone: true)
        
        /// 不强制退出线程，避免内存泄漏
    }
    
    private func addArrayThread() {
        
        threads.removeAll()
        
        for i in 0 ..< 100 {
            let thread = Thread(target: self, selector: #selector(loadAction(_:)), object: NSNumber(value: i))
            thread.name = "thread-\(String(i))"
            threads.append(thread)
        }
        
        threads.forEach { (t) in
            t.start()
        }
    }
    
    private func start(_ indexPath: IndexPath) {
        for i in 0 ..< 100 {
            myMutableList.append("图片\(String(i))")
        }
        actionRow = indexPath.row
        self.addArrayThread()
        
    }
}

// MARK: - Life Cycle Method
extension LockTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lock = NSLock()
        
        let _ = self
            .addItem(BaseWordItem(withTitle: "第零种情况", subTitle: "Array的线程安全", operation: { (indexPath) in
                var a: [String] = []
                for i in 0 ..< 100 {
                    a.append(String(i))
                }
                
                /*
                 这段也会Crash, 数据竞争
                 
                    for i in 0 ..< a.count {
                        Thread(block: {
                            let l = a.removeLast()
                            print("元素----\(l)")
                        }).start()
                    }
                 */
                

                DispatchQueue.concurrentPerform(iterations: 100, execute: { (i) in

                    /// 会Crash Array不是线程安全的
                    /// objc_sync_enter(self)
                    let l = a.removeLast()
                    print("元素----\(l)")
                    /// objc_sync_exit(self)

                })
                
            }))
            .addItem(BaseWordItem(withTitle: "【?】第一种情况", subTitle: "为什么没有发生竞争", operation: { [weak self] (indexPath) in
                self?.start(indexPath)
            }))
            .addItem(BaseWordItem(withTitle: "第二种情况", subTitle: "NSLock", operation: { [weak self] (indexPath) in
                self?.start(indexPath)
            }))
            .addItem(BaseWordItem(withTitle: "第三种情况", subTitle: "@synchroized", operation: { [weak self] (indexPath) in
                self?.start(indexPath)
            }))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

// MARK: - Table View Data Source And Delegate
extension LockTableViewController {
    

    
}

// MARK: - StoryBoard Method
extension LockTableViewController {
    

}

