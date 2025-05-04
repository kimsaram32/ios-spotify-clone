import UIKit

class TabBarViewController: UITabBarController {
    
    private let tabItems: [(UIViewController, UITabBarItem)] = [
        (HomeViewController(), UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), tag: 0)),
        (SearchViewController(), UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 1)),
        (LibraryViewController(), UITabBarItem(title: "Library", image: UIImage(systemName: "music.note.list"), tag: 2)),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViewControllers(tabItems.map {
            let (vc, tabBarItem) = $0
            
            let navigationController = UINavigationController(rootViewController: vc)
            navigationController.title = vc.title
            navigationController.tabBarItem = tabBarItem
            navigationController.navigationBar.prefersLargeTitles = true
            
            return navigationController
        }, animated: false)
    }
    
    
}
