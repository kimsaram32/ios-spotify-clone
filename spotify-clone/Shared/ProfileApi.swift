import Foundation

final class ProfileApi {
    
    static let shared = ProfileApi()
    
    private init() {}
    
    private func fetchValidAccessToken() async -> String? {
        if AuthData.shared.shouldRefreshToken {
            let result = try? await AuthApi.shared.refreshAccessTokenIfNeeded()
        }
        return AuthData.shared.accessToken
    }
    
    func getCurrentUserProfile() async throws -> UserProfile {
        guard let token = await fetchValidAccessToken() else {
            throw ApiError.unAuthorized
        }
        
        let url = URL(string: "https://api.spotify.com/v1/me")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            let httpResponse = response as! HTTPURLResponse
            guard httpResponse.statusCode == 200 else {
                throw ApiError.requestFailed
            }
            
            let profile = try JSONDecoder().decode(UserProfile.self, from: data)
            return profile
        } catch {
            throw ApiError.requestFailed
        }
    }
    
    
}
