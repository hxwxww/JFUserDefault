//
//  UserDefault.swift
//  UserDefault
//
//  Created by HongXiangWen on 2020/3/11.
//  Copyright © 2020 WHX. All rights reserved.
//

import Foundation

#if swift(>=5.1)
@propertyWrapper
public struct UserDefault<T: UserDefaultSerializable> where T.B.T == T {
    
    private let key: UserDefaults.Key<T>
    private var defaultValue: T
    
    public init(_ key: UserDefaults.Key<T>, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    /// wrappedValue是@propertyWrapper必须要实现的属性
    /// 当操作我们要包裹的属性时  其具体set get方法实际上走的都是wrappedValue 的set get 方法
    public var wrappedValue: T {
        get {
            return userDefaults[key] ?? defaultValue
        }
        set {
            userDefaults[key] = newValue
        }
    }
}

extension UserDefault where T: ExpressibleByNilLiteral {
    
    public init(_ key: UserDefaults.Key<T>) {
        self.key = key
        self.defaultValue = nil
    }
}

#endif
