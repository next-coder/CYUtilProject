//
//  Array+CYUtils.swift
//  CYUtilProjectSwift
//
//  Created by xn011644 on 5/24/16.
//  Copyright © 2016 Jasper. All rights reserved.
//

import Foundation

extension Array {

    static func arrayFromJSONData(JSONData: NSData) -> [AnyObject]? {

        return CYJSONUtils.arrayFromJSONData(JSONData)
    }

    static func arrayFromJSONString(JSONString: String) -> [AnyObject]? {

        return CYJSONUtils.arrayFromJSONString(JSONString)
    }
}
