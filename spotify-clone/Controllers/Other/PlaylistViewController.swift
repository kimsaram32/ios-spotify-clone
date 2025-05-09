import UIKit

class PlaylistViewController: BaseViewController {
    
    struct ElementKind {
        static let header = "header"
    }
    
    let playlist: Playlist
    let headerViewModel: PlaylistHeaderViewModel
    
    var trackViewModels: [TrackCellViewModel]?
    
    lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: createCollectionViewLayout()
    ).then {
        $0.dataSource = self
        $0.register(TrackCollectionViewCell.self, forCellWithReuseIdentifier: TrackCollectionViewCell.reuseIdentifier)
        $0.register(PlaylistHeaderSupplementaryView.self, forSupplementaryViewOfKind: ElementKind.header, withReuseIdentifier: PlaylistHeaderSupplementaryView.reuseIdentifier)
        $0.register(LoadingIndicatorCollectionViewCell.self, forCellWithReuseIdentifier: LoadingIndicatorCollectionViewCell.reuseIdentifier)
    }
    
    init(playlist: Playlist) {
        self.playlist = playlist
        headerViewModel = PlaylistHeaderViewModel(
            name: playlist.name,
            description: playlist.description,
            ownerName: playlist.owner.displayName,
            artworkURL: Formatter.shared.getArtworkURL(images: playlist.images)
        )
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Task {
            await fetchTracks()
        }
    }
    
    override func addSubviews() {
        [
            collectionView
        ].forEach { view.addSubview($0) }
    }
    
    override func setLayout() {
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func fetchTracks() async {
        do {
            let tracks = try await PlaylistApi.shared.getPlaylistTracks(id: playlist.id)
            trackViewModels = tracks.map {
                TrackCellViewModel(
                    name: $0.name,
                    artistName: Formatter.shared.formatArtistName(artists: $0.artists),
                    artworkURL: Formatter.shared.getArtworkURL(images: $0.album.images)
                )
            }
            collectionView.reloadData()
        } catch {
            print(error)
        }
    }
    

}

extension PlaylistViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let trackViewModels {
            let viewModel = trackViewModels[indexPath.row]
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: TrackCollectionViewCell.reuseIdentifier,
                for: indexPath
            ) as! TrackCollectionViewCell
            cell.configure(with: viewModel)
            return cell
        }
        
        return collectionView.dequeueReusableCell(withReuseIdentifier: LoadingIndicatorCollectionViewCell.reuseIdentifier, for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trackViewModels?.count ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: ElementKind.header,
            withReuseIdentifier: PlaylistHeaderSupplementaryView.reuseIdentifier,
            for: indexPath
        ) as! PlaylistHeaderSupplementaryView
        headerView.configure(with: headerViewModel)
        return headerView
    }
    
    
}

extension PlaylistViewController {
    
    func createCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let headerSupplementaryItem = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(400)),
            elementKind: ElementKind.header,
            alignment: .top
        )
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(100)),
            subitems: [item],
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.boundarySupplementaryItems = [headerSupplementaryItem]
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    
}
