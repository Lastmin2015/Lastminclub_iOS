//
//  KingfisherHelper.swift
//  LastminClub
//
//  Created by Zorin Aleksandr on 26.04.2021.
//

import Foundation
import Kingfisher

class KingfisherHelper {
    static func clearCache() {
        let cache = ImageCache.default
        // Remove all.
        cache.clearMemoryCache()
        cache.clearDiskCache { print("Done") }

        // Remove only expired.
        cache.cleanExpiredMemoryCache()
        cache.cleanExpiredDiskCache { print("Done") }
    }
}

// MARK: - Loadersfunctions
extension KingfisherHelper {
    static func getImage(_ path: String?, closure: @escaping (_ image: UIImage?) -> Void) {
        guard let path = path, let url = URL(string: path) else { closure(nil); return }
        
        let downloader = ImageDownloader.default
        downloader.downloadImage(with: url) { result in
            switch result {
            case .success(let value): closure(value.image)
            case .failure(let error): closure(nil); print(error)
            }
        }
    }
}

extension UIImageView {
    func load_kf(_ path: String?, closure: @escaping (_ img: UIImage?) -> Void ) {
        //print(path)
        guard let path = path, let url = URL(string: path)
        //else { self.image = nil; return }
        else { DispatchQueue.main.async { self.image = nil }; return }
        
        let resource = ImageResource(downloadURL: url)//, cacheKey: "\(item.id)"
        let ivSize = self.bounds.size
        //print("loadIV ivSize: \(ivSize)")
        let processor = DownsamplingImageProcessor(size: ivSize)
        //let processor = ResizingImageProcessor(referenceSize: ivSize, mode: .aspectFill) |> CroppingImageProcessor(size: ivSize)
        
        self.kf.indicatorType = .activity
        self.kf.setImage(
            with: resource,
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(0.5)),
                .cacheOriginalImage
            ]) {
            result in
            switch result {
            case .success(let value): closure(value.image)
            case .failure(let error): closure(nil); print("ERROR: \(error.localizedDescription)")
            }
        }
    }
}
