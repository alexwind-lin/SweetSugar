//
//  Decodable+Collection.swift
//
//  Created on 2021/4/5.
//

import Foundation

public struct JSONCodingKeys: CodingKey {
    public var stringValue: String

    public init?(stringValue: String) {
        self.stringValue = stringValue
    }

    public var intValue: Int?

    public init?(intValue: Int) {
        self.init(stringValue: "\(intValue)")
        self.intValue = intValue
    }
}

/**
 * 用于直接Decode 基础数据类型的字典和数组,字典只支持String做key
 */

public extension KeyedDecodingContainer {

    func decode(_ type: Dictionary<String, Any>.Type, forKey key: K) throws -> Dictionary<String, Any> {
        let container = try self.nestedContainer(keyedBy: JSONCodingKeys.self, forKey: key)
        return try container.decode(type)
    }

    func decodeIfPresent(_ type: Dictionary<String, Any>.Type, forKey key: K) throws -> Dictionary<String, Any>? {
        guard contains(key) else {
            return nil
        }
        guard try decodeNil(forKey: key) == false else {
            return nil
        }
        return try decode(type, forKey: key)
    }
    
    func decode(_ type: Array<Any>.Type, forKey key: K) throws -> Array<Any> {
        var container = try self.nestedUnkeyedContainer(forKey: key)
        return try container.decode(type)
    }

    func decodeIfPresent(_ type: Array<Any>.Type, forKey key: K) throws -> Array<Any>? {
        guard contains(key) else {
            return nil
        }
        guard try decodeNil(forKey: key) == false else {
            return nil
        }
        return try decode(type, forKey: key)
    }

    func decode(_ type: Dictionary<String, Any>.Type) throws -> Dictionary<String, Any> {
        var dictionary = Dictionary<String, Any>()

        for key in allKeys {
            if let boolValue = try? decode(Bool.self, forKey: key) {
                dictionary[key.stringValue] = boolValue
            } else if let stringValue = try? decode(String.self, forKey: key) {
                dictionary[key.stringValue] = stringValue
            } else if let intValue = try? decode(Int.self, forKey: key) {
                dictionary[key.stringValue] = intValue
            } else if let doubleValue = try? decode(Double.self, forKey: key) {
                dictionary[key.stringValue] = doubleValue
            } else if let nestedDictionary = try? decode(Dictionary<String, Any>.self, forKey: key) {
                dictionary[key.stringValue] = nestedDictionary
            } else if let nestedArray = try? decode(Array<Any>.self, forKey: key) {
                dictionary[key.stringValue] = nestedArray
            }
        }
        return dictionary
    }
}

public extension UnkeyedDecodingContainer {

    mutating func decode(_ type: Array<Any>.Type) throws -> Array<Any> {
        var array: [Any] = []
        while isAtEnd == false {
            // See if the current value in the JSON array is `null` first and prevent infite recursion with nested arrays.
            if try decodeNil() {
                continue
            } else if let value = try? decode(Bool.self) {
                array.append(value)
            } else if let value = try? decode(Int.self) {
                array.append(value)
            } else if let value = try? decode(Double.self) {
                array.append(value)
            } else if let value = try? decode(String.self) {
                array.append(value)
            } else if let nestedDictionary = try? decode(Dictionary<String, Any>.self) {
                array.append(nestedDictionary)
            } else if var subContainer = try? self.nestedUnkeyedContainer(), let nestedArray = try? subContainer.decode(Array<Any>.self) {
                array.append(nestedArray)
            }
        }
        return array
    }

    mutating func decode(_ type: Dictionary<String, Any>.Type) throws -> Dictionary<String, Any> {

        let nestedContainer = try self.nestedContainer(keyedBy: JSONCodingKeys.self)
        return try nestedContainer.decode(type)
    }
}

// MARK: - Encode
extension KeyedEncodingContainer where K == JSONCodingKeys {
    public mutating func encode(_ value: Dictionary<String, Any>) throws {
        for item in value {
            guard let key = JSONCodingKeys(stringValue: item.key) else {
                continue
            }
            
            switch item.value {
            case let number as Int:
                try encode(number, forKey: key)
            case let number as Double:
                try encode(number, forKey: key)
            case let string as String:
                try encode(string, forKey: key)
            case let bool as Bool:
                try encode(bool, forKey: key)
            case let array as [Any]:
                var container = nestedUnkeyedContainer(forKey: key)
                try container.encode(array)
            case let dictionary as [String: Any]:
                var container = nestedContainer(keyedBy: Key.self, forKey: key)
                try container.encode(dictionary)
            default:
                print("unknown type \(item)")
            }
        }
    }
}

extension UnkeyedEncodingContainer {
    public mutating func encode(_ value: Array<Any>) throws {
        for item in value {
            switch item {
            case let number as Int:
                try encode(number)
            case let number as Double:
                try encode(number)
            case let string as String:
                try encode(string)
            case let bool as Bool:
                try encode(bool)
            case let array as [Any]:
                var container = nestedUnkeyedContainer()
                try container.encode(array)
            case let dictionary as [String: Any]:
                var container =  nestedContainer(keyedBy: JSONCodingKeys.self)
                try container.encode(dictionary)
            default:
                print("unknown type \(item)")
            }
        }
    }
}
