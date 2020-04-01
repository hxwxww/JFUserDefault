//
//  UserDefaults+Extension.swift
//  UserDefault
//
//  Created by HongXiangWen on 2020/3/11.
//  Copyright © 2020 WHX. All rights reserved.
//

import Foundation

let userDefaults = UserDefaults.standard

extension UserDefaults {
    
    /// key的基本类
    public class Keys: RawRepresentable, ExpressibleByStringLiteral {
        
        public let rawValue: String
        
        public required init!(rawValue: String) {
            self.rawValue = rawValue
        }
        
        public convenience init(_ key: String) {
            self.init(rawValue: key)
        }
        
        public required convenience init(stringLiteral value: String) {
            self.init(rawValue: value)
        }
    }
    
    /// 继承Keys，实际使用此类的实例， T为value的类型
    public final class Key<T: UserDefaultSerializable>: Keys where T.B.T == T { }
    
    /// 下标存取值
    public subscript<T>(key: Key<T>) -> T? {
        get {
            return value(forKey: key)
        }
        set {
            save(newValue, forKey: key)
        }
    }
    
    public func save<T>(_ value: T?, forKey key: Key<T>) {
        T.bridge.save(value, forKey: key.rawValue)
    }
    
    public func value<T>(forKey key: Key<T>) -> T? {
        return T.bridge.value(forKey: key.rawValue)
    }
    
    public func removeValue<T>(forKey key: Key<T>) {
        removeObject(forKey: key.rawValue)
    }
    
    public func removeAll() {
        for (key, _) in dictionaryRepresentation() {
            removeObject(forKey: key)
        }
    }
}

extension UserDefaults {

    func number(forKey key: String) -> NSNumber? {
        return object(forKey: key) as? NSNumber
    }
}
