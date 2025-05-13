import UIKit
import SnapKit
import Then

class LoadingViewController: BaseViewController {
    
    enum Status {
        case loading, done
    }
    
    private lazy var activityIndicator = UIActivityIndicatorView(style: .medium).then {
        $0.startAnimating()
    }
    
    private lazy var doneLabel = UILabel()
   
    init(textWhenDone doneText: String) {
        super.init(nibName: nil, bundle: nil)
        doneLabel.text = doneText
    }
    
    convenience init() {
        self.init(textWhenDone: "")
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setStatus(to status: Status) {
        switch status {
        case .loading:
            activityIndicator.startAnimating()
            doneLabel.isHidden = true
        case .done:
            activityIndicator.stopAnimating()
            doneLabel.isHidden = false
        }
    }
    
    override func addSubviews() {
        [
            activityIndicator,
            doneLabel
        ].forEach { view.addSubview($0) }
    }
    
    override func setLayout() {
        activityIndicator.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        activityIndicator.snp.makeConstraints {
            $0.centerY.width.equalToSuperview()
        }
    }
    
    
}
