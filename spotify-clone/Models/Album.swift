import Foundation

enum AlbumType: String, Codable {
    
    case album = "album"
    case single = "single"
    case compilation = "compilation"
    
}

enum AlbumReleaseDatePrecision: String, Codable {
    
    case year = "year"
    case month = "month"
    case day = "day"
    
}

struct Album: Codable {
    
    let albumType: AlbumType
    let totalTracks: Int
    let availableMarkets: [String]
    let id: String
    let images: [APIImage]
    let name: String
    let releaseDate: String
    let releaseDatePrecision: AlbumReleaseDatePrecision
    let restriction: Restriction?
    let artists: [Artist]
    
    enum CodingKeys: String, CodingKey {
        
        case albumType = "album_type"
        case totalTracks = "total_tracks"
        case availableMarkets = "available_markets"
        case id
        case images
        case name
        case releaseDate = "release_date"
        case releaseDatePrecision = "release_date_precision"
        case restriction
        case artists
        
    }

}
