//
//  BaseModel.swift
//  CYUtilProjectSwift
//
//  Created by xn011644 on 06/11/2017.
//  Copyright © 2017 Jasper. All rights reserved.
//

import Foundation

@objc public protocol BaseModelProtocol {

//    associatedtype SubModel where SubModel: BaseModelProtocol

    // 属性的key和初始化字典中的key对应关系
    // 用于确定设置属性值时，得到属性的key
    // 如果为nil，则默认属性的key和初始化字典中的key相同
    @objc var propertyKeysForDictionaryKeys: [String: String]? { get }

    // 不认识的key，是否忽略，默认为true
    // 如果不忽略不认识的key，同时又没有针对key处理，则会抛出异常
    @objc var isIgnoringUnknownKeys: Bool { get }

//    init(with dictionary: [String: Any])
//
//    // 创建一个model对象，并以字典初始化
//    @objc static func model(from modelDictionary: [String: Any]) -> SubModel

}

//extension BaseModelProtocol {
//
//    // default return nil
//    @objc public var propertyKeysForDictionaryKeys: [String: String]? {
//        return nil
//    }
//
//    // default is true
//    @objc public var isIgnoringUnknownKeys: Bool {
//        return true
//    }
//
//    @objc public static func model(from dictionary: [String: Any]) -> BaseModelProtocol {
//        return Self.init(with: dictionary)
//    }
//}

@objcMembers open class BaseModel: NSObject, BaseModelProtocol {

    open var propertyKeysForDictionaryKeys: [String : String]? {
        return nil
    }

    open var isIgnoringUnknownKeys: Bool {
        return true
    }

    public required init(with dictionary: [String: Any]) {
        super.init()

        let propertyKeys = self.propertyKeysForDictionaryKeys
        for (key, value) in dictionary {
            var propertyKey = key
            if let key1 = propertyKeys?[key] {

                propertyKey = key1
            }

//            let validate = try? validateValue(value, forKey: propertyKey)
//            if validate ?? false {
//
//            }
        }
    }
}

//extension BaseModel {
//    open func model<T: BaseModel>(with dictionary: [String: Any]) -> T {
//        return T(with: dictionary)
//    }
//
//    open func modelList<T: BaseModel>(with dictionaryList: [[String: Any]]) -> [T] {
//        var list: [T] = []
//        for dictionary in dictionaryList {
//            list.append(model(with: dictionary))
//        }
//        return list
//    }
//}

