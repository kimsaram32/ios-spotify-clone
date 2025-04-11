import Foundation

final class AuthManager {
    
    static let shared = AuthManager()
    
    struct Constants {
        static let clientId = "a2c54b7c247d4bc78f9a56a578abdff1"
        static let clientSecret = "2380a55fcb7349ada857af19a560803f"
        static let redirectUri = "https://example.com"
    }
    
    private init() {}
    
    var signInURL: URL = {
        let scopes = "user-read-private"
        var urlComponents = URLComponents(string: "https://accounts.spotify.com/authorize")!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.clientId),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectUri),
            URLQueryItem(name: "scope", value: scopes),
            URLQueryItem(name: "show_dialog", value: "TRUE")
        ]
        return urlComponents.url!
    }()
    
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
    
    func exchangeCodeForToken(
        code: String,
        completion: @escaping ((Bool) -> Void)
    ) {
        
    }
    
    func refreshAccessToken() {
        
    }
    
    func cacheToken() {
        
    }
}
