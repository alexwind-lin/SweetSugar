//
//  Codable.swift
//
//  Created on 2021/4/4.
//

import Foundation

public extension Encodable {
    // Encodable作为对象传递进来时，可以直接用toJSONData进行序列化，避免掉不知道类型无法encode的问题
    func toJSONData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
}

public extension Decodable {
    // 泛型传递的时候，可以通过这个方式，解决不知道具体类型无法decode的问题
    init(jsonData: Data) throws {
        self = try JSONDecoder().decode(Self.self, from: jsonData)
    }
    
    
    /**
     * 如果泛型传递的时候，不确定T是不是Codable的时候，可以这么做
     *
     if let decodableType = T.self as? Decodable.Type {
     self.data = try decodableType.init(container: container, key: .data) as? T
     } else {
        // Something Else
     }
     *
     */
    init<Key: CodingKey>(container: KeyedDecodingContainer<Key>, key: KeyedDecodingContainer<Key>.Key) throws {
        self = try container.decode(Self.self, forKey: key)
    }
    
    init(container: SingleValueDecodingContainer) throws {
        self = try container.decode(Self.self)
    }
}
