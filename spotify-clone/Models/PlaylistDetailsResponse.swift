import Foundation

struct PlaylistDetailsTrack: Codable {
    
    let addedAt: Date
    let track: Track
    
    enum CodingKeys: String, CodingKey {
        
        case addedAt = "added_at"
        case track
        
    }
    
}

struct PlaylistDetailsTracks: Codable {
    
    let items: [PlaylistDetailsTrack]
    
}

struct PlaylistDetailsResponse: Codable {
    
    let tracks: PlaylistDetailsTracks
    
}
