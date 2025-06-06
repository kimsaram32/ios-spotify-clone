import UIKit
import WebKit

class AuthViewController: BaseViewController, WKNavigationDelegate {
    
    // didn't use Then to create configuration
    lazy var webView: WKWebView = {
        var preferences = WKWebpagePreferences()
        preferences.allowsContentJavaScript = true
        var configuration = WKWebViewConfiguration()
        configuration.websiteDataStore = .nonPersistent()
        configuration.defaultWebpagePreferences = preferences
        
        let webView =  WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = self
        
        return webView
    }()
    
    var completionHandler: ((Bool) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Sign in"
        
        webView.load(URLRequest(url: AuthApi.shared.signInURL))
    }
    
    override func addSubviews() {
        [
            webView
        ].forEach { view.addSubview($0) }
    }
    
    override func setLayout() {
        webView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        guard let url = webView.url else { return }
        guard url.absoluteString.hasPrefix(AuthApi.Constants.redirectUri) else {
            return
        }
        webView.isHidden = true
        guard let code = URLComponents(string: url.absoluteString)?.queryItems?.first(where: { $0.name == "code" })?.value else {
            navigationController?.popToRootViewController(animated: true)
            completionHandler?(false)
            return
        }
        
        Task {
            do {
                try await AuthApi.shared.exchangeCodeForToken(code: code)
                navigationController?.popToRootViewController(animated: true)
                completionHandler?(true)
            } catch {
                completionHandler?(false)
            }
        }
    }
    

}
