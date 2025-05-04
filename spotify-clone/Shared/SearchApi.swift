import Foundation

class SearchApi: BaseApi {
    
    static let shared = SearchApi()
    
    private override init() {}
    
    func search(query: String) async throws -> SearchResult {
        var urlComponents = URLComponents(string: "https://api.spotify.com/v1/search")!
        urlComponents.queryItems = [
            URLQueryItem(name: "q", value: query),
            URLQueryItem(
                name: "type",
                value: ["album", "artist", "playlist", "track"].joined(separator: ",")
            )
        ]
        
        guard let request = await createAuthorizedURLRequest(url: urlComponents.url!) else {
            throw ApiError.unAuthorized
        }
        do {
            let (rawData, _) = try await URLSession.shared.data(for: request)
            let data = try JSONDecoder().decode(SearchResponse.self, from: rawData)
            return SearchResult(
                albums: data.albums?.items.compactMap{ $0 },
                artists: data.artists?.items.compactMap{ $0 },
                playlists: data.playlists?.items.compactMap{ $0 },
                tracks: data.tracks?.items.compactMap{ $0 }, // remove nil values
            )
        } catch {
            print(error)
            throw ApiError.requestFailed
        }
    }
    
    
}
