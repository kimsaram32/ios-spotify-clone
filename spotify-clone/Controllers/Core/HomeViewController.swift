import UIKit

class HomeViewController: UIViewController {
    
    static let defaultArtworkURL = URL(string: "https://placehold.co/300x300?text=Album")!
    
    enum BrowseSectionType: Int {
        
        case newRelease
        case featuredPlaylist
        case recommendation
        
        var title: String {
            switch self {
            case .newRelease:
                "New Releases"
            case .featuredPlaylist:
                "Featured Playlists"
            case .recommendation:
                "Recommended Tracks"
            }
        }
        
    }
    
    var newReleaseViewModels = [NewReleaseCellViewModel]()
    var featuredPlaylistViewModels = [FeaturedPlaylistCellViewModel]()
    var recommendationViewModels = [RecommendationCellViewModel]()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(
            NewReleaseCollectionViewCell.self, forCellWithReuseIdentifier: NewReleaseCollectionViewCell.reuseIdentifier
        )
        collectionView.register(
            FeaturedPlaylistCollectionViewCell.self, forCellWithReuseIdentifier: FeaturedPlaylistCollectionViewCell.reuseIdentifier
        )
        collectionView.register(
            RecommendationCollectionViewCell.self, forCellWithReuseIdentifier: RecommendationCollectionViewCell.reuseIdentifier
        )
        
        collectionView.isHidden = true
        
        return collectionView
    }()
    
    lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.startAnimating()
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Browse"
        view.backgroundColor = .systemBackground
        
        addSubviews()
        setLayout()
        
        Task {
            await fetchData()
        }
    }
    
    func addSubviews() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "gear"),
            style: .plain,
            target: self,
            action: #selector(settingsButtonTapped)
        )
        
        [
            collectionView,
            loadingIndicator
        ].forEach { view.addSubview($0) }
    }
    
    func setLayout() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.fill(to: view)
        
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func fetchData() async {
        let _ = await [fetchNewReleases(), fetchFeaturedPlaylists(), fetchRecommendations()]
        
        collectionView.isHidden = false
        collectionView.reloadData()
        loadingIndicator.stopAnimating()
    }
    
    func fetchNewReleases() async {
        guard let albums = try? await AlbumApi.shared.getNewReleases() else {
            return
        }
        newReleaseViewModels = albums.compactMap {
            NewReleaseCellViewModel(
                name: $0.name,
                artistName: formatArtistName(artists: $0.artists),
                artworkURL: getArtworkURL(images: $0.images),
                tracksCount: $0.totalTracks
            )
        }
    }
    
    func fetchFeaturedPlaylists() async {
        guard let playlists = try? await PlaylistApi.shared.getFeaturedPlaylists() else {
            return
        }
        featuredPlaylistViewModels = playlists.compactMap {
            FeaturedPlaylistCellViewModel(
                name: $0.name,
                tracksCount: $0.tracks.count,
                artworkURL: getArtworkURL(images: $0.images)
            )
        }
    }
    
    func fetchRecommendations() async {
        guard let tracks = try? await TrackApi.shared.getRecommendations() else {
            return
        }
        recommendationViewModels = tracks.compactMap {
            RecommendationCellViewModel(
                name: $0.name,
                artistName: formatArtistName(artists: $0.artists),
                artworkURL: getArtworkURL(images: $0.album.images)
            )
        }
    }
    
    func formatArtistName(artists: [Artist]) -> String {
        artists.count > 0 ? artists.map { $0.name }.joined(separator: ",") : "-"
    }
    
    func getArtworkURL(images: [APIImage]) -> URL {
        images.first?.url ?? HomeViewController.defaultArtworkURL
    }
    
    @objc func settingsButtonTapped() {
        navigationController?.pushViewController(SettingsViewController(), animated: true)
    }


}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionType = BrowseSectionType(rawValue: section)!
        switch sectionType {
        case .newRelease:
            return newReleaseViewModels.count
        case .featuredPlaylist:
            return featuredPlaylistViewModels.count
        case .recommendation:
            return recommendationViewModels.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionType = BrowseSectionType(rawValue: indexPath.section)!
        
        switch sectionType {
        case .newRelease:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: NewReleaseCollectionViewCell.reuseIdentifier, for: indexPath
            ) as! NewReleaseCollectionViewCell
            
            cell.configure(with: newReleaseViewModels[indexPath.row])
            return cell
        case .featuredPlaylist:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: FeaturedPlaylistCollectionViewCell.reuseIdentifier, for: indexPath
            ) as! FeaturedPlaylistCollectionViewCell
            cell.configure(with: featuredPlaylistViewModels[indexPath.row])
            return cell
        case .recommendation:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RecommendationCollectionViewCell.reuseIdentifier, for: indexPath
            ) as! RecommendationCollectionViewCell
            cell.configure(with: recommendationViewModels[indexPath.row])
            return cell
        }
    }
    
    
}

extension HomeViewController {
    
    func createCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let sectionContentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        let layout = UICollectionViewCompositionalLayout(sectionProvider: { sectionIndex, _ in
            let sectionType = BrowseSectionType(rawValue: sectionIndex)!
            
            switch sectionType {
            case .newRelease:
                let item = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1 / 3))
                )
                item.contentInsets = .init(top: 8, leading: 8, bottom: 8, trailing: 8)
                let verticalGroup = NSCollectionLayoutGroup.vertical(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(400)),
                    repeatingSubitem: item,
                    count: 3
                )
                let section = NSCollectionLayoutSection(group: verticalGroup)
                section.contentInsets = sectionContentInsets
                section.orthogonalScrollingBehavior = .groupPagingCentered
                return section
            case .featuredPlaylist:
                let item = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.5))
                )
                item.contentInsets = .init(top: 8, leading: 8, bottom: 8, trailing: 8)
                let verticalGroup = NSCollectionLayoutGroup.vertical(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(200), heightDimension: .absolute(500)),
                    repeatingSubitem: item,
                    count: 2
                )
                let section = NSCollectionLayoutSection(group: verticalGroup)
                section.contentInsets = sectionContentInsets
                section.orthogonalScrollingBehavior = .groupPaging
                return section
            case .recommendation:
                let item = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                )
                item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
                let verticalGroup = NSCollectionLayoutGroup.vertical(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(100)),
                    subitems: [item]
                )
                let section = NSCollectionLayoutSection(group: verticalGroup)
                return section
            }
        })
        return layout
    }
    
    
}
