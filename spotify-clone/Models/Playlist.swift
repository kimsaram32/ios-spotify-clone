import Foundation

struct PlaylistTracks: Codable {
    
    let count: Int
    
    enum CodingKeys: String, CodingKey {
        
        case count = "total"
        
    }
    
}

struct Playlist: Codable {
    
    let id: String
    let isCollaborative: Bool
    let description: String
    let images: [APIImage]
    let name: String
    let isPublic: Bool
    let tracks: PlaylistTracks
    
    enum CodingKeys: String, CodingKey {
        
        case id
        case isCollaborative = "collaborative"
        case description
        case images
        case name
        case isPublic = "public"
        case tracks
        
    }
    
}
