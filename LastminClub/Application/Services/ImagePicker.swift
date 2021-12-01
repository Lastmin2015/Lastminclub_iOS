//
//  ImagePicker.swift
//  LastminClub
//
//  Created by Aleksandr Zorin on 10.06.2021.
//
//https://ikyle.me/blog/2020/phpickerviewcontroller

import UIKit

public protocol ImagePickerDelegate: class {
    func didSelect(image: UIImage?)
}

open class ImagePicker: NSObject {
    // MARK: Public Properties
    public enum TypeAction {
        case all
        case camera
        case library
        
        func isChooseType(_ type: UIImagePickerController.SourceType) -> Bool {
            switch self {
            case .all: return true
            case .camera: return (type == .camera)
            case .library: return (type == .photoLibrary) || (type == .savedPhotosAlbum)
            }
        }
    }
    
    // MARK: Private Properties
    private let pickerController: UIImagePickerController
    private weak var presentationController: UIViewController?
    private weak var delegate: ImagePickerDelegate?
    
    // MARK: - Initializers
    public init(presentationController: UIViewController, delegate: ImagePickerDelegate) {
        self.pickerController = UIImagePickerController()
        
        super.init()
        
        self.presentationController = presentationController
        self.delegate = delegate
        
        self.pickerController.delegate = self
        self.pickerController.allowsEditing = true//???
        self.pickerController.mediaTypes = ["public.image"]
    }
}

// MARK: - Private Methods
extension ImagePicker {
    private func prepareAlertVC(from sourceView: UIView) {
        let alertVC = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        //Take photo | Camera roll | Photo library | Cancel
        if let action = self.action(for: .camera, title: "Camera") { alertVC.addAction(action) }
        //if let action = self.action(for: .savedPhotosAlbum, title: "Выбрать фото") { alertVC.addAction(action) }
        if let action = self.action(for: .photoLibrary, title: "Choose photo") { alertVC.addAction(action) }//Фотопленка
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            alertVC.popoverPresentationController?.sourceView = sourceView
            alertVC.popoverPresentationController?.sourceRect = sourceView.bounds
            alertVC.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        }
        
        self.presentationController?.present(alertVC, animated: true)
    }
    private func action(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else { return nil }
        
        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            self.pickerController.sourceType = type
            self.presentationController?.present(self.pickerController, animated: true)
        }
    }
    
    private func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage?) {
        controller.dismiss(animated: true, completion: nil)
        self.delegate?.didSelect(image: image)
    }
}

// MARK: - UIImagePickerControllerDelegate
extension ImagePicker: UIImagePickerControllerDelegate {
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.pickerController(picker, didSelect: nil)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.editedImage] as? UIImage else { return self.pickerController(picker, didSelect: nil) }
        self.pickerController(picker, didSelect: image)
    }
}

// MARK: - UINavigationControllerDelegate
extension ImagePicker: UINavigationControllerDelegate {
}

// MARK: - Public Methods
extension ImagePicker {
    public func present(from sourceView: UIView, typeAction: TypeAction = .all) {
        let type: UIImagePickerController.SourceType!
        switch typeAction {
        case .all: prepareAlertVC(from: sourceView); return
        case .camera: type = .camera
        case .library: type = .photoLibrary
        }
        guard UIImagePickerController.isSourceTypeAvailable(type) else { return }
        pickerController.sourceType = type
        presentationController?.present(self.pickerController, animated: true)
    }
}
