import UIKit
import SDWebImage

class CategoryCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "CategoryCollectionViewCell"
    
    static private let colors: [UIColor] = [
        .systemPink,
        .systemBlue,
        .systemPurple,
        .systemOrange,
        .systemGreen,
        .systemRed,
        .systemYellow,
        .darkGray,
        .systemTeal
    ]

    lazy var nameLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 20, weight: .bold)
        $0.textColor = .white
        $0.numberOfLines = 0
    }
    
    lazy var iconImageWrapperView = UIView().then {
        $0.layer.shadowOpacity = 0.2
        $0.layer.shadowOffset = .init(width: -4, height: 4)
        $0.layer.shadowRadius = 4
        $0.transform = CGAffineTransform(rotationAngle: (20.0 / 180.0) * .pi)
        $0.addSubview(iconImageView)
    }
    
    lazy var iconImageView = UIImageView().then {
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        clipsToBounds = true
        layer.cornerRadius = 12
        backgroundColor = CategoryCollectionViewCell.colors.randomElement()
        addSubviews()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func addSubviews() {
        [
            iconImageWrapperView,
            nameLabel,
        ].forEach { addSubview($0) }
    }
    
    func setLayout() {
        nameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(10)
            $0.top.equalToSuperview().offset(16)
            $0.width.equalToSuperview().multipliedBy(0.7)
        }
        
        iconImageWrapperView.snp.makeConstraints {
            $0.size.equalTo(snp.width).multipliedBy(0.4)
            $0.trailing.equalToSuperview().offset(12)
            $0.bottom.equalToSuperview().inset(6)
        }
        
        iconImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configure(with viewModel: CategoryCellViewModel) {
        nameLabel.text = viewModel.name
        iconImageView.setImage(with: viewModel.iconImage)
    }
    
    
}
