import Foundation

struct ItemsResponse<T>: Codable where T: Codable {
    
    let items: [T]
    
}
