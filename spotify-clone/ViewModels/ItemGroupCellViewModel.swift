import Foundation

struct ItemGroupCellViewModel {
    
    struct CountConfiguration {
        let singularNoun: String
        let pluralNoun: String
        let count: Int
        
        static func tracks(of count: Int) -> CountConfiguration {
            CountConfiguration(singularNoun: "Track", pluralNoun: "Tracks", count: count)
        }
        
        static func items(of count: Int) -> CountConfiguration {
            CountConfiguration(singularNoun: "Item", pluralNoun: "Items", count: count)
        }
        
        var text: String {
            "\(count) \(count == 1 ? singularNoun : pluralNoun)"
        }
    }
    
    let title: String
    var subtitle: String = ""
    let image: ImageSource
    var itemsCount: CountConfiguration? = nil
    
}
