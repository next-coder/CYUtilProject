//
//  WebViewControllerStyle.swift
//  CYUtilProjectSwift
//
//  Created by xn011644 on 27/11/2017.
//  Copyright © 2017 Jasper. All rights reserved.
//

import UIKit

public enum WebViewControllerCloseBarButtonItemMode: Int {
    // 默认方式，第一个页面不显示，之后的页面显示
    case `default`
    // 总是显示
    case always
    // 不显示
    case none
}

open class WebViewControllerStyle: NSObject {

    open var closeBarButtonItemMode = WebViewControllerCloseBarButtonItemMode.`default`

    open var progressBarColor: UIColor?
    open var progressBarWidth: Double = 2.0

    public init(closeBarButtonItemMode: WebViewControllerCloseBarButtonItemMode = .`default`,
                progressBarColor: UIColor? = nil,
                progressBarWidth: Double = 2.0) {
        self.closeBarButtonItemMode = closeBarButtonItemMode
        self.progressBarColor = progressBarColor
        self.progressBarWidth = progressBarWidth
        super.init()
    }
}
