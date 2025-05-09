import UIKit
import SnapKit
import Then

class SearchViewController: BaseViewController {
    
    lazy var searchController = UISearchController(searchResultsController: SearchResultViewController()).then {
        let resultsController = $0.searchResultsController as! SearchResultViewController
        resultsController.delegate = self
        $0.searchBar.placeholder = "Songs, Artists, Albums"
        $0.searchResultsUpdater = self
    }
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout()).then {
        $0.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.reuseIdentifier)
        $0.dataSource = self
        $0.delegate = self
    }
    
    var categoryViewModels = [CategoryCellViewModel]()
    
    var searchResultWorkItem: DispatchWorkItem?
    
    override func viewWillAppear(_ animated: Bool) {
        Task {
            await fetchCategories()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Search"
        view.backgroundColor = .systemBackground
        
        navigationItem.searchController = searchController
    }
    
    func fetchCategories() async {
        do {
            let categories = try await CategoryApi.shared.getCategories()
            categoryViewModels = categories.map {
                CategoryCellViewModel(
                    name: $0.name,
                    iconImageURL: Formatter.shared.getArtworkURL(images: $0.icons)
                )
            }
            collectionView.reloadData()
        } catch {
            print(error)
        }
    }
    
    override func addSubviews() {
        [
            collectionView
        ].forEach { view.addSubview($0) }
    }
    
    override func setLayout() {
        collectionView.snp.makeConstraints {
            $0.verticalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview().inset(4)
        }
    }
    

}

extension SearchViewController {
    
    func createCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1))
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(120)),
            repeatingSubitem: item,
            count: 2
        )
        group.interItemSpacing = .fixed(10)
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 18
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    
}

extension SearchViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CategoryCollectionViewCell.reuseIdentifier, for: indexPath
        ) as! CategoryCollectionViewCell
        let viewModel = categoryViewModels[indexPath.row]
        cell.configure(with: viewModel)
        return cell
    }
    
    
}


extension SearchViewController: UICollectionViewDelegate {}

extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchResultController = searchController.searchResultsController as! SearchResultViewController
        guard let query = searchController.searchBar.text,
            !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        
        searchResultWorkItem?.cancel()
        searchResultWorkItem = DispatchWorkItem {
            Task {
                do {
                    let searchResult = try await SearchApi.shared.search(query: query)
                    searchResultController.updateResult(with: searchResult)
                } catch {
                    print(error)
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: searchResultWorkItem!)
    }
    
    
}

extension SearchViewController: SearchResultViewControllerDelegate {
    
    func didTapResult(for model: Any) {
        var vc: UIViewController?
        
        if let model = model as? Album {
            // todo
        } else if let model = model as? Artist {
            // todo
        } else if let model = model as? Playlist {
            vc = PlaylistViewController(playlist: model)
        } else if let model = model as? Track {
            // todo
        }
        
        if let vc {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
