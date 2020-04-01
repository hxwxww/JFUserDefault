//
//  ViewController.swift
//  JFUserDefaultExample
//
//  Created by HongXiangWen on 2020/4/1.
//  Copyright © 2020 WHX. All rights reserved.
//

import UIKit
import JFUserDefault

enum Gender: String, UserDefaultSerializable {
    case unknown
    case male
    case female
}

struct User: Codable, UserDefaultSerializable {
    
    var name: String
    var age: Int
    var gender: Gender
    
    enum CodingKeys: String, CodingKey {
        case name
        case age
        case gender
    }
    
    init(name: String, age: Int, gender: Gender = .unknown) {
        self.name = name
        self.age = age
        self.gender = gender
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        age = try container.decode(Int.self, forKey: .age)
        gender = try Gender(rawValue: container.decode(String.self, forKey: .gender)) ?? .unknown
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(age, forKey: .age)
        try container.encode(gender.rawValue, forKey: .gender)
    }
}

extension UserDefaults.Keys {
    
    static let isFirstLaunch = UserDefaults.Key<Bool>("isFirstLaunch")
    static let firstLaunchDate = UserDefaults.Key<Date>("firstLaunchDate")
    static let currentUser = UserDefaults.Key<User?>("currentUser")
}

class ViewController: UIViewController {

    // MARK: - Use Keys
    
    @UserDefault(.isFirstLaunch, defaultValue: true)
    var isFirstLaunch: Bool
    
    @UserDefault(.firstLaunchDate, defaultValue: Date())
    var firstLaunchDate: Date
    
    @UserDefault(.currentUser)
    var currentUser: User?
    
    // MARK: - Use StringLiteral
    
    @UserDefault("homePageUrl")
    var homePageUrl: URL?
    
    @UserDefault("followerCount", defaultValue: 0)
    var followerCount: Int
    
    @UserDefault("followers", defaultValue: [])
    var followers: [User]
    
    @UserDefault("userFollows", defaultValue: [:])
    var userFollows: [String: User]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isFirstLaunch {
            isFirstLaunch = false
            firstLaunchDate = Date()
        }
        printUserDefaults()
    }

    private func printUserDefaults() {
        print("isFirstLaunch: \(isFirstLaunch)")
        print("firstLaunchDate: \(firstLaunchDate)")
        print("currentUser: \(String(describing: currentUser))")
        print("homePageUrl: \(String(describing: homePageUrl))")
        print("followerCount: \(followerCount)")
        print("followers: \(followers)")
        print("userFollows: \(userFollows)")
    }
    
    @IBAction func addUser(_ sender: Any) {
        let user = User(name: "Zhsan", age: 12, gender: .male)
        currentUser = user
        followerCount += 1
        followers.append(user)
        userFollows = [user.name: user]
        homePageUrl = URL(string: "http://www.zhsan.com")
        
        printUserDefaults()
    }
    
}

