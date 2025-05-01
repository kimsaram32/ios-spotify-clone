import Foundation

struct PlaylistDetailsTrack: Codable {
    
    let addedAt: Date
    let track: Track
    
    enum CodingKeys: String, CodingKey {
        
        case addedAt = "added_at"
        case track
        
    }
    
}

