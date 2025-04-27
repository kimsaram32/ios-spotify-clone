import Foundation

struct Track: Codable {
    
    let id: String
    let album: Album
    let artists: [Artist]
    let availableMarkets: [String]
    let discNumber: Int
    let duration: Int
    let isExplicitLyrics: Bool
    let isPlayable: Bool
    let restrictions: Restriction?
    let name: String
    let previewURL: URL?
    let popularity: Int
    let trackNumber: Int
    let isLocal: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case album
        case artists
        case availableMarkets = "available_markets"
        case discNumber = "disc_number"
        case duration = "duration_ms"
        case isExplicitLyrics = "explicit"
        case isPlayable = "is_playable"
        case restrictions
        case name
        case previewURL = "preview_url"
        case popularity
        case trackNumber = "track_number"
        case isLocal = "is_local"
    }
    
}
