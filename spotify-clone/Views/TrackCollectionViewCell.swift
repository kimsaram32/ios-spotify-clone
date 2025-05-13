import UIKit
import SDWebImage

class TrackCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "TrackCollectionViewCell"
    static let height: CGFloat = 100
    static let spacing: CGFloat = 12
    
    lazy var imageView = UIImageView().then {
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }
    
    lazy var nameLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 18, weight: .bold)
    }
    
    lazy var artistNameLabel = UILabel().then {
        $0.textColor = .secondaryLabel
    }
    
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
        
        imageView.snp.makeConstraints {
            $0.size.equalTo(snp.height).inset(imagePadding)
            $0.leading.equalToSuperview().offset(imagePadding)
            $0.centerY.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(contentPadding)
            $0.leading.equalTo(imageView.snp.trailing).offset(12)
            $0.trailing.equalToSuperview().inset(imagePadding)
        }
        
        artistNameLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(contentPadding)
            $0.horizontalEdges.equalTo(nameLabel)
        }
    }
    
    func configure(with viewModel: TrackCellViewModel) {
        nameLabel.text = viewModel.name
        artistNameLabel.text = viewModel.artistName
        imageView.setImage(with: viewModel.artworkImage)
    }
    
    
}
