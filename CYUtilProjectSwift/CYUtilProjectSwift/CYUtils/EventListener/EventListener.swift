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

    @objc func handle(_ event: String, userInfo: [AnyHashable: Any]?)
}

open class EventListener: NSObject {

    private lazy var objectHandlers: [String: EventHandler] = [:]
    private lazy var closureHandlers: [String: ((EventListener, String, [AnyHashable: Any]?) -> Void)] = [:]

    // MARK: - handle event
    open func canHandle(event: String) -> Bool {
        
        return objectHandlers[event] != nil
                || closureHandlers[event] != nil
    }
    
    open func canHandle(url: String) -> Bool {
        var event: String
        if let index = url.index(of: "?") {
            event = String(url[url.startIndex..<index])
        } else {
            event = url
        }
        return canHandle(event: event)
    }
    
    open func handle(event: String, userInfo: [AnyHashable: Any]?) -> Bool {
        if let handler = objectHandlers[event] {
            handler.handle(event, userInfo: userInfo)
            return true
        } else if let handler = closureHandlers[event] {
            handler(self, event, userInfo)
            return true
        } else {
            return false
        }
    }
    
    open func handle(url: String) -> Bool {
        let (event, userInfo) = analysis(url: url)
        return handle(event: event, userInfo: userInfo)
    }
    
    // MARK: - analysisUrl
    private func analysis(url: String) -> (event: String, userInfo: [AnyHashable: Any]?) {
        if let index = url.index(of: "?") {
            let event = String(url[url.startIndex..<index])
            let userInfoString = String(url[url.index(after: index)..<url.endIndex])
            let userInfo = self.userInfo(from: userInfoString)
            return (event, userInfo)
        } else {
            return (url, nil)
        }
    }
    
    private func userInfo(from userInfoString: String) -> [AnyHashable: Any]? {
        var userInfo: [AnyHashable: Any]? = nil
        
        let userInfoComponents = userInfoString.components(separatedBy: "&")
        for userInfoComponent in userInfoComponents {
            let userInfoItem = userInfoComponent.components(separatedBy: "=")
            if userInfoItem.count > 1 {
                
                if userInfo == nil {
                    userInfo = [:]
                }
                userInfo?[userInfoItem[0]] = userInfoItem[1]
            }
        }
        return userInfo
    }
    
    // MARK: - register handler
    open func register(handler: EventHandler, `for` event: String) {
        handler.listener = self
        objectHandlers[event] = handler
    }
    
    open func register(closure handler: @escaping ((EventListener, String, [AnyHashable: Any]?) -> Void), `for` event: String) {
        closureHandlers[event] = handler
    }
    
    open func unregister(_ event: String) {
        objectHandlers[event] = nil
        closureHandlers[event] = nil
    }
}
