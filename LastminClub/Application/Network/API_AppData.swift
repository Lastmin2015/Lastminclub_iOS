//
//  API_AppData.swift
//  LastminClub
//
//  Created by Aleksandr Zorin on 25.05.2021.
//

import Foundation

// MARK: - load_Data
extension API {
    static func load_Data_User(closure: @escaping (_ error: ErrorApp?) -> ()) {
        let dispatchGroup = DispatchGroup()
        let semaphore = DispatchSemaphore(value: 1)
        let queue0 = DispatchQueue(label: "ru.aazorin.queue0", attributes: .concurrent)
        let queue1 = DispatchQueue(label: "ru.aazorin.queue1", attributes: .concurrent)
        //let queue2 = DispatchQueue(label: "ru.aazorin.queue2", attributes: .concurrent)
        //let queue3 = DispatchQueue(label: "ru.aazorin.queue3", attributes: .concurrent)
        //let queue4 = DispatchQueue(label: "ru.aazorin.queue4", attributes: .concurrent)
        
        // user
        dispatchGroup.enter()
        queue0.async {
            semaphore.wait()
            API.user { (result) in
                switch result {
                case .failure(let error): print(error); closure(error)
                case .success(let user):
                    appService.user = user
                    print("load user")
                    dispatchGroup.leave()
                }
                semaphore.signal()
            }
        }
        
        // userPhoto
        dispatchGroup.enter()
        queue1.async {
            semaphore.wait()
            guard let path = appService.user?.fullPathPhoto, !path.isEmpty else {
                dispatchGroup.leave()
                semaphore.signal()
                return
            }
            KingfisherHelper.getImage(path.encodeUrl) { (image) in
                appService.userPhoto = image?.resizeToAva()
                print("load userPhoto")
                dispatchGroup.leave()
                semaphore.signal()
            }
        }
        
//        // shopInfo
//        dispatchGroup.enter()
//        queue2.async {
//            semaphore.wait()
//            API.shopInfo { (result) in
//                switch result {
//                case .failure(let error): print(error); closure(error); return
//                case .success(let item):
//                    appService.shopInfo = item
//                    print("load shopInfo: banners=\(item.bannerList?.count ?? 0)")
//                    dispatchGroup.leave()
//                    semaphore.signal()
//                }
//            }
//        }
//
//        // appStoreVersion
//        dispatchGroup.enter()
//        queue3.async {
//            semaphore.wait()
//            API.appStoreVersion { (result) in
//                switch result {
//                case .failure(let error): print(error)
//                case .success(let version):
//                    appService.appStoreVersion = version
//                    print("appStoreVersion: \(version)")
//                }
//                dispatchGroup.leave()
//                semaphore.signal()
//            }
//        }
//
//        // challengeSuper
//        dispatchGroup.enter()
//        queue4.async {
//            semaphore.wait()
//            API.challengeSuper { (result) in
//                switch result {
//                case .failure(let error): print(error)
//                case .success(let item):
//                    appService.chSuper = item
//                    print("challengeSuper:  -> \(item.countUser)")
//                }
//                dispatchGroup.leave()
//                semaphore.signal()
//            }
//        }
        
        // Total
        dispatchGroup.notify(queue: DispatchQueue.main) {
            closure(nil)
            print("notify: load_Data_User")
        }
    }
    static func load_Data_Shop(closure: @escaping (_ error: ErrorApp?) -> ()) {
        let dispatchGroup = DispatchGroup()
        let semaphore = DispatchSemaphore(value: 1)
//        let queue0 = DispatchQueue(label: "ru.aazorin.queue0", attributes: .concurrent)
        let queue1 = DispatchQueue(label: "ru.aazorin.queue1", attributes: .concurrent)
        let queue2 = DispatchQueue(label: "ru.aazorin.queue2", attributes: .concurrent)


        // countryList
        dispatchGroup.enter()
        queue1.async {
            semaphore.wait()
            let dict: JSON = ["with_data": true, "locale": Language.current.iosId]
            API.countryList(dict) { (result) in
                switch result {
                case .failure(let error): print(error); closure(error)
                case .success(let list):
                    appService.countryList = list
                    print("load countryList: \(list.count)")
                }
                dispatchGroup.leave()
                semaphore.signal()
            }
        }
        
        // cityList
        dispatchGroup.enter()
        queue2.async {
            semaphore.wait()
            let dict: JSON = ["with_data": true, "locale": Language.current.iosId]
            API.cityList(dict) { (result) in
                switch result {
                case .failure(let error): print(error); closure(error)
                case .success(let list):
                    appService.cityList = list
                    print("load cityList: \(list.count)")
                }
                dispatchGroup.leave()
                semaphore.signal()
            }
        }

        // Total
        dispatchGroup.notify(queue: DispatchQueue.main) {
            closure(nil)
            print("notify: load_Data_Shop")
        }
    }
}
