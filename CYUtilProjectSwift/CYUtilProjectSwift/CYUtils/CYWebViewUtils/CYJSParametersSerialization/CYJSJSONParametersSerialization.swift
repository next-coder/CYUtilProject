//
//  CYJSJSONParametersSerialization.swift
//  CYUtilProjectSwift
//
//  Created by xn011644 on 6/20/16.
//  Copyright © 2016 Jasper. All rights reserved.
//

import UIKit

class CYJSJSONParametersSerialization: CYJSParametersSerialization {

    override func serializeParameters(_ paramsString: String?) -> AnyObject? {

        if let paramsStr = paramsString {

            let jsonData = paramsStr.data(using: String.Encoding.utf8)
            if let data = jsonData {

                do {

                    return try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject?
                } catch {

                    NSLog("JSON parameters serialization failed")
                }
            }
        }
        return nil
    }

}