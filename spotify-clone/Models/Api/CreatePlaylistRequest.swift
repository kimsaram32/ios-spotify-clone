import Foundation

struct CreatePlaylistRequest: Codable {
    
    let name: String
    var description = ""
    var isPublic: Bool? = nil
    var isCollaborative: Bool? = nil
    
    enum CodingKeys: String, CodingKey {
        case name
        case description
        case isPublic = "public"
        case isCollaborative = "collaborative"
    }
    
}
