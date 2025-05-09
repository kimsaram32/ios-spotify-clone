import UIKit
import SnapKit
import Then

class ImageHeaderView: UITableViewHeaderFooterView {
    
    static let reuseIdentifier = "ImageHeaderView"
    
    lazy var imageView = UIImageView()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        addSubviews()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func addSubviews() {
        [
            imageView
        ].forEach { contentView.addSubview($0) }
    }
    
    func setLayout() {
        imageView.snp.makeConstraints {
            $0.size.equalTo(60)
            $0.center.equalToSuperview()
        }
    }
    
    func configure(image: UIImage) {
        imageView.image = image
    }


}
