//
//  CYJSHTTPParametersSerialization.swift
//  CYUtilProjectSwift
//
//  Created by Conner on 6/20/16.
//  Copyright © 2016 Conner. All rights reserved.
//

import UIKit

class CYJSHTTPParametersSerialization: CYJSParametersSerialization {

    override func serializeParameters(_ paramsString: String?) -> AnyObject? {

        if let paramsStr = paramsString {

            let paramsStrArray = paramsStr.components(separatedBy: "&")
            var paramsDic = [String: String]()
            for paramStr in paramsStrArray {

                let paramArray = paramStr.components(separatedBy: "=")
                if paramArray.count == 2 {

                    paramsDic[paramArray[0]] = paramArray[1]
                }
            }

            return paramsDic as AnyObject?
        }
        return nil
    }

}
