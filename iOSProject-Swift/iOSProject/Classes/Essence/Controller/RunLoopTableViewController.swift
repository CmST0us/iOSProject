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
    var port: NSMachPort!
    
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
        print("RunLoop---->\n\(RunLoop.main.description)\n<-----")
        let thread = Thread(target: self, selector: #selector(runLoopAndThreadRun), object: nil)
        self.threads.append(thread)
        thread.start()
    }
    
    @objc
    func runLoopAndThreadRun() {
        print("on----run")
        print("RunLoop---->\n\(RunLoop.current.description)\n<----")
        print("thread----\(Thread.current.description)")
    }
    
}

// MARK: - 子线程定时器
extension RunLoopTableViewController {
    func threadTimer() {
        print("RunLoop---->\n\(RunLoop.current.description)\n<----")
        print("thread----\(Thread.current.description)")
        let thread = Thread(target: self, selector: #selector(threadTimerRun), object: nil)
        self.threads.append(thread)
        thread.start()
    }
    
    @objc
    func threadTimerRun() {
        print("RunLoop---->\n\(RunLoop.current.description)\n<----")
        print("thread----\(Thread.current.description)")
        
        // create a timer and scheduled it on the curren default runloop??
        // 是否在创建时就添加到当前RunLoop，是的
        
        let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] (timer) in
            self?.runLoopAndThreadRun()
        }
        
        self.timers.append(timer)
        // Timer.scheduledTimer方法会将timer添加到当前RunLoop中，就不需要手动添加了,关于这点文档里面也说了。
        // Timer.init 创建的Timer才需要手动add到RunLoop中
        // RunLoop.current.add(timer, forMode: RunLoopMode.commonModes)
        
        // 让RunLoop运行以确保定时器正常工作
        // 同时，为了确保线程可以安全退出，为RunLoop分配一个时间片，以一定的间隔检查线程是否应该退出。
        // 虽然可以用exit()直接退出线程，但是这会导致内存泄漏
        
        //每隔5秒检查线程是否应该退出
        while !Thread.current.isCancelled {
            RunLoop.current.run(until: Date.init(timeIntervalSinceNow: 5))
        }
        
        print("RunLoop----退出了")
        /*
         计时器不能正常运行。
 
         原因分析：
         新创建的线程RunLoop默认不处于run状态，而timer的运行需要在线程的RunLoop中
         我们把timer添加到RunLoop中后，需要启动当前线程的RunLoop，timer才能工作
         
         从输出中也可以观察到RunLoop在run之前并没有运行
         Timer.scheduledTimer方法会将timer添加到当前RunLoop中
         */
    }
}


// MARK: - 子线程定时器2
extension RunLoopTableViewController {
    func threadTimer2() {
        print("RunLoop---->\n\(RunLoop.current.description)\n<----")
        print("thread----\(Thread.current.description)")
        
        let thread = Thread(target: self, selector: #selector(threadTimer2Run), object: nil)
        thread.start()
        self.threads.append(thread)
        
    }
    
    @objc
    func threadTimer2Run() {
        print("RunLoop---->\n\(RunLoop.current.description)\n<----")
        print("thread----\(Thread.current.description)")
        
        let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] (timer) in
            self?.runLoopAndThreadRun()
        }
        self.timers.append(timer)
        
        // 添加port
        port = NSMachPort()
        port.setDelegate(self)
    
        /// 使用port也可以防止RunLoop退出？不行
        RunLoop.current.add(port, forMode: RunLoopMode.defaultRunLoopMode)
        RunLoop.current.add(timer, forMode: .commonModes)
        
        while !Thread.current.isCancelled {
            // Runs the loop once, blocking for input in the specified mode until a given date.
            // 只运行一次，设置3秒超时
            // RunLoop.current.run(mode: .commonModes, before: Date.init(timeIntervalSinceNow: 3))
            
            RunLoop.current.run(until: Date.init(timeIntervalSinceNow: 3))
        }
        
        print("RunLoop----结束")
    }
    
}

// MARK: - 定时器和RunLoop
extension RunLoopTableViewController {
    func timerRunLoop() {
        print("RunLoop---->\n\(RunLoop.current.description)\n<----")
        
        let timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(runLoopAndThreadRun), userInfo: nil, repeats: true)
        self.timers.append(timer)
        
        // timer会跑在commonModes下，这个模式下可以在ScrollView滑动时也能触发Timer
//        RunLoop.current.add(timer, forMode: .commonModes)
        
        // timer跑在default模式下的话ScrollView滑动时不能触发Timer
        RunLoop.current.add(timer, forMode: .defaultRunLoopMode)
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
            .addItem(BaseWordItem(withTitle: "子线程定时器2", subTitle: "思考定时器为什么执行", operation: { [weak self] (indexPath) in
                
                /// 顺便添加了一点线程通信的、RunLoop的两种run的方法的区别
                self?.threadTimer2()
                
                // 添加一个按钮给线程传信息
                let button = UIButton(frame: CGRect(x: 100, y: 100, width: 80, height: 40))
                button.setTitle("传消息", for: .normal)
                button.backgroundColor = UIColor.blue
                
                button.addActionHandler({ (tag) in
                    self?.port.send(before: Date.init(timeIntervalSinceNow: 1), components: nil, from: nil, reserved: 0)
                })
                self?.view.addSubview(button)
                
            }))
            .addItem(BaseWordItem(withTitle: "定时器和RunLoop", subTitle: nil, operation: { [weak self] (indexPath) in
                self?.timerRunLoop()
            }))
            .addItem(BaseWordItem(withTitle: "线程常驻：RunLoop里面添加NSPort", subTitle: "添加runloop观察者，多次点击看打印", operation: { (indexPath) in
                
            }))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidDisappear(_ animated: Bool) {
        self.timers.forEach { (timers) in
            timers.invalidate()
        }
        self.timers.removeAll()
        
        self.threads.forEach { (thread) in
            thread.cancel()
        }
        self.threads.removeAll()
    }
}

// MARK: - Table View Data Source And Delegate
extension RunLoopTableViewController {
    
    
}

// MARK: - StoryBoard Method
extension RunLoopTableViewController {
    
}

// MARK: - NSMachPortDelegate
extension RunLoopTableViewController: NSMachPortDelegate {
    func handleMachMessage(_ msg: UnsafeMutableRawPointer) {
        
    }
}
