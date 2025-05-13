import Foundation

final class PlaylistApi: BaseApi {
    
    static let shared = PlaylistApi()
    
    private override init() {}
    
    // spotify shut down featured playlists api so using get current user's playlists api instead
    func getFeaturedPlaylists() async throws -> [Playlist] {
        return try await getCurrentUserPlaylists()
    }
    
    func getCurrentUserPlaylists() async throws -> [Playlist] {
        let url = URL(string: "https://api.spotify.com/v1/me/playlists")!
        guard let request = await createAuthorizedURLRequest(url: url) else {
            throw ApiError.unAuthorized
        }
        do {
            let (rawData, _) = try await URLSession.shared.data(for: request)
            let data = try JSONDecoder().decode(CurrentUserPlaylistsResponse.self, from: rawData)
            return data.items
        } catch {
            throw ApiError.requestFailed
        }
    }
    
    func getPlaylistTracks(id: String) async throws -> [Track] {
        var urlComponents = URLComponents(string: "https://api.spotify.com/v1/playlists/\(id)")!
        urlComponents.queryItems = [
            URLQueryItem(name: "fields", value: "tracks.items"),
            URLQueryItem(name: "additional_types", value: "track"),
        ]
        guard let request = await createAuthorizedURLRequest(url: urlComponents.url!) else {
            throw ApiError.unAuthorized
        }
        do {
            let (rawData, _) = try await URLSession.shared.data(for: request)
            let decoder = JSONDecoder()
            
            decoder.dateDecodingStrategy = .iso8601
            let data = try decoder.decode(PlaylistDetailsResponse.self, from: rawData)
            return data.tracks?.items.map { $0.track } ?? []
        } catch {
            print(error)
            throw ApiError.requestFailed
        }
    }
    
    func createPlaylist(ofName name: String, for user: UserProfile? = nil) async throws -> Playlist {
        let targetUser: UserProfile
        if let user {
            targetUser = user
        } else {
            do {
                targetUser = try await ProfileApi.shared.getCurrentUserProfile()
            } catch {
                throw ApiError.requestFailed
            }
        }
        
        let requestBody = CreatePlaylistRequest(name: name)
        
        let url = URL(string: "https://api.spotify.com/v1/users/\(targetUser.id)/playlists")!
        guard var request = await createAuthorizedURLRequest(url: url) else {
            throw ApiError.unAuthorized
        }
        
        do {
            request.httpMethod = "POST"
            request.httpBody = try JSONEncoder().encode(requestBody)
            
            let (rawData, _) = try await URLSession.shared.data(for: request)
            let playlist = try JSONDecoder().decode(Playlist.self, from: rawData)
            return playlist
        } catch {
            print(error)
            throw ApiError.requestFailed
        }
    }
    
    func deletePlaylist(_ playlist: Playlist) async throws {
        let url = URL(string: "https://api.spotify.com/v1/playlists/\(playlist.id)/followers")!
        guard var request = await createAuthorizedURLRequest(url: url) else {
            throw ApiError.requestFailed
        }
        request.httpMethod = "DELETE"
        
        do {
            let _ = try await URLSession.shared.data(for: request)
        } catch {
            print(error)
            throw ApiError.requestFailed
        }
    }
    
    func addItemsToPlaylist(_ playlist: Playlist, tracks: [Track]) async throws {
        let url = URL(string: "https://api.spotify.com/v1/playlists/\(playlist.id)/tracks")!
        guard var request = await createAuthorizedURLRequest(url: url) else {
            throw ApiError.requestFailed
        }
        request.httpMethod = "POST"
        
        do {
            let requestBody = AddItemsToPlaylistRequest(uris: tracks.map { $0.uri })
            request.httpBody = try JSONEncoder().encode(requestBody)
            let _ = try await URLSession.shared.data(for: request)
        } catch {
            print(error)
            throw ApiError.requestFailed
        }
    }
    

}
