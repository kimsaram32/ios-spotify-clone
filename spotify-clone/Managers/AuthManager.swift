import Foundation

final class AuthManager {
    
    static let shared = AuthManager()
    
    private init() {}
    
    private var accessToken: String? {
        nil
    }
    
    private var refreshToken: String? {
        nil
    }
    
    private var tokenExpirationDate: Date? {
        nil
    }
    
    private var shouldRefreshToken: String? {
        nil
    }
    
    var isSignedIn: Bool {
        false
    }
}
