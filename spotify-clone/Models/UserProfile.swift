import Foundation

struct UserProfile: Codable {
    
    struct ExplicitContent: Codable {
        let filterEnabled: Bool
        let filterLocked: Bool
        
        enum CodingKeys: String, CodingKey {
            case filterEnabled = "filter_enabled"
            case filterLocked = "filter_locked"
        }
    }
    
    struct ExternalURLs: Codable {
        let spotify: String
    }
    
    struct Followers: Codable {
        let href: String?
        let total: Int
    }
    
    struct Image: Codable {
        let url: String
        let width: Int
        let height: Int
    }
    
    let country: String
    let displayName: String?
    let email: String
    let explicitContent: ExplicitContent
    let externalURLs: ExternalURLs
    let followers: Followers
    let id: String
    let images: [Image]
    let product: String
    
    enum CodingKeys: String, CodingKey {
        case country
        case displayName = "display_name"
        case email
        case explicitContent = "explicit_content"
        case externalURLs = "external_urls"
        case followers
        case id
        case images
        case product
    }
    
    
}
