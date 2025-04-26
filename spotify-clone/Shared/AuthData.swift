import Foundation

final class AuthData {
    
    static let shared = AuthData()
    
    var accessToken: String? {
        get {
            UserDefaults.standard.string(forKey: "accessToken")
        }
        set {
            UserDefaults.standard.set(newValue as? NSString, forKey: "accessToken")
        }
    }
    
    var refreshToken: String? {
        get {
            UserDefaults.standard.string(forKey: "refreshToken")
        }
        set {
            UserDefaults.standard.set(newValue as? NSString, forKey: "refreshToken")
        }
    }
    
    var tokenExpirationDate: Date? {
        get {
            UserDefaults.standard.object(forKey: "expirationDate") as? Date
        }
        set {
            UserDefaults.standard.set(newValue as? NSDate, forKey: "expirationDate")
        }
    }
    
    var shouldRefreshToken: Bool {
        guard let tokenExpirationDate else { return false }
        return Date().compare(tokenExpirationDate) == .orderedDescending
    }
    
    var isSignedIn: Bool {
        accessToken != nil && !shouldRefreshToken
    }
    
    func clearData() {
        accessToken = nil
        refreshToken = nil
        tokenExpirationDate = nil
    }
    
    
}
