import UIKit

class PlaylistHeaderSupplementaryView: UICollectionReusableView {
    
    static let reuseIdentifier = "PlaylistHeaderSupplementaryView"
    
    lazy var artworkImageView = UIImageView().then {
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
    }
    
    lazy var nameLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 24, weight: .bold)
    }
    
    lazy var descriptionLabel = UILabel().then {
        $0.textColor = .secondaryLabel
    }
    
    lazy var ownerLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 18)
        $0.textColor = .secondaryLabel
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
            artworkImageView,
            nameLabel,
            descriptionLabel,
            ownerLabel,
        ].forEach { addSubview($0) }
    }
    
    func setLayout() {
        artworkImageView.snp.makeConstraints {
            $0.size.equalTo(snp.width).multipliedBy(0.6)
            $0.centerX.top.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(artworkImageView.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(6)
        }

        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(6)
        }
        
        ownerLabel.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(6)
        }
    }
    
    func configure(with viewModel: PlaylistHeaderViewModel) {
        artworkImageView.sd_setImage(with: viewModel.artworkURL)
        nameLabel.text = viewModel.name
        descriptionLabel.text = viewModel.description
        ownerLabel.text = viewModel.ownerName
    }

    
}
