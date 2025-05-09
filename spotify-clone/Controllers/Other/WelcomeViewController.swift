import UIKit

class WelcomeViewController: BaseViewController {
    
    lazy var signInButton = UIButton().then {
        var buttonConfiguration = UIButton.Configuration.filled()
        
        buttonConfiguration.baseBackgroundColor = .white
        buttonConfiguration.baseForegroundColor = .blue
        
        buttonConfiguration.contentInsets.bottom = 12
        buttonConfiguration.contentInsets.top = 12
        
        buttonConfiguration.title = "Sign in with Spotify"
        $0.configuration = buttonConfiguration
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Spotify"
        view.backgroundColor = .systemGreen
        
        signInButton.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
    }
    
    override func addSubviews() {
        [
            signInButton
        ].forEach { view.addSubview($0) }
    }
    
    override func setLayout() {
        signInButton.snp.makeConstraints {
            $0.width.equalToSuperview().offset(-60)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
    }
    
    @objc func signInButtonTapped() {
        let vc = AuthViewController()
        vc.completionHandler = { success in
            self.handleSignIn(success: success)
        }
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController!.pushViewController(vc, animated: true)
    }
    
    func handleSignIn(success: Bool) {
        if !success {
            let alertController = UIAlertController(title: "Error", message: "Failed to sign in.\nTry again", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .cancel))
            present(alertController, animated: true)
            return
        }
        let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
        sceneDelegate.setRootViewControllerBySignInStatus()
    }
    
    
}
