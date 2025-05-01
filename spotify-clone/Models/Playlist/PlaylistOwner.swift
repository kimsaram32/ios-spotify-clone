import Foundation

struct PlaylistOwner: Codable {
   
    let id: String
    let displayName: String
    
    enum CodingKeys: String, CodingKey {
        
        case id
        case displayName = "display_name"
        
    }
    
}
