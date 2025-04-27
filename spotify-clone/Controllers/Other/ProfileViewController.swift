import UIKit
import SDWebImage

class ProfileViewController: UIViewController {
    
    struct TableViewEntry {
        let name: String
        let value: String
    }
    
    private var tableViewEntries = [TableViewEntry]()
    private var profile: UserProfile!
    private var profileImage: UIImage?
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(ImageHeaderView.self, forHeaderFooterViewReuseIdentifier: ImageHeaderView.reuseIdentifier)
        tableView.sectionHeaderHeight = 100
        tableView.allowsSelection = false
        return tableView
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.text = "Failed to load profile..."
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Profile"
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.fill(to: view)
        tableView.isHidden = true

        Task {
            await fetchProfile()
        }
    }
    
    func fetchProfile() async {
        do {
            profile = try await ProfileApi.shared.getCurrentUserProfile()
            tableViewEntries = [
                TableViewEntry(name: "Name", value: profile.displayName ?? "-"),
                TableViewEntry(name: "Email address", value: profile.email),
                TableViewEntry(name: "Plan", value: profile.product)
            ]
            tableView.isHidden = false
            tableView.reloadData()
            if let imageURL = profile.images.first?.url {
                SDWebImageManager.shared.loadImage(
                    with: imageURL,
                    options: .highPriority,
                    progress: nil,
                    completed: { (image, data, error, cacheType, finished, url) in
                        if let image, error == nil {
                            self.profileImage = image
                            self.tableView.reloadData()
                        }
                    }
                )
            }
        } catch {
            showError()
        }
    }
    
    func showError() {
        view.addSubview(errorLabel)
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    

}

extension ProfileViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableViewEntries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = tableViewEntries[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = item.name + ": " + item.value
        cell.contentConfiguration = contentConfiguration
        return cell
    }
    
    
}

extension ProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: ImageHeaderView.reuseIdentifier) as! ImageHeaderView
        if let profileImage {
            headerView.configure(image: profileImage)
        }
        return headerView
    }
    
    
}
