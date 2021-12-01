//
//  UIImage.swift
//  LastminClub
//
//  Created by Aleksandr Zorin on 10.06.2021.
//

import UIKit

// MARK: Image -> Data
extension UIImage {
    func toJPEGData(_ maxSize: Double? = nil, _ quality: CGFloat = 1) -> Data? {
        guard let data = self.jpegData(compressionQuality: quality) else { return nil }
        guard let maxSize = maxSize else { return data }
        
        let size = Double(data.count)  / 1024.0 / 1024
        print("size of image in MB: %f of \(maxSize)", size)
        
        if size <= maxSize { return data }
        else { return self.toJPEGData(maxSize, quality - 0.1) }
    }
}
