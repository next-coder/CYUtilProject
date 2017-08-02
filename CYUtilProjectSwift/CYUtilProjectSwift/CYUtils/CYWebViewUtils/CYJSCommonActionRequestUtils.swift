//
//  CYJSCommonActionRequestUtils.swift
//  CYUtilProjectSwift
//
//  Created by Conner on 6/7/16.
//  Copyright © 2016 Conner. All rights reserved.
//

import UIKit

typealias CYJSImagePickEventHandler = ((_ event: String, _ cancelled: Bool, _ pickInfo: [String: AnyObject]?) -> Void)

// this class contains many common action requests, such as
class CYJSCommonActionRequestUtils: CYJSLocalRequestUtils, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let localRequestUtils: CYJSLocalRequestUtils = CYJSLocalRequestUtils()

    var imagePickEventHandler: CYJSImagePickEventHandler?
    var imagePickEventName: String?

    // May be retain cycle while handler retains the caller
    // So please use weak caller in handler
    func registerPhotoEvent(_ event: String,
                            presentImagePickerFrom: UIViewController,
                            handler: @escaping CYJSImagePickEventHandler) {

        self.imagePickEventHandler = handler
        self.registerEvent(event) {[weak presentImagePickerFrom, weak self] (request, event, paramsString) in

            self?.imagePickEventName = event
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            presentImagePickerFrom?.present(imagePicker,
                                                          animated: true,
                                                          completion: nil)
        }
    }

    // all the following methods are inherint from super

    // register an event, all events must be registered
    // otherwise, not registered events may not be recognised
    override func registerEvent(_ event: String, handler: CYJSLocalRequestHandler?) {

        self.localRequestUtils.registerEvent(event, handler: handler)
    }

    // remove registered event
    override func removeEvent(_ event: String) {

        self.localRequestUtils.removeEvent(event)
    }

    // check wether this utils object can process the paticular event
    override func canProcessEvent(_ event: String) -> Bool {

        return self.localRequestUtils.canProcessEvent(event)
    }

    // process the particular event, if not contains this event ,return false else return true
    override func processEvent(_ event: String) -> Bool {

        return self.localRequestUtils.processEvent(event)
    }

    // check wether this utils object can process the paticular request
    // request.URL.absoluteString, separate this string by the first question mark(?)
    // the string before question mark is event
    // the string after question mark is parameters
    override func canProcessRequest(_ request: URLRequest) -> Bool {

        return self.canProcessRequest(request)
    }

    // process the particular request
    override func processRequest(_ request: URLRequest) -> Bool {

        return self.processRequest(request)
    }


    // UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        if let handler = self.imagePickEventHandler, let event = self.imagePickEventName {

            handler(event, false, info as [String : AnyObject]?)
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {

        if let handler = self.imagePickEventHandler, let event = self.imagePickEventName {

            handler(event, true, nil)
        }
    }
}
