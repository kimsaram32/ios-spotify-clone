import UIKit

class TitleHeaderSupplementaryView: UICollectionReusableView {
    
    static let reuseIdentifier = "TitleHeaderSupplementaryView"
    
    lazy var label = UILabel().then {
        $0.font = .systemFont(ofSize: 18, weight: .bold)
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
            label
        ].forEach { addSubview($0) }
    }
    
    func setLayout() {
        label.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configure(with title: String) {
        label.text = title
    }
    

}
