import Foundation

final class AuthApi {
    
    static let shared = AuthApi()
    
    struct Constants {
        static let clientId = "a2c54b7c247d4bc78f9a56a578abdff1"
        static let clientSecret = "2380a55fcb7349ada857af19a560803f"
        static let redirectUri = "https://example.com"
        static let scopes = [
            "user-read-private",
            "user-library-read",
            "user-read-email"
        ].joined(separator: " ")
    }
    
    private init() {}
    
    private var isRefreshing = false
    private var refreshCompletionHandlers = [(String) -> Void]()
    
    let signInURL: URL = {
        var urlComponents = URLComponents(string: "https://accounts.spotify.com/authorize")!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.clientId),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectUri),
            URLQueryItem(name: "scope", value: Constants.scopes),
            URLQueryItem(name: "show_dialog", value: "TRUE")
        ]
        return urlComponents.url!
    }()
    
    func exchangeCodeForToken(code: String) async throws {
        var requestUrlComponents = URLComponents(string: "https://accounts.spotify.com/api/token")!
        
        requestUrlComponents.queryItems = [
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectUri),
        ]
        
        guard let url = requestUrlComponents.url else {
            throw ApiError.requestFailed
        }
        let basicToken = Constants.clientId + ":" + Constants.clientSecret
        guard let encodedBasicToken = basicToken.data(using: .utf8)?.base64EncodedString() else {
            throw ApiError.requestFailed
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Basic \(encodedBasicToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let response = try JSONDecoder().decode(AuthResponse.self, from: data)
            AuthData.shared.accessToken = response.access_token
            AuthData.shared.refreshToken = response.refresh_token
            AuthData.shared.tokenExpirationDate = Date(timeIntervalSinceNow: TimeInterval(response.expires_in))
        } catch {
            throw ApiError.requestFailed
        }
    }
    
    func refreshAccessTokenIfNeeded() async throws {
        guard AuthData.shared.shouldRefreshToken else {
            return
        }
        
        var requestUrlComponents = URLComponents(string: "https://accounts.spotify.com/api/token")!
        requestUrlComponents.queryItems = [
            URLQueryItem(name: "grant_type", value: "refresh_token"),
            URLQueryItem(name: "refresh_token", value: AuthData.shared.refreshToken),
            URLQueryItem(name: "client_id", value: Constants.clientId),
        ]
        
        guard let url = requestUrlComponents.url else {
            throw ApiError.requestFailed
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            let httpResponse = response as! HTTPURLResponse
            let authResponse = try JSONDecoder().decode(AuthResponse.self, from: data)
            
            AuthData.shared.accessToken = authResponse.access_token
            AuthData.shared.refreshToken = authResponse.refresh_token
            AuthData.shared.tokenExpirationDate = Date(timeIntervalSinceNow: TimeInterval(authResponse.expires_in))
        } catch {
            throw ApiError.requestFailed
        }
    }
    
    
}
