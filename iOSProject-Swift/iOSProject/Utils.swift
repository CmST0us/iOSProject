//
//  Utils.swift
//  iOSProject
//
//  Created by CmST0us on 2018/5/4.
//  Copyright © 2018年 eric3u. All rights reserved.
//

import Foundation
import UIKit

let kNamespace = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String

let kScreenHeightRatio  = UIScreen.main.bounds.size.height / 667
let kScreenWidthRatio   = UIScreen.main.bounds.size.width / 375
let kScreenWidth        = UIScreen.main.bounds.size.width
let kScreenHeight       = UIScreen.main.bounds.size.height

func adaptedWidth(_ x: Float) -> CGFloat {
    return CGFloat(ceilf(x)) * kScreenWidthRatio
}

func adaptedHeight(_ x: Float) -> CGFloat {
    return CGFloat(ceilf(x)) * kScreenWidthRatio
}

func adaptedFontSize(_ x: Float) -> UIFont {
    return UIFont.systemFont(ofSize: adaptedWidth(x))
}

func rad(_ degree: CGFloat) -> CGFloat {
    return CGFloat(Double.pi / 180.0) * degree
}

func degree(_ rad: CGFloat) -> CGFloat {
    return CGFloat(180.0 / Double.pi) * rad
}
