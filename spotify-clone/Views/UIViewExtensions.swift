import UIKit

extension UIView {
    
    func fill(to view: UIView) {
        NSLayoutConstraint.activate([
            self.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            self.topAnchor.constraint(equalTo: view.topAnchor),
            self.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    func fill(to layoutGuide: UILayoutGuide) {
        NSLayoutConstraint.activate([
            self.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor),
            self.topAnchor.constraint(equalTo: layoutGuide.topAnchor),
            self.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor),
        ])
    }
    
    
}
