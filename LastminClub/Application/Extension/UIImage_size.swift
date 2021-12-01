//
//  UIImage_size.swift
//  LastminClub
//
//  Created by Aleksandr Zorin on 25.05.2021.
//

import UIKit

extension UIImage {
    func cropToBounds(_ width: Double, _ height: Double) -> UIImage {

        let cgimage = self.cgImage!
        let contextImage: UIImage = UIImage(cgImage: cgimage)
        let contextSize: CGSize = contextImage.size
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        var cgwidth: CGFloat = CGFloat(width)
        var cgheight: CGFloat = CGFloat(height)

        // See what size is longer and create the center off of that
        if contextSize.width > contextSize.height {
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
            cgwidth = contextSize.height
            cgheight = contextSize.height
        } else {
            posX = 0
            posY = ((contextSize.height - contextSize.width) / 2)
            cgwidth = contextSize.width
            cgheight = contextSize.width
        }

        let rect: CGRect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)

        // Create bitmap image from context using the rect
        let imageRef: CGImage = cgimage.cropping(to: rect)!

        // Create a new image based on the imageRef and rotate back to the original orientation
        let image: UIImage = UIImage(cgImage: imageRef, scale: self.scale, orientation: self.imageOrientation)

        return image
    }
    //
    func resizeToAva() -> UIImage {
        let newSize: CGSize!
        if size.height > size.width { newSize = CGSize(width: size.width, height: size.width) }
        else if size.height < size.width { newSize = CGSize(width: size.height, height: size.height) }
        else { return self }
        return self.cropToBounds(Double(newSize.width), Double(newSize.height))
    }
}
