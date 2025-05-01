import Foundation

struct NewReleasesResponse: Codable {
    
    let albums: ItemsResponse<Album>
    
}
