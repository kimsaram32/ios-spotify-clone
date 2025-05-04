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

    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    lazy var iconImageWrapperView: UIView = {
        let view = UIView()
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = .init(width: -4, height: 4)
        view.layer.shadowRadius = 4
        view.transform = CGAffineTransform(rotationAngle: (20.0 / 180.0) * .pi)
        view.addSubview(iconImageView)
        return view
    }()
    
    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        return imageView
    }()
    
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
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        nameLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.7).isActive = true
        
        iconImageWrapperView.translatesAutoresizingMaskIntoConstraints = false
        iconImageWrapperView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 12).isActive = true
        iconImageWrapperView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6).isActive = true
        iconImageWrapperView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4).isActive = true
        iconImageWrapperView.heightAnchor.constraint(equalTo: iconImageWrapperView.widthAnchor).isActive = true
        
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.fill(to: iconImageWrapperView)
    }
    
    func configure(with viewModel: CategoryCellViewModel) {
        nameLabel.text = viewModel.name
        iconImageView.sd_setImage(with: viewModel.iconImageURL)
    }
    
    
}
