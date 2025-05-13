import UIKit
import SnapKit
import Then

class LibraryPlaylistsViewController: BaseViewController {
    
    var selectHandler: ((Playlist) -> Void)?
    
    private let loaderId = "loader" // temp id to detect and show loaders...

    private typealias Cell = HorizontalGroupCollectionViewCell
    private typealias LoadingIndicatorCell = LoadingIndicatorCollectionViewCell
    private typealias DataSource = UICollectionViewDiffableDataSource<Int, String>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Int, String>
    
    private var dataSource: DataSource!
    private var playlists = [Playlist]()
    private var viewModels = [String: ItemGroupCellViewModel]()

    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout()).then {
        $0.register(Cell.self, forCellWithReuseIdentifier: Cell.reuseIdentifier)
        $0.register(LoadingIndicatorCell.self, forCellWithReuseIdentifier: LoadingIndicatorCell.reuseIdentifier)
        $0.delegate = self
        
        dataSource = createCollectionViewDataSource(for: $0)
        $0.dataSource = dataSource
        dataSource.apply(createInitialSnapshot())
    }
    
    private lazy var createPlaylistItem = UIBarButtonItem(primaryAction: UIAction(image: UIImage(systemName: "plus")) { [unowned self] _ in
        let alertController = UIAlertController(title: "Create New Playlist", message: nil, preferredStyle: .alert)
        alertController.addTextField {
            $0.placeholder = "Playlist Name"
            $0.clearButtonMode = .always
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
            alertController.dismiss(animated: true)
        })
        
        alertController.addAction(UIAlertAction(title: "Create", style: .default) { [unowned self] _ in
            guard let name = alertController.textFields!.first!.text, !name.isEmpty else {
                return
            }
            Task {
                await createPlaylist(ofName: name)
            }
        })
        present(alertController, animated: true)
    })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Playlists"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Task {
            await fetchPlaylists()
        }
    }
    
    private func fetchPlaylists() async {
        do {
            playlists = try await PlaylistApi.shared.getCurrentUserPlaylists()
            for playlist in playlists {
                viewModels[playlist.id] = createViewModel(from: playlist)
            }
            await dataSource.apply(createCurrentSnapshot())
        } catch {
            // show things like failed to fetch message
        }
    }
       
    private func createViewModel(from playlist: Playlist) -> ItemGroupCellViewModel {
        ItemGroupCellViewModel(
            title: playlist.name,
            image: Formatter.shared.getArtworkImageSource(with: playlist.images),
            itemsCount: .tracks(of: playlist.tracks.count)
        )
    }
    
    override func addSubviews() {
        [
            collectionView
        ].forEach { view.addSubview($0) }
        
        navigationItem.rightBarButtonItem = createPlaylistItem
    }
    
    override func setLayout() {
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func createPlaylist(ofName name: String) async {
        do {
            let playlist = try await PlaylistApi.shared.createPlaylist(ofName: name)
            
            playlists.insert(playlist, at: 0)
            viewModels[playlist.id] = createViewModel(from: playlist)
            
            await dataSource.apply(createCurrentSnapshot())
        } catch {
            // what
        }
    }
    
    
}

extension LibraryPlaylistsViewController {
    
    private func createCollectionViewDataSource(for collectionView: UICollectionView) -> DataSource {
        DataSource(collectionView: collectionView) { [unowned self] collectionView, indexPath, id in
            if id == loaderId {
                return collectionView.dequeueReusableCell(withReuseIdentifier: LoadingIndicatorCell.reuseIdentifier, for: indexPath)
            }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.reuseIdentifier, for: indexPath) as! Cell
            cell.configure(with: viewModels[id]!)
            return cell
        }
    }
    
    private func createInitialSnapshot() -> Snapshot {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems([loaderId], toSection: 0)
        return snapshot
    }
    
    private func createCurrentSnapshot() -> Snapshot {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(playlists.map { $0.id }, toSection: 0)
        return snapshot
    }
    
    
}

extension LibraryPlaylistsViewController {
    
    private func createCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(80)),
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }

    
}

extension LibraryPlaylistsViewController: CanDeletePlaylist {
    
    func deletePlaylist(_ playlist: Playlist) {
        Task {
            do {
                let indexPath = dataSource.indexPath(for: playlist.id)!
                try await PlaylistApi.shared.deletePlaylist(playlist)
                playlists.remove(at: indexPath.row)
                await dataSource.apply(createCurrentSnapshot())
            } catch {
                print("failed")
            }
        }
    }
    
    
}

extension LibraryPlaylistsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let id = dataSource.itemIdentifier(for: indexPath)
        guard id != loaderId else {
            return
        }
        
        let playlist = playlists[indexPath.row]
        selectHandler?(playlist)
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        let indexPath = indexPaths.first!
        let playlist = playlists[indexPath.row]
        
        return UIContextMenuConfiguration(actionProvider: { _ in
            UIMenu(
                children: [self.action(deletePlaylistOf: playlist)]
            )
        })
    }
    
    
}
