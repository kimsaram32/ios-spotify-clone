import UIKit
import SDWebImage

class SquareGroupCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "SquareTrackGroupCollectionViewCell:"
    
    lazy var imageView = UIImageView().then {
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFit
        $0.contentScaleFactor = 0.8
    }
    
    lazy var nameLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 20, weight: .bold)
        $0.textAlignment = .center
        $0.numberOfLines = 2
    }
    
    lazy var tracksCountLabel = UILabel().then {
        $0.textColor = .secondaryLabel
        $0.textAlignment = .center
    }
    
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
            imageView,
            nameLabel,
            tracksCountLabel,
        ].forEach { addSubview($0) }
    }
    
    func setLayout() {
        imageView.snp.makeConstraints {
            $0.size.equalTo(snp.width).multipliedBy(0.8)
            $0.centerX.top.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.top.equalTo(imageView.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
        
        tracksCountLabel.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.top.equalTo(nameLabel.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
    }
    
    func configure(with viewModel: ItemGroupCellViewModel) {
        imageView.setImage(with: viewModel.image)
        nameLabel.text = viewModel.title
        tracksCountLabel.text = viewModel.itemsCount?.text ?? ""
    }
    
    
}
