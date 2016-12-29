//
//  CYJSONUtils.swift
//  CYUtilProjectSwift
//
//  Created by xn011644 on 5/24/16.
//  Copyright © 2016 Jasper. All rights reserved.
//

import Foundation

class CYJSONUtils {

    // data from JSONObject, transfer object to json data
    static func dataFromJSONObject(_ JSONObject: AnyObject) -> Data? {

        if JSONSerialization.isValidJSONObject(JSONObject) {

            do {

                let data = try JSONSerialization.data(withJSONObject: JSONObject, options: .prettyPrinted)
                return data
            } catch {

                // exception
            }
        }
        return nil
    }

    static func stringFromJSONObject(_ JSONObject: AnyObject) -> String? {

        if let JSONData = self.dataFromJSONObject(JSONObject) {

            return String(data: JSONData, encoding: String.Encoding.utf8)
        }
        return nil
    }


    // JSON Object from data
    static func JSONObjectFromData(_ data: Data) -> AnyObject? {

        do {

            let JSONObject =  try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            return JSONObject as AnyObject?
        } catch {

            // exception
        }
        return nil
    }

    static func dictionaryFromJSONData(_ data: Data) -> [String : AnyObject]? {

        if let JSONObject = self.JSONObjectFromData(data) {

            return JSONObject as? [String : AnyObject]
        }
        return nil
    }

    static func arrayFromJSONData(_ data: Data) -> [AnyObject]? {

        if let JSONObject = self.JSONObjectFromData(data) {

            return JSONObject as? [AnyObject]
        }
        return nil
    }

    // JSON Object from String, must UTF8 encoding string, otherwise use JSONObjectFromData
    static func JSONObjectFromString(_ JSONString: String) -> AnyObject? {

        if let data = JSONString.data(using: String.Encoding.utf8) {

            return self.JSONObjectFromData(data)
        }
        return nil
    }

    static func dictionaryFromJSONString(_ JSONString: String) -> [String : AnyObject]? {

        if let data = JSONString.data(using: String.Encoding.utf8) {

            return self.dictionaryFromJSONData(data)
        }
        return nil
    }

    static func arrayFromJSONString(_ JSONString: String) -> [AnyObject]? {

        if let data = JSONString.data(using: String.Encoding.utf8) {

            return self.arrayFromJSONData(data)
        }
        return nil
    }

}
