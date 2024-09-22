//
//  CodableDict.swift
//  SweetSugar
//
//  Created on 2024/9/19.
//

import Foundation

public struct CodableDict: Codable {
    public let dict: [String: Any]
    
    public init(dict: [String: Any]) {
        self.dict = dict
    }
    
    public init(from decoder: any Decoder) throws {
        let keyedContainer = try decoder.container(keyedBy: JSONCodingKeys.self)
        let context: CoderContext = .init(skipNull: decoder.shouldSkipNullInDict)
        let dict: [String: Any] = try keyedContainer.decode([String: Any].self, context: context)
        self.dict = dict
    }
    
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: JSONCodingKeys.self)
        let context: CoderContext = .init(skipNull: encoder.shouldSkipNullInDict)
        try container.encode(dict, context: context)
    }
}

// MARK: - Null解析的设置

extension CodingUserInfoKey {
    static var skipNullInDictKey: CodingUserInfoKey! = .init(rawValue: #function)
}
extension Decoder {
    // 默认是true
    public var shouldSkipNullInDict: Bool {
        guard let value = self.userInfo[.skipNullInDictKey] as? Bool else {
            return true
        }
        return value
    }
}

extension Encoder {
    // 默认是true
    public var shouldSkipNullInDict: Bool {
        guard let value = self.userInfo[.skipNullInDictKey] as? Bool else {
            return true
        }
        return value
    }
}

extension JSONDecoder {
    // 是否要跳过null， true: 不解析null, false: 将null解析成NSNull
    public func setSkipNullInDict(_ skip: Bool) -> Self {
        self.userInfo[.skipNullInDictKey] = skip
        return self
    }
}

extension JSONEncoder {
    // 是否要跳过null， true: 不解析null, false: 将null解析成NSNull
    public func setSkipNullInDict(_ skip: Bool) -> Self {
        self.userInfo[.skipNullInDictKey] = skip
        return self
    }
}
