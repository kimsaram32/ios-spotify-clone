import Foundation

struct PlaylistTracks: Codable {
    
    let count: Int
    
    enum CodingKeys: String, CodingKey {
        
        case count = "total"
        
    }
    
}
