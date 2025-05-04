import UIKit
import SDWebImage

struct SearchResultSection {
   
    let title: String
    let items: [(Any, SearchResultCellViewModel)]
    
}

protocol SearchResultViewControllerDelegate: AnyObject {
    
    func didTapResult(for model: Any)
    
}

class SearchResultViewController: UITableViewController {
    
    weak var delegate: SearchResultViewControllerDelegate?
    
    private var sections = [SearchResultSection]()
    
    override func viewDidLoad() {
        tableView.register(
            SearchResultTableViewCell.self,
            forCellReuseIdentifier: SearchResultTableViewCell.reuseIdentifier
        )
        super.viewDidLoad()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = sections[indexPath.section].items[indexPath.row].1
        let cell = tableView.dequeueReusableCell(
            withIdentifier: SearchResultTableViewCell.reuseIdentifier,
            for: indexPath
        ) as! SearchResultTableViewCell
        
        cell.configure(with: viewModel)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sections[section].title
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let delegate {
            let item = sections[indexPath.section].items[indexPath.row]
            delegate.didTapResult(for: item.0)
        }
    }
    
    func updateResult(with searchResult: SearchResult) {
        sections = []
        
        if let albums = searchResult.albums {
            sections.append(transformAlbumsToSection(with: albums))
        }
        
        if let artists = searchResult.artists {
            sections.append(transformArtistsToSection(with: artists))
        }
        
        if let playlists = searchResult.playlists {
            sections.append(transformPlaylistsToSection(with: playlists))
        }
        
        if let tracks = searchResult.tracks {
            sections.append(transformTracksToSection(with: tracks))
        }
        
        tableView.reloadData()
    }
    

}

extension SearchResultViewController {
    
    func transformAlbumsToSection(with albums: [Album]) -> SearchResultSection {
        SearchResultSection(title: "Albums", items: albums.map {
            (
                $0,
                SearchResultCellViewModel(
                    title: $0.name,
                    subtitle: Formatter.shared.formatArtistName(artists: $0.artists),
                    artworkURL: Formatter.shared.getArtworkURL(images: $0.images),
                )
            )
        })
    }
    
    func transformArtistsToSection(with artists: [Artist]) -> SearchResultSection {
        SearchResultSection(title: "Artists", items: artists.map {
            (
                $0,
                SearchResultCellViewModel(
                    title: $0.name,
                    artworkURL: ($0.images != nil) ? Formatter.shared.getArtworkURL(
                        images: $0.images!
                    ) : nil
                )
            )
        })
    }
    
    func transformPlaylistsToSection(with playlists: [Playlist]) -> SearchResultSection {
        SearchResultSection(title: "Playlists", items: playlists.map {
            (
                $0,
                SearchResultCellViewModel(
                    title: $0.name,
                    subtitle: $0.description,
                    artworkURL: Formatter.shared.getArtworkURL(images: $0.images)
                )
            )
        })
    }
    
    func transformTracksToSection(with tracks: [Track]) -> SearchResultSection {
        SearchResultSection(
            title: "Tracks",
            items: tracks.map {
                (
                    $0,
                    SearchResultCellViewModel(
                        title: $0.name,
                        subtitle: $0.album.name,
                        artworkURL: Formatter.shared.getArtworkURL(images: $0.album.images)
                    )
                )
            }
        )
    }
    
}
