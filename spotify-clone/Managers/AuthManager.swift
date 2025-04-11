import Foundation

final class AuthManager {
    
    static let shared = AuthManager()
    
    struct Constants {
        static let clientId = "a2c54b7c247d4bc78f9a56a578abdff1"
        static let clientSecret = "2380a55fcb7349ada857af19a560803f"
        static let redirectUri = "https://example.com"
        static let scopes = ["user-read-private", "user-library-read"].joined(separator: " ")
    }
    
    private init() {}
    
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
    
    private var accessToken: String? {
        get {
            UserDefaults.standard.string(forKey: "accessToken")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "accessToken")
        }
    }
    
    private var refreshToken: String? {
        get {
            UserDefaults.standard.string(forKey: "accessToken")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "accessToken")
        }
    }
    
    private var tokenExpirationDate: Date? {
        get {
            UserDefaults.standard.object(forKey: "expirationDate") as? Date
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "expirationDate")
        }
    }
    
    private var shouldRefreshToken: Bool {
        guard let tokenExpirationDate else { return false }
        return Date().compare(tokenExpirationDate) == .orderedDescending
    }
    
    var isSignedIn: Bool {
        accessToken != nil && !shouldRefreshToken
    }
    
    func exchangeCodeForToken(
        code: String,
        completion: @escaping ((Bool) -> Void)
    ) {
        guard var requestUrlComponents = URLComponents(string: "https://accounts.spotify.com/api/token") else {
            completion(false)
            return
        }
        requestUrlComponents.queryItems = [
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectUri),
        ]
        
        guard let url = requestUrlComponents.url else {
            completion(false)
            return
        }
        
        let basicToken = Constants.clientId + ":" + Constants.clientSecret
        guard let encodedBasicToken = basicToken.data(using: .utf8)?.base64EncodedString() else {
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Basic \(encodedBasicToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { data, _, error in
            guard let data, error == nil else {
                completion(false)
                return
            }
            
            do {
                let response = try JSONDecoder().decode(AuthResponse.self, from: data)
                self.accessToken = response.access_token
                self.refreshToken = response.refresh_token
                self.tokenExpirationDate = Date(timeIntervalSinceNow: TimeInterval(response.expires_in))
                completion(true)
            } catch {
                print(error.localizedDescription)
                completion(false)
            }
        })
        task.resume()
    }
    
    func refreshAccessTokenIfNeeded(completion: ((Bool) -> Void)? = nil) {
        guard shouldRefreshToken else {
            completion?(true)
            return
        }
        
        guard var requestUrlComponents = URLComponents(string: "https://accounts.spotify.com/api/token") else {
            completion?(false)
            return
        }
        requestUrlComponents.queryItems = [
            URLQueryItem(name: "grant_type", value: "refresh_token"),
            URLQueryItem(name: "refresh_token", value: refreshToken),
            URLQueryItem(name: "client_id", value: Constants.clientId),
        ]
        
        guard let url = requestUrlComponents.url else {
            completion?(false)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { data, _, error in
            guard let data, error == nil else {
                completion?(false)
                return
            }
            
            do {
                let response = try JSONDecoder().decode(AuthResponse.self, from: data)
                self.accessToken = response.access_token
                self.refreshToken = response.refresh_token
                self.tokenExpirationDate = Date(timeIntervalSinceNow: TimeInterval(response.expires_in))
                completion?(true)
            } catch {
                print(error.localizedDescription)
                completion?(false)
            }
        })
        task.resume()
    }
    
    
}
