import Foundation

struct UserProfile: Codable {
    
    let country: String
    let displayName: String?
    let email: String
    let id: String
    let images: [APIImage]
    let product: String
    
    enum CodingKeys: String, CodingKey {
        case country
        case displayName = "display_name"
        case email
        case id
        case images
        case product
    }
    
    
}
