import Foundation

struct SearchResponse: Codable {
   
    let tracks: ItemsResponse<Track?>?
    let artists: ItemsResponse<Artist?>?
    let albums: ItemsResponse<Album?>?
    let playlists: ItemsResponse<Playlist?>?
    
}
