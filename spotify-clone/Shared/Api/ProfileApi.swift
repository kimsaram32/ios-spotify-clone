import Foundation

final class ProfileApi: BaseApi {
    
    static let shared = ProfileApi()
    
    private override init() {}
    
    func getCurrentUserProfile() async throws -> UserProfile {
        let url = URL(string: "https://api.spotify.com/v1/me")!
        guard let request = await createAuthorizedURLRequest(url: url) else {
            throw ApiError.requestFailed
        }
        
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
