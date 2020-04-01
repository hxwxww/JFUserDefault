//
//  UserDefaultSerializable.swift
//  UserDefault
//
//  Created by HongXiangWen on 2020/3/11.
//  Copyright © 2020 WHX. All rights reserved.
//

import Foundation

public protocol UserDefaultSerializable {
    
    associatedtype B: UserDefaultBridge
    
    static var bridge: B { get }
}

extension String: UserDefaultSerializable {
    
    public static var bridge: UserDefaultStringBridge {
        return UserDefaultStringBridge()
    }
}

extension Int: UserDefaultSerializable {
    
    public static var bridge: UserDefaultIntBridge {
        return UserDefaultIntBridge()
    }
}

extension Double: UserDefaultSerializable {
    
    public static var bridge: UserDefaultDoubleBridge {
        return UserDefaultDoubleBridge()
    }
}

extension Float: UserDefaultSerializable {
    
    public static var bridge: UserDefaultFloatBridge {
        return UserDefaultFloatBridge()
    }
}

extension Bool: UserDefaultSerializable {
    
    public static var bridge: UserDefaultBoolBridge {
        return UserDefaultBoolBridge()
    }
}

extension URL: UserDefaultSerializable {
    
    public static var bridge: UserDefaultUrlBridge {
        return UserDefaultUrlBridge()
    }
}

extension Data: UserDefaultSerializable {
    
    public static var bridge: UserDefaultDataBridge {
        return UserDefaultDataBridge()
    }
}

extension Date: UserDefaultSerializable {
    
    public static var bridge: UserDefaultObjectBridge<Date> {
        return UserDefaultObjectBridge()
    }
}

extension UserDefaultSerializable where Self: RawRepresentable {

    public static var bridge: UserDefaultRawRepresentableBridge<Self> {
        return UserDefaultRawRepresentableBridge()
    }
}

extension UserDefaultSerializable where Self: Codable {

    public static var bridge: UserDefaultCodableBridge<Self> {
        return UserDefaultCodableBridge()
    }
    
}

extension Array: UserDefaultSerializable where Element: UserDefaultSerializable, Element.B.T == Element {
    
    public static var bridge: UserDefaultArrayBridge<Array> {
        return UserDefaultArrayBridge()
    }
}

extension Dictionary: UserDefaultSerializable where Key == String, Value: UserDefaultSerializable, Value.B.T == Value {
        
    public static var bridge: UserDefaultDictionaryBridge<Value> {
        return UserDefaultDictionaryBridge()
    }
}

extension Optional: UserDefaultSerializable where Wrapped: UserDefaultSerializable, Wrapped.B.T == Wrapped {
    
    public static var bridge: UserDefaultOptionalBridge<Wrapped> {
        return UserDefaultOptionalBridge()
    }
}
