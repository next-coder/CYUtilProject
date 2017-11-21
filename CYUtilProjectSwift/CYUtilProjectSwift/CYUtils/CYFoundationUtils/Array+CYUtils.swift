//
//  Array+CYUtils.swift
//  CYUtilProjectSwift
//
//  Created by Conner on 5/24/16.
//  Copyright © 2016 Conner. All rights reserved.
//

import Foundation

extension Array {

    static func arrayFromJSONData(_ JSONData: Data) -> [AnyObject]? {

        return CYJSONUtils.arrayFromJSONData(JSONData)
    }

    static func arrayFromJSONString(_ JSONString: String) -> [AnyObject]? {

        return CYJSONUtils.arrayFromJSONString(JSONString)
    }
}
