//
//  UIViewController+alert.swift
//  iOSProject
//
//  Created by CmST0us on 2018/5/4.
//  Copyright © 2018年 eric3u. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showAlert(withTitle title: String?,
                           message: String?,
                       actionMaker: ((_ alertController: UIAlertController) -> Void)) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actionMaker(alert)
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    func showInfoAlert(withTitle title: String?,
                               message: String?,
                               cancelMessage: String = "OK") {
        self.showAlert(withTitle: title, message: message) { (alert) in
            let cancelAction = UIAlertAction(title: cancelMessage, style: .cancel, handler: nil)
            alert.addAction(cancelAction)
        }
    }
    
}
