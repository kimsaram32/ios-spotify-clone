import UIKit

class SettingsViewController: UIViewController {
    
    struct TableViewSection {
        let title: String
        let rows: [TableViewRow]
    }
    
    struct TableViewRow {
        let title: String
        let handler: () -> Void
    }
    
    private var tableViewSections: [TableViewSection]!
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Settings"
        view.backgroundColor = .systemBackground
        
        tableViewSections = [
            TableViewSection(title: "Profile", rows: [
                TableViewRow(title: "View profile") {
                    self.navigationController?.pushViewController(ProfileViewController(), animated: true)
                }
            ]),
            TableViewSection(title: "Auth", rows: [
                TableViewRow(title: "Log out") {
                    AuthData.shared.clearData()
                    let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
                    sceneDelegate.setRootViewControllerBySignInStatus()
                }
            ])
        ]
        
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.fill(to: view.safeAreaLayoutGuide)
    }
    

}

extension SettingsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewSections[section].rows.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableViewSections[section].title
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = tableViewSections[indexPath.section].rows[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = item.title
        cell.contentConfiguration = contentConfiguration
        
        return cell
    }
    
    
}

extension SettingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = tableViewSections[indexPath.section].rows[indexPath.row]
        item.handler()
    }
    
    
}
