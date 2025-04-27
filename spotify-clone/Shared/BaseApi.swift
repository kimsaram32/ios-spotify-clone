import Foundation

class BaseApi {
    
    private func fetchValidAccessToken() async -> String? {
        if AuthData.shared.shouldRefreshToken {
            let _ = try? await AuthApi.shared.refreshAccessTokenIfNeeded()
        }
        return AuthData.shared.accessToken
    }
    
    func createAuthorizedURLRequest(url: URL) async -> URLRequest? {
        guard let token = await fetchValidAccessToken() else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
}
