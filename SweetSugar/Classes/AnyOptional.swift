//
//  AnyOptional.swift
//  KSFootStone
//
//  Created by kensou on 2021/4/4.
//

import Foundation

// 在泛型化的时候，用AnyOptional可以用来判断传来的对象是不是Optional类型

public protocol AnyOptional {
    var isNil: Bool { get }
    var wrappedValue: Any { get }
}

extension Optional: AnyOptional {
    public var isNil: Bool { return self == nil }
    public var wrappedValue: Any { return self! }
}
