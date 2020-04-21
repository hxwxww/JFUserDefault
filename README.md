# JFUserDefault
A simple way to use UserDefaults

Import:
```
pod 'JFUserDefault'
```
Use Keys:

```
extension UserDefaults.Keys {
    
    static let isFirstLaunch = UserDefaults.Key<Bool>("isFirstLaunch")
    static let firstLaunchDate = UserDefaults.Key<Date>("firstLaunchDate")
    static let currentUser = UserDefaults.Key<User?>("currentUser")
}

@UserDefault(.isFirstLaunch, defaultValue: true)
var isFirstLaunch: Bool

@UserDefault(.firstLaunchDate, defaultValue: Date())
var firstLaunchDate: Date

@UserDefault(.currentUser)
var currentUser: User?
```
Use StringLiteral:
```
@UserDefault("homePageUrl")
var homePageUrl: URL?

@UserDefault("followerCount", defaultValue: 0)
var followerCount: Int

@UserDefault("followers", defaultValue: [])
var followers: [User]

@UserDefault("userFollows", defaultValue: [:])
var userFollows: [String: User]
```
