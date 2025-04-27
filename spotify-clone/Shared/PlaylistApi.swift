import Foundation

final class PlaylistApi: BaseApi {
    
    static let shared = PlaylistApi()
    
    private override init() {}
    
    // spotify shut down featured playlists api so using get current user's playlists api instead
    func getFeaturedPlaylists() async throws -> [Playlist] {
        do {
            let url = URL(string: "https://api.spotify.com/v1/me/playlists")!
            guard let request = await createAuthorizedURLRequest(url: url) else {
                throw ApiError.unAuthorized
            }
            let (rawData, _) = try await URLSession.shared.data(for: request)
            let data = try JSONDecoder().decode(CurrentUserPlaylistsResponse.self, from: rawData)
            return data.items
        } catch {
            throw ApiError.requestFailed
        }
    }
    

}
