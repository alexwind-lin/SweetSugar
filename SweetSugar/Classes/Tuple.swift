//
//  Tuple.swift
//  SweetSugar
//
//  Created by kensou on 2021/6/6.
//

import Foundation

public typealias SomeTuple = Any

public extension Array {
    var tupleValue: SomeTuple {
        switch self.count {
        case 2:
            return (self[0], self[1])
        case 3:
            return (self[0], self[1], self[2])
        default:
            fatalError("We don't support array with count \(self.count)")
        }
    }
}

public extension Dictionary where Key == String, Value: Any {
    func getTupleValue<T: SomeTuple>() throws -> T {
        let keyList = getKeyList(from: T.self)
        var result: [Any?] = []
        for key in keyList {
            let value = self[key]
            if value is NSNull {
                result.append(nil)
            } else {
                result.append(value)
            }
        }
        let tuple = result.tupleValue
        guard let object = tuple as? T else {
            let context: DecodingError.Context = .init(codingPath: [], debugDescription: "\(tuple) can not convert to type \(T.self)")
            throw DecodingError.typeMismatch(T.self, context)
        }
        return object
    }
}

/**
 *  get keys from a tuple
 *  like: getKeyList(from: (name: String, age: Int)
 *  you will get ["name", "age"]
 */
fileprivate func getKeyList(from tupleType: SomeTuple.Type) -> [String] {
    var rawType = tupleType
    if let optionalType = tupleType as? AnyOptional.Type {
        rawType = optionalType.wrappedType
    }
    let desc = String(describing: rawType)
    let elements = desc.split(maxSplits: 3, omittingEmptySubsequences: true) { "(,:) ".contains($0) }
    var result: [String] = []
    for i in 0..<elements.count / 2 {
        result.append(String(elements[i * 2]))
    }
    return result
}
