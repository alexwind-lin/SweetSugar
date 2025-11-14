//
//  AnyOptional.swift
//
//  Created on 2021/4/4.
//

import Foundation

// 在泛型化的时候，用AnyOptional可以用来判断传来的对象是不是Optional类型

public protocol AnyOptional {
    var isNil: Bool { get }
    var wrappedValue: Any { get }
    static var wrappedType: Any.Type { get }
    static var wrappedNonOptionalType: Any.Type { get }
}

extension Optional: AnyOptional {
    public var isNil: Bool { return self == nil }
    public var wrappedValue: Any { return self! }
    public static var wrappedType: Any.Type { return Wrapped.self }
    public static var wrappedNonOptionalType: Any.Type {
        var value: Any = self.wrappedType
        while let optional = value as? AnyOptional {
            value = optional.wrappedValue
        }
        return value as! Any.Type
    }
}
