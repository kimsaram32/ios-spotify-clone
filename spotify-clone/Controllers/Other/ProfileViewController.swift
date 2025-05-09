import UIKit
import SDWebImage

class ProfileViewController: BaseViewController {
    
    struct TableViewEntry {
        let name: String
        let value: String
    }
    
    private var tableViewEntries = [TableViewEntry]()
    private var profile: UserProfile!
    private var profileImage: UIImage?
    
    lazy var tableView = UITableView().then {
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        $0.register(ImageHeaderView.self, forHeaderFooterViewReuseIdentifier: ImageHeaderView.reuseIdentifier)
        
        $0.sectionHeaderHeight = 100
        $0.allowsSelection = false
        
        $0.dataSource = self
        $0.delegate = self
        
        $0.isHidden = true
    }
    
    lazy var errorLabel = UILabel().then {
        $0.text = "Failed to load profile..."
        $0.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Profile"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Task {
            await fetchProfile()
        }
    }
    
    override func addSubviews() {
        [
            tableView,
            errorLabel
        ].forEach { view.addSubview($0) }
    }
    
    override func setLayout() {
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        errorLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
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
            errorLabel.isHidden = false
        }
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
