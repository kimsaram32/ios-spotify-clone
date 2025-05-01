import UIKit

class PlaylistHeaderSupplementaryView: UICollectionReusableView {
    
    static let reuseIdentifier = "PlaylistHeaderSupplementaryView"
    
    lazy var artworkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        return label
    }()
    
    lazy var ownerLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textColor = .secondaryLabel
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func addSubviews() {
        [
            artworkImageView,
            nameLabel,
            descriptionLabel,
            ownerLabel,
        ].forEach { addSubview($0) }
    }
    
    func setLayout() {
        artworkImageView.translatesAutoresizingMaskIntoConstraints = false
        artworkImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6).isActive = true
        artworkImageView.heightAnchor.constraint(equalTo: artworkImageView.widthAnchor).isActive = true
        artworkImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        artworkImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.topAnchor.constraint(equalTo: artworkImageView.bottomAnchor, constant: 20).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -6).isActive = true

        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.topAnchor.constraint(equalTo: nameLabel.topAnchor, constant: 20).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -6).isActive = true

        ownerLabel.translatesAutoresizingMaskIntoConstraints = false
        ownerLabel.topAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: 20).isActive = true
        ownerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6).isActive = true
        ownerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -6).isActive = true
    }
    
    func configure(with viewModel: PlaylistHeaderViewModel) {
        artworkImageView.sd_setImage(with: viewModel.artworkURL)
        nameLabel.text = viewModel.name
        descriptionLabel.text = viewModel.description
        ownerLabel.text = viewModel.ownerName
    }

    
}
