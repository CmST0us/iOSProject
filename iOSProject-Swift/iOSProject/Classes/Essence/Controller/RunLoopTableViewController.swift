//
//  RunLoopTableViewController.swift
//  iOSProject
//
//  Created by CmST0us on 2018/5/4.
//  Copyright © 2018年 eric3u. All rights reserved.
//

import UIKit

class RunLoopTableViewController: BaseStaticTableViewController {
    
    // MARK: Public Member
    
    // MARK: Private Member
    private var operationFlag1: Bool = false
    private var operationFlag2: Bool = false
    private var timers: [Timer] = []
    var threads: [Thread] = []
    
    // MARK: Public Method
    deinit {
        Logger.shared.console("deinit")
    }
    // MARK: Private Method
    
}

// MARK: - 线程和RunLoop
/// 观察打印出的RunLoop，主线程和创建的新线程RunLoop的区别
extension RunLoopTableViewController {
    func runLoopAndThread() {
        print("RunLoop----\n\(RunLoop.main.description)\n-----End")
        let thread = Thread(target: self, selector: #selector(runLoopAndThreadRun), object: nil)
        self.threads.append(thread)
        thread.start()
    }
    
    @objc
    func runLoopAndThreadRun() {
        print("on----run")
        print("RunLoop----\n\(RunLoop.current.description)\n----End")
        print("thread----\(Thread.current.description)")
    }
    
}

// MARK: - 子线程定时器
extension RunLoopTableViewController {
    func threadTimer() {
        print("RunLoop----\(RunLoop.current.description)\n----End")
        print("thread----\(Thread.current.description)")
        let thread = Thread(target: self, selector: #selector(threadTimerRun), object: nil)
        self.threads.append(thread)
        thread.start()
    }
    
    @objc
    func threadTimerRun() {
        print("RunLoop----\(RunLoop.current.description)\n----End")
        print("thread----\(Thread.current.description)")
        
        // create a timer and scheduled it on the curren default runloop??
        // 是否在创建时就添加到当前RunLoop
        
        let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] (timer) in
            self?.runLoopAndThreadRun()
        }
        
        
        
        
    }
}

// MARK: - Life Cycle Method
extension RunLoopTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let _ = self
            .addItem(BaseWordItem(withTitle: "线程和RunLoop", subTitle: nil, operation: { [weak self] (indexPath) in
                self?.runLoopAndThread()
            }))
            .addItem(BaseWordItem(withTitle: "子线程定时器", subTitle: "思考定时器为什么不执行", operation: { [weak self] (indexPath) in
                self?.threadTimer()
            }))
            .addItem(BaseWordItem(withTitle: "子线程定时器2", subTitle: "思考定时器为什么执行", operation: { (indexPath) in
                
            }))
            .addItem(BaseWordItem(withTitle: "定时器和RunLoop", subTitle: nil, operation: { (indexPath) in
                
            }))
            .addItem(BaseWordItem(withTitle: "线程常驻：RunLoop里面添加NSPort", subTitle: "添加runloop观察者，多次点击看打印", operation: { (indexPath) in
                
            }))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

// MARK: - Table View Data Source And Delegate
extension RunLoopTableViewController {
    
    
}

// MARK: - StoryBoard Method
extension RunLoopTableViewController {
    
}

