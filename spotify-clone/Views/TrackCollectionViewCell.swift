import UIKit
import SDWebImage

class TrackCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "TrackCollectionViewCell"
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    lazy var artistNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 8
        backgroundColor = .secondarySystemBackground
        addSubviews()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func addSubviews() {
        [
            imageView,
            nameLabel,
            artistNameLabel,
        ].forEach { addSubview($0) }
    }
    
    func setLayout() {
        let imagePadding: CGFloat = 4
        let contentPadding: CGFloat = 10
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalTo: heightAnchor, constant: -imagePadding * 2).isActive = true
        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: imagePadding).isActive = true
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: contentPadding).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 12).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -imagePadding).isActive = true

        artistNameLabel.translatesAutoresizingMaskIntoConstraints = false
        artistNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: contentPadding).isActive = true
        artistNameLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor).isActive = true
        artistNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -imagePadding).isActive = true
    }
    
    func configure(with viewModel: TrackCellViewModel) {
        imageView.sd_setImage(with: viewModel.artworkURL)
        nameLabel.text = viewModel.name
        artistNameLabel.text = viewModel.artistName
    }
    
    
}
