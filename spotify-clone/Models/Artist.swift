import Foundation

struct Artist: Codable {
    
    let id: String
    let name: String
    let images: [APIImage]?
    
    
}
