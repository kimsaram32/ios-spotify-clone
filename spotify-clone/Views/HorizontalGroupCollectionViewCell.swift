import UIKit
import SDWebImage

class HorizontalGroupCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "HorizontalTrackGroupCollectionViewCell"
    
    lazy var imageView = UIImageView().then {
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFit
        $0.contentScaleFactor = 0.8
    }
    
    lazy var nameLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 20, weight: .bold)
    }
    
    lazy var artistNameLabel = UILabel().then {
        $0.textColor = .secondaryLabel
    }
    
    lazy var tracksCountLabel = UILabel().then {
        $0.textColor = .secondaryLabel
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 12
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
            tracksCountLabel,
        ].forEach { addSubview($0) }
    }
    
    func setLayout() {
        let padding: CGFloat = 10
        
        imageView.snp.makeConstraints {
            $0.size.equalTo(snp.height).inset(padding)
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(padding)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(padding)
            $0.leading.equalTo(imageView.snp.trailing).offset(padding)
        }

        artistNameLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(padding)
            $0.leading.equalTo(nameLabel)
            $0.trailing.equalToSuperview().inset(padding)
        }
        
        tracksCountLabel.snp.makeConstraints {
            $0.leading.equalTo(nameLabel)
            $0.bottom.equalToSuperview().inset(padding)
        }
    }
    
    func configure(with viewModel: ItemGroupCellViewModel) {
        imageView.setImage(with: viewModel.image)
        nameLabel.text = viewModel.title
        artistNameLabel.text = viewModel.subtitle
        tracksCountLabel.text = viewModel.itemsCount?.text ?? ""
    }
    
    
}
