import UIKit

class LoadingIndicatorCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "LoadingIndicatorCollectionViewCell:"
    
    lazy var loadingIndicator = UIActivityIndicatorView(style: .large).then {
        $0.color = .label
        $0.startAnimating()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
        setLayout()
    }
    
    func addSubviews() {
        [
            loadingIndicator
        ].forEach { addSubview($0) }
    }
    
    func setLayout() {
        loadingIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
}
