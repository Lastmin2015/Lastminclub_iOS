//
//  YPImagePickerHelper.swift
//  LastminClub
//
//  Created by Aleksandr Zorin on 10.06.2021.
//

//import UIKit
//import YPImagePicker
//
//class YPImagePickerHelper: NSObject {
//    let config: YPImagePickerConfiguration = {
//        var config = YPImagePickerConfiguration()
//        config.showsPhotoFilters = false
//        config.albumName = "LastminClub"
//        config.startOnScreen = YPPickerScreen.library
//        config.screens = [.library, .photo]
//        // localize
////        config.wordings.albumsTitle  = "Альбом"
////        config.wordings.cameraTitle  = "Камера"
////        config.wordings.cancel       = "Отмена"
////        config.wordings.cover        = "cover"
////        config.wordings.crop         = "crop"
////        config.wordings.done         = "Готово"
////        config.wordings.filter       = "Фильтр"
////        config.wordings.libraryTitle = "Библиотека"
////        config.wordings.next         = "Далее"
////        config.wordings.ok           = "Ок"
//        //
//        //config.icons.capturePhotoImage = UIImage(named: "iconCapture2")!
//        
//        return config
//    }()
//    
//    public func getImage(_ vc: UIViewController, closure: @escaping (UIImage?)->()) {
//        let picker = YPImagePicker(configuration: config)
//        picker.didFinishPicking { [unowned picker] items, _ in
//            if let photo = items.singlePhoto { closure(photo.originalImage) }
//            picker.dismiss(animated: true, completion: nil)
//        }
//        vc.present(picker, animated: true, completion: nil)
//    }
//}
