//
//  NSThreadTableViewController.swift
//  iOSProject
//
//  Created by CmST0us on 2018/5/4.
//  Copyright © 2018年 eric3u. All rights reserved.
//

import UIKit

class NSThreadTableViewController: BaseStaticTableViewController {
    
    // MARK: Public Member
    
    // MARK: Private Member
    var myThread: Thread!
    var myThreadList: [Thread] = []
    // MARK: Public Method
    deinit {
        Logger.shared.console("deinit")
    }
    // MARK: Private Member
    
}

// MARK: 创建线程
extension NSThreadTableViewController {
    @objc
    private func outputThreadDescription() {
        Logger.shared.output("当前执行的线程为:\(Thread.current.description)")
    }
    
    private func addThreadAction() {
        let thread = Thread(target: self, selector: #selector(outputThreadDescription), object: nil)
        thread.name = "thread1"
        thread.start()
        
        /// 另外的创建线程的方式
        
        /** 创建线程后自动启动线程
         Thread.detachNewThread {
         
         }
         */
        
        /** 隐式创建并启动线程
         self.performSelector(inBackground: Selector, with: Any?)
         */
        
    }
}

// MARK: 创建一定数量线程对CPU影响
extension NSThreadTableViewController {
    
    @objc
    private func runMutableThread() {
        for _ in 0 ..< 10000 {
            let thread = Thread(target: self, selector: #selector(outputThreadDescription), object: nil)
            thread.name = "mutableThread-thread"
            thread.start()
        }
    }
    
    private func addMutableThread() {
        let thread = Thread(target: self, selector: #selector(runMutableThread), object: nil)
        thread.name = "mutableThread"
        thread.start()
    }
    
}

// MARK: 强制退出线程
extension NSThreadTableViewController {
    private func exitThread() {
        if myThread == nil {
            myThread = Thread(target: self, selector: #selector(runExitAction), object: nil)
            myThread.name = "thread-exit"
        }
        if !myThread.isExecuting {
            myThread.start()
        }
    }
    
    @objc func runExitAction() {
        Logger.shared.output("thread-exit启动")
        Thread.sleep(forTimeInterval: 3)
        if Thread.current.isCancelled {
            Logger.shared.console("当前Thread被exit了")
            Thread.exit()
        }
        
        self.outputThreadDescription()
    }
}

// MARK: 用数组储存线程
extension NSThreadTableViewController {
    private func addArrayThread() {
        self.myThreadList.removeAll()
        for i in 0 ..< 10 {
            let thread = Thread(target: self, selector: #selector(addArrayThreadAction), object: nil)
            thread.name = "thread-\(String(i))"
            myThreadList.append(thread)
        }
        
        myThreadList.forEach { (thread) in
            thread.start()
        }
    }
    
    @objc
    private func addArrayThreadAction() {
        Thread.sleep(forTimeInterval: 3)
        self.outputThreadDescription()
        if Thread.current.isCancelled {
            Logger.shared.console("当前线程\(Thread.current.name ?? "")退出")
            
            /// 这里如果直接用Thread.exit()的话会直接结束线程，这样会导致对象没有及时释放，内存泄漏
//            Thread.exit()
            return
        }
        
        self.performSelector(onMainThread: #selector(updateImage), with: nil, waitUntilDone: true)
    }
    
    @objc
    private func updateImage(){
        Logger.shared.output("执行完了")
        Logger.shared.output("当前\(String(Thread.isMainThread))在主线程中")
    }
}
// MARK: - Life Cycle Method
extension NSThreadTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sections.append(BaseItemSection(withItems: [], andHeaderTitle: "用例", footerTitle: nil))
        self.sections.append(BaseItemSection(withItems: [], andHeaderTitle: "Log", footerTitle: nil))
        Logger.shared.delegate = self
        let _ = self.addItem(BaseWordItem(withTitle: "简单创建一个多线程", subTitle: "Thread()", operation: { [weak self] (indexPath) in
            self?.addThreadAction()
            }))
            
            .addItem(BaseWordItem(withTitle: "测试增加一定数量对CPU的影响", subTitle: "在子线程中创建多个线程 不影响主线程", operation: { [weak self](indexPath) in
                Logger.shared.output("\(String(CFAbsoluteTimeGetCurrent()))")
                
                /// 把创建大量线程的操作方法另一个线程中运行，不会阻塞主线程
                self?.addMutableThread()
                
                /// 尝试使用
                ///  self?.runMutableThread()
                /// 观察到创建大量线程时会阻塞主线程
                
                Logger.shared.output("\(String(CFAbsoluteTimeGetCurrent()))")
            }))
            .addItem(BaseWordItem(withTitle: "强制退出线程", subTitle: "Thread.exit", operation: { [weak self] (indexPath) in
                self?.exitThread()
            }))
            .addItem(BaseWordItem(withTitle: "用数组储存线程", subTitle: nil, operation: { [weak self] (indexPath) in
                self?.addArrayThread()
            }))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if self.myThread != nil && !self.myThread.isCancelled {
            Logger.shared.console("当前thread-exit被cancel")
            
            /// cancel 只是一个标示，强制退出终止线程的是exit
            self.myThread.cancel()
            Logger.shared.console("当前thread-exit线程cancel状态标记为\(String(self.myThread.isCancelled))")
        }
        
        self.myThreadList.forEach { (thread) in
            if !thread.isCancelled {
                /// 标示cancel状态
                thread.cancel()
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

// MARK: - Table View Data Source And Delegate
extension NSThreadTableViewController {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let h = super.tableView(tableView, heightForRowAt: indexPath)
        if indexPath.section == 0 {
            return h
        }
        return 300
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if indexPath.section == 0 {
            return cell
        }
        cell.textLabel?.numberOfLines = 0
        return cell
    }
}

// MARK: - StoryBoard Method
extension NSThreadTableViewController {
    
    
}

extension NSThreadTableViewController: LoggerDelegate {
    func log(msg: String) {
        let _ = self.addItem(BaseWordItem(withTitle: msg, subTitle: nil), section: 1)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
