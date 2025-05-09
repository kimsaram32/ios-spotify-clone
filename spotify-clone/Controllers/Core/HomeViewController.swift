import UIKit
import SnapKit
import Then

class HomeViewController: BaseViewController {
    
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
    
    // this sucks (todo refactor with something else??)
    var featuredPlaylists = [Playlist]()
    
    var newReleaseViewModels = [NewReleaseCellViewModel]()
    var featuredPlaylistViewModels = [FeaturedPlaylistCellViewModel]()
    var recommendationViewModels = [TrackCellViewModel]()
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout()).then {
        $0.dataSource = self
        $0.delegate = self
        
        $0.register(
            TitleHeaderSupplementaryView.self,
            forSupplementaryViewOfKind: "header",
            withReuseIdentifier: TitleHeaderSupplementaryView.reuseIdentifier
        )
        $0.register(
            NewReleaseCollectionViewCell.self,
            forCellWithReuseIdentifier: NewReleaseCollectionViewCell.reuseIdentifier
        )
        $0.register(
            FeaturedPlaylistCollectionViewCell.self,
            forCellWithReuseIdentifier: FeaturedPlaylistCollectionViewCell.reuseIdentifier
        )
        $0.register(
            TrackCollectionViewCell.self,
            forCellWithReuseIdentifier: TrackCollectionViewCell.reuseIdentifier
        )
        
        $0.isHidden = true
    }
    
    lazy var loadingIndicator = UIActivityIndicatorView(style: .large).then {
        $0.startAnimating()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Browse"
        view.backgroundColor = .systemBackground
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Task {
            await fetchData()
        }
    }
    
    override func addSubviews() {
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
    
    override func setLayout() {
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        loadingIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
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
        newReleaseViewModels = albums.map {
            NewReleaseCellViewModel(
                name: $0.name,
                artistName: Formatter.shared.formatArtistName(artists: $0.artists),
                artworkURL: Formatter.shared.getArtworkURL(images: $0.images),
                tracksCount: $0.totalTracks
            )
        }
    }
    
    func fetchFeaturedPlaylists() async {
        guard let playlists = try? await PlaylistApi.shared.getFeaturedPlaylists() else {
            return
        }
        featuredPlaylists = playlists
        featuredPlaylistViewModels = playlists.map {
            FeaturedPlaylistCellViewModel(
                name: $0.name,
                tracksCount: $0.tracks.count,
                artworkURL: Formatter.shared.getArtworkURL(images: $0.images)
            )
        }
    }
    
    func fetchRecommendations() async {
        guard let tracks = try? await TrackApi.shared.getRecommendations() else {
            return
        }
        recommendationViewModels = tracks.map {
            TrackCellViewModel(
                name: $0.name,
                artistName: Formatter.shared.formatArtistName(artists: $0.artists),
                artworkURL: Formatter.shared.getArtworkURL(images: $0.album.images)
            )
        }
    }
    
    @objc func settingsButtonTapped() {
        navigationController?.pushViewController(SettingsViewController(), animated: true)
    }


}

extension HomeViewController: UICollectionViewDataSource {
    
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
                withReuseIdentifier: TrackCollectionViewCell.reuseIdentifier, for: indexPath
            ) as! TrackCollectionViewCell
            cell.configure(with: recommendationViewModels[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let titleHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: "header", withReuseIdentifier: TitleHeaderSupplementaryView.reuseIdentifier, for: indexPath) as! TitleHeaderSupplementaryView
        let sectionType = BrowseSectionType(rawValue: indexPath.section)!
        titleHeaderView.configure(with: sectionType.title)
        return titleHeaderView
    }
    
    
}

extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sectionType = BrowseSectionType(rawValue: indexPath.section)!
        
        if sectionType == .featuredPlaylist {
            let viewController = PlaylistViewController(playlist: featuredPlaylists[indexPath.row])
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    
}

extension HomeViewController {
    
    func createCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let sectionContentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        let layout = UICollectionViewCompositionalLayout(sectionProvider: { sectionIndex, _ in
            let sectionType = BrowseSectionType(rawValue: sectionIndex)!
            var section: NSCollectionLayoutSection
                
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
                section = NSCollectionLayoutSection(group: verticalGroup)
                section.orthogonalScrollingBehavior = .groupPagingCentered
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
                section = NSCollectionLayoutSection(group: verticalGroup)
                section.orthogonalScrollingBehavior = .groupPaging
            case .recommendation:
                let item = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                )
                item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
                let verticalGroup = NSCollectionLayoutGroup.vertical(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(100)),
                    subitems: [item]
                )
                section = NSCollectionLayoutSection(group: verticalGroup)
            }
                
            section.contentInsets = sectionContentInsets
            
            let headerSupplementaryItem = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(40)
                ),
                elementKind: "header",
                alignment: .top
            )
            headerSupplementaryItem.contentInsets = .init(top: 0, leading: 8, bottom: 0, trailing: 8)
            section.boundarySupplementaryItems = [headerSupplementaryItem]
                
            return section
        })
        return layout
    }
    
    
}
