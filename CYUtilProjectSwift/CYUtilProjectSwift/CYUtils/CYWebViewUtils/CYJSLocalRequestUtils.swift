//
//  CYJSLocalRequestHandler.swift
//  CYUtilProjectSwift
//
//  Created by xn011644 on 6/7/16.
//  Copyright © 2016 Jasper. All rights reserved.
//

import UIKit

typealias CYJSLocalRequestHandler = ((_ request: URLRequest?, _ event: String, _ params: AnyObject?) -> Void)

class CYJSLocalRequestUtils: NSObject {

    var parameterSerialization: CYJSParametersSerialization? {

        set {

            self.internalParameterSerialization = newValue
        }

        get {

            if self.internalParameterSerialization == nil {

                self.internalParameterSerialization = CYJSJSONParametersSerialization()
            }
            return self.internalParameterSerialization
        }
    }

    fileprivate var internalParameterSerialization: CYJSParametersSerialization?
    fileprivate var handlerObjects: [String: CYJSLocalRequestHandlerObject]?

    // register an event, all events must be registered
    // otherwise, not registered events may not be recognised
    func registerEvent(_ event: String, handler: CYJSLocalRequestHandler?) {

        if self.handlerObjects == nil {

            self.handlerObjects = [String: CYJSLocalRequestHandlerObject]()
        }

        let handlerObject = CYJSLocalRequestHandlerObject(event: event, handler: handler)
        self.handlerObjects![event] = handlerObject
    }

    // remove registered event
    func removeEvent(_ event: String) {

        self.handlerObjects?[event] = nil
    }

    // check wether this utils object can process the paticular event
    func canProcessEvent(_ event: String) -> Bool {

        return (self.handlerObjects?[event] != nil)
    }

    // process the particular event, if not contains this event ,return false else return true
    func processEvent(_ event: String) -> Bool {

        if self.canProcessEvent(event) {

            if let handler = self.handlerObjects?[event]?.handler {

                handler(nil, event, nil)
            }
            return true
        }
        return false
    }

    // check wether this utils object can process the paticular request
    // request.URL.absoluteString, separate this string by the first question mark(?)
    // the string before question mark is event
    // the string after question mark is parameters
    func canProcessRequest(_ request: URLRequest) -> Bool {

        if let url = request.url {

            let (event, _) = self .requestUrlDetail(url)
            return self.canProcessEvent(event)
        } else {

            return false
        }
    }

    // process the particular request
    func processRequest(_ request: URLRequest) -> Bool {

        if let url = request.url {

            let (event, params) = self .requestUrlDetail(url)

            if self.canProcessEvent(event) {

                let handlerObject = self.handlerObjects?[event]
                if let handler = handlerObject?.handler {

                    handler(request, event, params)
                }
                return true
            }
        }

        return false
    }

    func requestUrlDetail(_ url: URL) -> (String, AnyObject?) {

        let urlString = url.absoluteString
        let questionMarkIndex = urlString.characters.index(of: "?")

        if let index = questionMarkIndex {

            let event = urlString.substring(to: index)
            let paramsString = urlString.substring(from: urlString.index(after: index))

            return (event,
                    self.parameterSerialization?.serializeParameters(paramsString))
        } else {

            return (urlString, nil)
        }
    }

    // an default instance of CYJSLocalRequestUtils, 
    // you can use this instance to deal with global events
    static let defaultInstance = CYJSLocalRequestUtils()

}

private class CYJSLocalRequestHandlerObject: NSObject {

    let event: String
    let handler: CYJSLocalRequestHandler?

    init(event: String, handler: CYJSLocalRequestHandler?) {

        self.event = event
        self.handler = handler

        super.init()
    }
}
