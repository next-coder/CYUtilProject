//
//  Dictionary+CYUtils.swift
//  CYUtilProjectSwift
//
//  Created by xn011644 on 5/24/16.
//  Copyright © 2016 Jasper. All rights reserved.
//

import Foundation

extension Dictionary {

    static func dictionaryFromJSONData(JSONData: NSData) -> [String : AnyObject]? {

        return CYJSONUtils.dictionaryFromJSONData(JSONData)
    }

    static func dictionaryFromJSONString(JSONString: String) -> [String : AnyObject]? {

        return CYJSONUtils.dictionaryFromJSONString(JSONString)
    }
}
