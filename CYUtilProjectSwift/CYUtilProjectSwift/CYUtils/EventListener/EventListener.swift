//
//  EventListener.swift
//  CYUtilProjectSwift
//
//  Created by xn011644 on 21/08/2017.
//  Copyright © 2017 Jasper. All rights reserved.
//

import UIKit

@objc public protocol EventHandler {

    var listener: EventListener? { get set }

    @objc func handleEvent(_ event: String, userInfo: [AnyHashable: Any]?)
}

open class EventListener: NSObject {

    private var objectHandlers: [String: AnyObject]?
//    private var 

    func canHandleEvent(_ event: String) -> Bool {

        return true
    }
}
