//
//  UserDefaultBridge.swift
//  UserDefault
//
//  Created by HongXiangWen on 2020/3/11.
//  Copyright © 2020 WHX. All rights reserved.
//

import Foundation

public protocol UserDefaultBridge {
    
    associatedtype T
    
    /// 从UserDefaults中取出存储的值
    func value(forKey key: String) -> T?
    
    /// UserDefaults保存新值
    func save(_ object: T?, forKey key: String)
    
    /// 将UserDefaults的值反序列化为目标类型
    func deserialize(_ object: Any?) -> T?
    
    /// 将想要存储的值序列化为UserDefaults可存储的类型的值
    func serialize(_ object: T?) -> Any?
}

extension UserDefaultBridge {
    
    public func deserialize(_ object: Any?) -> T? {
        return object as? T
    }
    
    public func serialize(_ object: T?) -> Any? {
        return object
    }
}

public struct UserDefaultObjectBridge<T>: UserDefaultBridge {
    
    public func value(forKey key: String) -> T? {
        return userDefaults.object(forKey: key) as? T
    }
    
    public func save(_ object: T?, forKey key: String) {
        userDefaults.set(object, forKey: key)
    }
}

public struct UserDefaultStringBridge: UserDefaultBridge {

    public typealias T = String
    
    public func value(forKey key: String) -> String? {
        return userDefaults.string(forKey: key)
    }
    
    public func save(_ object: String?, forKey key: String) {
        userDefaults.set(object, forKey: key)
    }
}

public struct UserDefaultIntBridge: UserDefaultBridge {
    
    public typealias T = Int
    
    public func value(forKey key: String) -> Int? {
        return userDefaults.number(forKey: key)?.intValue
    }
    
    public func save(_ object: Int?, forKey key: String) {
        userDefaults.set(object, forKey: key)
    }
}

public struct UserDefaultDoubleBridge: UserDefaultBridge {

    public typealias T = Double

    public func value(forKey key: String) -> Double? {
        return userDefaults.number(forKey: key)?.doubleValue
    }
    
    public func save(_ object: Double?, forKey key: String) {
        userDefaults.set(object, forKey: key)
    }
}

public struct UserDefaultFloatBridge: UserDefaultBridge {

    public typealias T = Float

    public func value(forKey key: String) -> Float? {
        return userDefaults.number(forKey: key)?.floatValue
    }
    public func save(_ object: Float?, forKey key: String) {
        userDefaults.set(object, forKey: key)
    }
}

public struct UserDefaultBoolBridge: UserDefaultBridge {

    public typealias T = Bool

    public func value(forKey key: String) -> Bool? {
        return userDefaults.number(forKey: key)?.boolValue
    }
    
    public func save(_ object: Bool?, forKey key: String) {
        userDefaults.set(object, forKey: key)
    }
}

public struct UserDefaultUrlBridge: UserDefaultBridge {

    public typealias T = URL

    public func value(forKey key: String) -> URL? {
        return userDefaults.url(forKey: key)
    }
    
    public func save(_ object: URL?, forKey key: String) {
        userDefaults.set(object, forKey: key)
    }
    
    public func deserialize(_ object: Any?) -> URL? {
        if let object = object as? URL {
            return object
        }
        if let object = object as? Data {
            return NSKeyedUnarchiver.unarchiveObject(with: object) as? URL
        }
        if let object = object as? NSString {
            let path = object.expandingTildeInPath
            return URL(fileURLWithPath: path)
        }
        return nil
    }
    
    public func serialize(_ object: URL?) -> Any? {
        guard let object = object else { return nil }
        return NSKeyedArchiver.archivedData(withRootObject: object)
    }
}

public struct UserDefaultDataBridge: UserDefaultBridge {

    public typealias T = Data

    public func value(forKey key: String) -> Data? {
        return userDefaults.data(forKey: key)
    }
    
    public func save(_ object: Data?, forKey key: String) {
        userDefaults.set(object, forKey: key)
    }
}

public struct UserDefaultRawRepresentableBridge<T: RawRepresentable>: UserDefaultBridge {
    
    public func value(forKey key: String) -> T? {
        return deserialize(userDefaults.object(forKey: key))
    }
    
    public func save(_ object: T?, forKey key: String) {
        userDefaults.set(serialize(object), forKey: key)
    }
    
    public func deserialize(_ object: Any?) -> T? {
        guard let rawobject = object as? T.RawValue else { return nil }
        return T(rawValue: rawobject)
    }
    
    public func serialize(_ object: T?) -> Any? {
        return object?.rawValue
    }
}

public struct UserDefaultCodableBridge<T: Codable>: UserDefaultBridge {
    
    public func value(forKey key: String) -> T? {
        return deserialize(userDefaults.data(forKey: key))
    }
    
    public func save(_ object: T?, forKey key: String) {
        userDefaults.set(serialize(object), forKey: key)
    }
    
    public func deserialize(_ object: Any?) -> T? {
        guard let data = object as? Data else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }
    
    public func serialize(_ object: T?) -> Any? {
        return try? JSONEncoder().encode(object)
    }
}

public struct UserDefaultArrayBridge<T: Collection>: UserDefaultBridge where T.Element: UserDefaultSerializable, T.Element.B.T == T.Element {

    public func value(forKey key: String) -> T? {
        return deserialize(userDefaults.array(forKey: key))
    }
    
    public func save(_ object: T?, forKey key: String) {
        userDefaults.set(serialize(object), forKey: key)
    }
      
    public func deserialize(_ object: Any?) -> T? {
        guard let array = object as? [Any] else { return nil }
        return array.compactMap { T.Element.bridge.deserialize($0) } as? T
    }
    
    public func serialize(_ object: T?) -> Any? {
        return object?.compactMap { T.Element.bridge.serialize($0) }
    }
}

public struct UserDefaultDictionaryBridge<Value: UserDefaultSerializable>: UserDefaultBridge where Value.B.T == Value {

    public typealias T = [String: Value]
        
    public func value(forKey key: String) -> [String : Value]? {
        return deserialize(userDefaults.dictionary(forKey: key))
    }
    
    public func save(_ object: T?, forKey key: String) {
        userDefaults.set(serialize(object), forKey: key)
    }
      
    public func deserialize(_ object: Any?) -> [String : Value]? {
        guard let dict = object as? [String: Any] else { return nil }
        var result: [String: Value] = [:]
        for element in dict {
            result[element.key] = Value.bridge.deserialize(element.value)
        }
        return result
    }
    
    public func serialize(_ object: [String: Value]?) -> Any? {
        guard let dict = object else { return nil }
        var result: [String: Any] = [:]
        for element in dict {
            result[element.key] = Value.bridge.serialize(element.value)
        }
        return result
    }
}

public struct UserDefaultOptionalBridge<Value: UserDefaultSerializable>: UserDefaultBridge where Value.B.T == Value {

    public typealias T = Optional<Value>
    
    public func value(forKey key: String) -> Optional<Value>? {
        return deserialize(userDefaults.object(forKey: key))
    }
    
    public func save(_ object: Optional<Value>?, forKey key: String) {
        userDefaults.set(serialize(object), forKey: key)
    }
    
    public func deserialize(_ object: Any?) -> Optional<Value>? {
        return Value.bridge.deserialize(object)
    }
    
    public func serialize(_ object: Optional<Value>?) -> Any? {
        switch object {
        case .some(let value):
            return Value.bridge.serialize(value)
        case .none:
            return nil
        }
    }
}
