import UIKit

final class Formatter {
    
    static let shared = Formatter()
    
    private init() {}
    
    let defaultArtworkURL = URL(string: "https://placehold.co/300x300?text=Empty")!

    func formatArtistName(artists: [Artist]) -> String {
        artists.count > 0 ? artists.map { $0.name }.joined(separator: ",") : "-"
    }
    
    func getArtworkImageSource(with images: [APIImage]?) -> ImageSource {
        if let url = images?.first?.url {
            return url
        }
        return UIImage(systemName: "photo")!
    }

}
