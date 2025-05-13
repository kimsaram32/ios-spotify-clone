import UIKit

class LibraryViewController: BaseViewController {
    
    typealias Cell = HorizontalGroupCollectionViewCell
    
    enum ItemType {
        case playlists
        case album
    }
    
    lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: createCollectionViewLayout()
    ).then {
        $0.register(Cell.self, forCellWithReuseIdentifier: Cell.reuseIdentifier)
        $0.dataSource = self
        $0.delegate = self
    }
    
    lazy var playistsViewController = LibraryPlaylistsViewController().then {
        $0.selectHandler = { [unowned self] playlist in
            let vc = PlaylistViewController(playlist: playlist)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    let items: [(type: ItemType, viewModel: ItemGroupCellViewModel)] = [
        (.playlists, ItemGroupCellViewModel(
            title: "Playlists",
            image: UIImage(systemName: "rectangle.stack.fill")!
        )),
        (.album, ItemGroupCellViewModel(
            title: "Albums",
            image: UIImage(systemName: "rectangle.stack.fill")!
        ))
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Library"
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
    
    func createCollectionViewLayout() -> UICollectionViewCompositionalLayout {
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

extension LibraryViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: Cell.reuseIdentifier,
            for: indexPath
        ) as! Cell
        cell.configure(with: items[indexPath.item].viewModel)
        return cell
    }
    
    
}

extension LibraryViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc: UIViewController
        switch items[indexPath.item].type {
        case .playlists:
            vc = playistsViewController
        case .album:
            vc = UIViewController()
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
