//
//  ProfileViewController.swift
//  spotify-clone
//
//  Created by 김민정 on 4/10/25.
//

import UIKit

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
        tableView.register(ImageHeaderView.self, forHeaderFooterViewReuseIdentifier: "header")
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
            await fetchProfileImage()
        } catch {
            showError()
        }
    }
    
    func fetchProfileImage() async {
        guard let profileUrlString = profile.images.first?.url else {
            return
        }
        guard let profileUrl = URL(string: profileUrlString) else {
            return
        }
        
        let request = URLRequest(url: profileUrl)
        guard let (profileData, _) = try? await URLSession.shared.data(for: request) else {
            return
        }
        
        profileImage = UIImage(data: profileData)
        tableView.reloadData()
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
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as! ImageHeaderView
        if let profileImage {
            headerView.configure(image: profileImage)
        }
        return headerView
    }
    
    
}
