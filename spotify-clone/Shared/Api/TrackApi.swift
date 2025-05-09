import Foundation

final class TrackApi: BaseApi {
 
    static let shared = TrackApi()
    
    private override init() {}
    
    func getRecommendations() async throws -> [Track] {
        do {
            // spotify shut down recommendations API so using this one instead!!!1!!
            let url = URL(string: "https://api.spotify.com/v1/me/top/tracks")!
            guard let request = await createAuthorizedURLRequest(url: url) else {
                throw ApiError.unAuthorized
            }
            let (rawData, _) = try await URLSession.shared.data(for: request)
            let data = try JSONDecoder().decode(TopItemsResponse.self, from: rawData)
            return data.items
        } catch {
            print("error: ", error)
            throw ApiError.requestFailed
        }
    }
    
    
}
