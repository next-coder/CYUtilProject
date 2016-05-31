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
    static func dataFromJSONObject(let JSONObject: AnyObject) -> NSData? {

        if NSJSONSerialization.isValidJSONObject(JSONObject) {

            do {

                let data = try NSJSONSerialization.dataWithJSONObject(JSONObject, options: .PrettyPrinted)
                return data
            } catch {

                // exception
            }
        }
        return nil
    }

    static func stringFromJSONObject(JSONObject: AnyObject) -> String? {

        if let JSONData = self.dataFromJSONObject(JSONObject) {

            return String(data: JSONData, encoding: NSUTF8StringEncoding)
        }
        return nil
    }


    // JSON Object from data
    static func JSONObjectFromData(let data: NSData) -> AnyObject? {

        do {

            let JSONObject =  try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            return JSONObject
        } catch {

            // exception
        }
        return nil
    }

    static func dictionaryFromJSONData(data: NSData) -> [String : AnyObject]? {

        if let JSONObject = self.JSONObjectFromData(data) {

            return JSONObject as? [String : AnyObject]
        }
        return nil
    }

    static func arrayFromJSONData(data: NSData) -> [AnyObject]? {

        if let JSONObject = self.JSONObjectFromData(data) {

            return JSONObject as? [AnyObject]
        }
        return nil
    }

    // JSON Object from String, must UTF8 encoding string, otherwise use JSONObjectFromData
    static func JSONObjectFromString(JSONString: String) -> AnyObject? {

        if let data = JSONString.dataUsingEncoding(NSUTF8StringEncoding) {

            return self.JSONObjectFromData(data)
        }
        return nil
    }

    static func dictionaryFromJSONString(JSONString: String) -> [String : AnyObject]? {

        if let data = JSONString.dataUsingEncoding(NSUTF8StringEncoding) {

            return self.dictionaryFromJSONData(data)
        }
        return nil
    }

    static func arrayFromJSONString(JSONString: String) -> [AnyObject]? {

        if let data = JSONString.dataUsingEncoding(NSUTF8StringEncoding) {

            return self.arrayFromJSONData(data)
        }
        return nil
    }

}
