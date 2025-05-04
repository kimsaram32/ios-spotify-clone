import UIKit
import SDWebImage

class SearchResultTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "SearchResultTableViewCell"
    
    private var imageLoadOperation: SDWebImageOperation?
    
    func configure(with viewModel: SearchResultCellViewModel) {
        var contentConfiguration = defaultContentConfiguration()
        let imageSize = CGSize(width: 50, height: 50)
        
        contentConfiguration.text = viewModel.title
        contentConfiguration.textProperties.numberOfLines = 1
        
        contentConfiguration.secondaryText = viewModel.subtitle
        contentConfiguration.secondaryTextProperties.color = .secondaryLabel
        contentConfiguration.secondaryTextProperties.numberOfLines = 1
        
        contentConfiguration.imageProperties.reservedLayoutSize = imageSize
        contentConfiguration.imageProperties.maximumSize = imageSize
        contentConfiguration.imageProperties.cornerRadius = 8
        contentConfiguration.image = UIImage(systemName: "music.note")
        
        self.contentConfiguration = contentConfiguration
        
        imageLoadOperation = SDWebImageManager.shared.loadImage(with: viewModel.artworkURL, progress: nil, completed: { (image, _, _, _, _, _) in
            contentConfiguration.image = image
            self.contentConfiguration = contentConfiguration
        })
    }
    
    override func prepareForReuse() {
        imageLoadOperation?.cancel()
    }
    
    
}
