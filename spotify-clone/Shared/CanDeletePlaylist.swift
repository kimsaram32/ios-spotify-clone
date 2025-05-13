import UIKit

protocol CanDeletePlaylist: UIViewController {
    
    func deletePlaylist(_ playlist: Playlist)
    
}

extension CanDeletePlaylist {
    
    func action(deletePlaylistOf playlist: Playlist) -> UIAction {
        UIAction(
            title: "Delete Playlist",
            image: UIImage(systemName: "trash"),
            attributes: .destructive
        ) { _ in
            let alertController = UIAlertController(
                title: "Delete Playlist",
                message: "Delete playlist \"\(playlist.name)\"?",
                preferredStyle: .alert
            )
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
                alertController.dismiss(animated: true)
            })
            alertController.addAction(UIAlertAction(title: "Delete", style: .destructive) { [unowned self] _ in
                self.deletePlaylist(playlist)
            })
            self.present(alertController, animated: true)
        }
    }
    
    
}
