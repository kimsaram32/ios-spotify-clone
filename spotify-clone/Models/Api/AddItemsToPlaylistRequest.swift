import Foundation

struct AddItemsToPlaylistRequest: Codable {
    
    var position: Int? = nil
    let uris: [String]
    
}
