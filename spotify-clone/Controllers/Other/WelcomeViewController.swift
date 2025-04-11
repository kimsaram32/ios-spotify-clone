import UIKit

class WelcomeViewController: UIViewController {
    
    private let signInButton: UIButton = {
        var buttonConfiguration = UIButton.Configuration.filled()
        
        buttonConfiguration.baseBackgroundColor = .white
        buttonConfiguration.baseForegroundColor = .blue
        
        buttonConfiguration.contentInsets.bottom = 12
        buttonConfiguration.contentInsets.top = 12
        
        buttonConfiguration.title = "Sign in with Spotify"
        
        let button = UIButton(configuration: buttonConfiguration)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Spotify"
        view.backgroundColor = .systemGreen
        
        view.addSubview(signInButton)
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        signInButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -60).isActive = true
        signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signInButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        signInButton.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
    }
    
    @objc func signInButtonTapped() {
        let vc = AuthViewController()
        vc.completionHandler = { success in
            self.handleSignIn()
        }
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController!.pushViewController(vc, animated: true)
    }
    
    func handleSignIn() {
        
    }
    
    
}
