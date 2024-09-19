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
        let dict: [String: Any] = try keyedContainer.decode([String: Any].self)
        self.dict = dict
    }
    
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: JSONCodingKeys.self)
        try container.encode(dict)
    }
}

