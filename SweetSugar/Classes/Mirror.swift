//
//  Mirror.swift
//
//  Created on 2021/4/5.
//

import Foundation

public extension Mirror {
    // 通过Mirror将所有属性名和值转为字典
    static func getDict(from obj: Any) -> [String: Any] {
        let mirror = Mirror(reflecting: obj)
        var dict: [String: Any] = [:]
        for child in mirror.children {
            if let key = child.label {
                dict[key] = child.value
            }
        }
        return dict
    }
    
    // 获取对象的第一个属性键值对
    static func getRootValue(from obj: Any) -> (String, Any)? {
        let mirror = Mirror(reflecting: obj)
        guard let child = mirror.children.first, let label = child.label else {
            return nil
        }
        return (label, child.value)
    }
    
    
    /**
     * 将enum自动转化成字典
     */
    static func describeEnumAsKeyValue(_ enumObject: Any) -> (key: String, value: [String: String]) {
        guard let (key, rootValue) = Mirror.getRootValue(from: enumObject) else {
            // 说明这个枚举没有关联类型
            return ("\(enumObject)", [:])
        }
              
        let param = self.describeObjectAsKeyValue(rootValue)
        return (key, param)
    }

    /**
     * 将Object转为[String: String]的键值对
     */
    static func describeObjectAsKeyValue(_ rootObject: Any) -> [String: String] {
        let result = Mirror.getDict(from: rootObject).compactMapValues { (value) -> String? in
            var value = value
            if let opt = value as? AnyOptional {
                  if (opt.isNil) {
                      return nil
                  }
                  value = opt.wrappedValue
            }

            if let str = value as? String {
                return str
            }
            if let convertable = value as? CustomStringConvertible {
                return convertable.description
            }

            #if DEBUG
            fatalError("\(value) can not convert to string, please make it CustomStringConvertible")
            #else
            return nil
            #endif
        }
        return result
    }
}
