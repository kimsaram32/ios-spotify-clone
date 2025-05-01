import Foundation

struct Playlist: Codable {
    
    let id: String
    let isCollaborative: Bool
    let description: String
    let images: [APIImage]
    let name: String
    let isPublic: Bool
    let owner: PlaylistOwner
    let tracks: PlaylistTracks
    
    enum CodingKeys: String, CodingKey {
        
        case id
        case isCollaborative = "collaborative"
        case description
        case images
        case name
        case isPublic = "public"
        case owner
        case tracks
        
    }
    
}
