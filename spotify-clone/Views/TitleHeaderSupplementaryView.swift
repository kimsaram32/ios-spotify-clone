import UIKit

class TitleHeaderSupplementaryView: UICollectionReusableView {
    
    static let reuseIdentifier = "TitleHeaderSupplementaryView"
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
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
            label
        ].forEach { addSubview($0) }
    }
    
    func setLayout() {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.fill(to: self)
    }
    
    func configure(with title: String) {
        label.text = title
    }
    

}
