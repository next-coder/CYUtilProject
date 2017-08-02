//
//  Dictionary+CYUtils.swift
//  CYUtilProjectSwift
//
//  Created by Conner on 5/24/16.
//  Copyright © 2016 Conner. All rights reserved.
//

import Foundation

extension Dictionary {

    static func dictionaryFromJSONData(_ JSONData: Data) -> [String : AnyObject]? {

        return CYJSONUtils.dictionaryFromJSONData(JSONData)
    }

    static func dictionaryFromJSONString(_ JSONString: String) -> [String : AnyObject]? {

        return CYJSONUtils.dictionaryFromJSONString(JSONString)
    }
}
