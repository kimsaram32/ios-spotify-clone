import Foundation

final class AuthData {
    
    static let shared = AuthData()
    
    var accessToken: String? {
        get {
            UserDefaults.standard.string(forKey: "accessToken")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "accessToken")
        }
    }
    
    var refreshToken: String? {
        get {
            UserDefaults.standard.string(forKey: "refreshToken")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "refreshToken")
        }
    }
    
    var tokenExpirationDate: Date? {
        get {
            UserDefaults.standard.object(forKey: "expirationDate") as? Date
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "expirationDate")
        }
    }
    
    var shouldRefreshToken: Bool {
        guard let tokenExpirationDate else { return false }
        return Date().compare(tokenExpirationDate) == .orderedDescending
    }
    
    var isSignedIn: Bool {
        accessToken != nil && !shouldRefreshToken
    }
    
    
}
