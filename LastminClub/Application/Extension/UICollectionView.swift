//
//  UICollectionView.swift
//  LastminClub
//
//  Created by Zorin Aleksandr on 09.04.2021.
//

import UIKit

extension UICollectionView {
    func registerCellNib(_ nibName: String) {
        let nibIdentifier = nibName.replacingOccurrences(of: "CollectionView", with: "")
        let cellNib = UINib(nibName: nibName, bundle: nil)
        self.register(cellNib, forCellWithReuseIdentifier: nibIdentifier)
    }
    func getCell<T: UICollectionViewCell>(_ indexPath: IndexPath) -> T {
        let nibIdentifier = T.className.replacingOccurrences(of: "CollectionView", with: "")
        return self.dequeueReusableCell(withReuseIdentifier: nibIdentifier, for: indexPath) as! T
    }
}

// MARK: - Tap
extension UICollectionViewCell {
    func addTapGesture(_ tapView: UIView) {
        tapView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        tapView.isUserInteractionEnabled = true
    }
    
    @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        //guard let tag = gestureRecognizer.view?.tag else { return }
    }
}
