import Foundation

struct PlaylistDetailsResponse: Codable {
    
    let tracks: ItemsResponse<PlaylistDetailsTrack>
    
}
