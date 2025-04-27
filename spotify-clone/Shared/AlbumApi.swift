import Foundation

final class AlbumApi: BaseApi {
    
    static let shared = AlbumApi()
    
    private override init() {}
    
    func getNewReleases() async throws -> [Album] {
        let url = URL(string: "https://api.spotify.com/v1/browse/new-releases")!
        guard let request = await createAuthorizedURLRequest(url: url) else {
            throw ApiError.unAuthorized
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            let httpResponse = response as! HTTPURLResponse
            guard httpResponse.statusCode == 200 else {
                throw ApiError.requestFailed
            }
            
            let newReleasesResponse = try JSONDecoder().decode(NewReleasesResponse.self, from: data)
            return newReleasesResponse.albums.items
        } catch {
            throw ApiError.requestFailed
        }
    }

    
}
