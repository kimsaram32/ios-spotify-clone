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
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.fill(to: view)
        
        webView.load(URLRequest(url: AuthApi.shared.signInURL))
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
