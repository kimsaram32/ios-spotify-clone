import UIKit
import WebKit

class AuthViewController: UIViewController, WKNavigationDelegate {
    
    private let webView: WKWebView = {
        var preferences = WKWebpagePreferences()
        preferences.allowsContentJavaScript = true
        var configuration = WKWebViewConfiguration()
        configuration.defaultWebpagePreferences = preferences
        return WKWebView(frame: .zero, configuration: configuration)
    }()
    
    var completionHandler: ((Bool) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Sign in"
        view.backgroundColor = .systemBackground
        
        webView.navigationDelegate = self
        view.addSubview(webView)
        
        webView.load(URLRequest(url: AuthManager.shared.signInURL))
    }
    
    override func viewDidLayoutSubviews() {
        webView.frame = view.bounds
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        guard let url = webView.url else { return }
        guard let code = URLComponents(string: url.absoluteString)?.queryItems?.first(where: { $0.name == "code" })?.value else {
            return
        }
        webView.isHidden = true
        
        AuthManager.shared.exchangeCodeForToken(code: code, completion: { [weak self] success in
            DispatchQueue.main.async {
                self?.navigationController?.popToRootViewController(animated: true)
                self?.completionHandler?(success)
            }
        })
    }
    

}
