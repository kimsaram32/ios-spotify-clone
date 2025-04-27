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
            "user-read-email",
            "user-top-read",
            "playlist-read-private",
        ].joined(separator: " ")
    }
    
    private init() {}
    
    private var isRefreshing = false
    
    private let authorizationHeader: String = {
        let basicToken = Constants.clientId + ":" + Constants.clientSecret
        let encodedBasicToken = basicToken.data(using: .utf8)!.base64EncodedString()
        return "Basic \(encodedBasicToken)"
    }()
    
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
        
        let url = requestUrlComponents.url!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(authorizationHeader, forHTTPHeaderField: "Authorization")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let response = try JSONDecoder().decode(AuthResponse.self, from: data)
            AuthData.shared.accessToken = response.access_token
            AuthData.shared.refreshToken = response.refresh_token
            AuthData.shared.tokenExpirationDate = Date(timeIntervalSinceNow: TimeInterval(response.expires_in))
            print("exchange succeeded")
        } catch {
            print("failed to exchange...", error)
            throw ApiError.requestFailed
        }
    }
    
    private var refreshTask: Task<Void, any Error>?
    
    func refreshAccessTokenIfNeeded() async throws -> Result<Void, any Error> {
        guard AuthData.shared.shouldRefreshToken else {
            print("no need to refresh")
            return Result.success(())
        }
        
        if let refreshTask {
            return await refreshTask.result
        }
        
        refreshTask = Task {
            var requestUrlComponents = URLComponents(string: "https://accounts.spotify.com/api/token")!
            requestUrlComponents.queryItems = [
                URLQueryItem(name: "grant_type", value: "refresh_token"),
                URLQueryItem(name: "refresh_token", value: AuthData.shared.refreshToken),
                URLQueryItem(name: "client_id", value: Constants.clientId),
            ]
            
            guard let url = requestUrlComponents.url else {
                throw ApiError.requestFailed
            }
            print("request url is ", url.absoluteString)
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue(authorizationHeader, forHTTPHeaderField: "Authorization")
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            
            do {
                let (data, _) = try await URLSession.shared.data(for: request)
                print("data is", (try? JSONSerialization.jsonObject(with: data)) as Any)
                let authResponse = try JSONDecoder().decode(AuthResponse.self, from: data)
                
                print("refresh succeeded")
                AuthData.shared.accessToken = authResponse.access_token
                AuthData.shared.tokenExpirationDate = Date(timeIntervalSinceNow: TimeInterval(authResponse.expires_in))
            } catch { // refresh token is invalid
                print("refreshing failed", error)
                AuthData.shared.accessToken = nil
                AuthData.shared.refreshToken = nil
                AuthData.shared.tokenExpirationDate = nil
            }
        }
        
        return await refreshTask!.result
    }
    
    
}
