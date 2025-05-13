import UIKit
import SDWebImage

protocol ImageSource {
    
    func provideImage() async -> UIImage
    
    func provideImage(to imageView: UIImageView)
    
}

extension UIImageView {
    
    func setImage(with source: ImageSource) {
        source.provideImage(to: self)
    }
    
}

extension UIImage: ImageSource {
    
    func provideImage() -> UIImage {
        return self
    }
    
    func provideImage(to imageView: UIImageView) {
        imageView.image = self
    }
    
}

extension URL: ImageSource {
    
    func provideImage() async -> UIImage {
        return await withCheckedContinuation { continuation in
            SDWebImageManager.shared.loadImage(with: self, progress: nil) { (image, _, _, _, _, _) in
                continuation.resume(returning: image ?? UIImage(systemName: "photo")!)
            }
        }
    }
    
    func provideImage(to imageView: UIImageView) {
        imageView.sd_setImage(with: self)
    }
    
}
