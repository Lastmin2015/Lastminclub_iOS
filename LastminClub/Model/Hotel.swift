//
//  Hotel.swift
//  LastminClub
//
//  Created by Zorin Aleksandr on 26.04.2021.
//
//https://jsoneditoronline.org/#left=local.pevino&right=local.giwoni

import Foundation

class Hotel {
    var id: String
    var name: String
    var location: String = ""
    var pathPhoto: String?//81-97
    var pathPhotoBig: String?//375-222
    var pathPhotoList: [String] = []
    var distCity: String = ""
    var distSea: String = ""
    var distAirport: String = ""
    var info_main: String = ""
    var info_details: String = ""
    
    //Extra
    
    // MARK: - Initializers
    init?(json: JSON) {
        guard
            let id = json["id"] as? String,
            let name = json["name"] as? String
        else { return nil }

        self.id = id
        self.name = name
        if let distCity = json["distance_to_city"] as? Int {
            self.distCity = "\(distCity)"
        }
        if let distSea = json["distance_to_beach"] as? Int {
            self.distSea = "\(distSea)"
        }
        if let distAirport = json["distance_to_slope"] as? Int {
            self.distAirport = "\(distAirport)"
        }
        //
        self.info_main = (json["hotel_descriptions"] as? [JSON] ?? []).first?["description"] as? String ?? ""
        
        
        // photo
        self.pathPhotoList = (json["hotel_images"] as? [JSON] ?? []).compactMap({$0["file_name"]}).map({"\(MethodAPI().basePath)storage/\($0)"})
        self.pathPhoto = self.pathPhotoList.first
        self.pathPhotoBig = self.pathPhotoList.first
        // location
        
    }
}

// MARK: - HelpersFunctions
extension Hotel {
    func showAllPath() {
        //let pathHost = "http://www.harbor.digital/test/assets/lastmin/"
        print(name)
        print("cover V: \(pathPhoto)")
        print("cover H: \(pathPhotoBig)")
        print("Full:")
        pathPhotoList.forEach { print($0) }
    }
}

// MARK: - Favorite
extension Hotel {
    // isFavorite
    func isFavorite() -> Bool { return appService.favHotelIdList.contains(self.id) }
    // appService
    func favoriteAdd() {
        self.favoriteDelete()
        appService.favHotelIdList.append(self.id)
        Hotel.saveLocally()
    }
    func favoriteDelete() {
        appService.favHotelIdList = appService.favHotelIdList.filter {$0 != self.id}
        Hotel.saveLocally()
    }
    //
    static func saveLocally() { LocallyData.save_favHotelIdList(appService.favHotelIdList) }
    static func loadLocally() { appService.favHotelIdList = LocallyData.load_favHotelIdList() }
    // API
//    func favoriteAddByAPI(closure: @escaping (_ error: APIError?) -> ()) {
//        let dict: [String: Any] = ["product_id": self.id]
//        API.favoriteAdd(dict) { (error) in
//            if let error = error { print("😈 \(error.text)"); return }
//            self.favoriteAdd()
//            closure(nil)
//        }
//    }
//    func favoriteDeleteByAPI(closure: @escaping (_ error: APIError?) -> ()) {
//        API.favoriteDelete(self.id) { (error) in
//            if let error = error { print("😈 \(error.text)"); return }
//            self.favoriteDelete()
//            closure(nil)
//        }
//    }
//    static func favoriteListLoad(closure: @escaping (_ error: APIError?) -> ()) {
//        API.favoriteList { (result) in
//            switch result {
//            case .failure(let error): print(error); closure(error); return
//            case .success(let list):
//                appService.favoriteList = list
//                closure(nil)
//            }
//        }
//    }
}

// MARK: - Demo
//extension Hotel {
//    static func demo1() -> Hotel {
//        let pathHost = "http://www.harbor.digital/test/assets/lastmin/"
//        let item = Hotel(name: "Transatlantic  Hotel & Spa")
//        item.location = "Turkey, Antalya, Kemer, Goynuk"
//        item.pathPhoto = pathHost + "transatlantik/transatlantik-listing-cover-1.jpg"
//        item.pathPhotoBig = pathHost + "transatlantik/transatlantik-tile--cover-2.jpg"
//        item.pathPhotoList = [pathHost + "transatlantik/transatlantik_full_1.jpg",
//                              pathHost + "transatlantik/transatlantik_full_2.jpg",
//                              pathHost + "transatlantik/transatlantik_full_3.jpg",
//                              pathHost + "transatlantik/transatlantik_full_4.jpg",
//                              pathHost + "transatlantik/transatlantik_full_5.jpg",
//                              pathHost + "transatlantik/transatlantik_full_6.jpg",
//                              pathHost + "transatlantik/transatlantik_full_7.jpg"]
//        item.distCity = "3.3km"
//        item.distSea = "200m"
//        item.distAirport = "34km"
//        item.info_main = "Designed to resemble a ship, this 5-star resort in Kemer enjoys a long stretch of sandy beach and an amazing pool scene with an aquapark. Personalised spa treatments include exotic massages.\nRooms at Transatlantik Hotel & Spa have a light, neutral décor. Each features a spacious seating area with a satellite LCD TV."
//        item.info_details = "•  Built in 2014, renovated in 20017-2018\n•  Area 186 000 square meters\n•  Rooms: 452\n•  4 a la carte restaurants\n•  4 bars\n•  7 swiiming pools\n•  Aquapark\n•  Miniclub\n•  Spa centre"
//        
//        return item
//        //https://tophotels.ru/hotel/al17371
//    }
//    static func demo2() -> Hotel {
//        let pathHost = "http://www.harbor.digital/test/assets/lastmin/"
//        //http://www.harbor.digital/test/assets/lastmin/sherwood/sherwood_full_1.jpg
//        let item = Hotel(name: "Sherwood Exclusive Kemer")
//        item.location = "Turkey, Antalya, Kemer, Goynuk"
//        item.pathPhoto = pathHost + "sherwood/cover_list.jpg"
//        item.pathPhotoBig = pathHost + "sherwood/sherwood-slider-2.jpg"
//        item.pathPhotoList =
//            [pathHost + "sherwood/sherwood_full_1.jpg",
//             pathHost + "sherwood/sherwood_full_2.jpg",
//             pathHost + "sherwood/sherwood_full_3.jpg",
//             pathHost + "sherwood/sherwood_full_4.jpg",
//             pathHost + "sherwood/sherwood_full_5.jpg",
//             pathHost + "sherwood/sherwood_full_6.jpg",
//             pathHost + "sherwood/sherwood_full_7.jpg"]
//        item.distCity = "40km"
//        item.distSea = "100m"
//        item.distAirport = "45km"
//        item.info_main = "This property is 5 minutes walk from the beach. Offering extensive and unique facilities specifically tailored for kids, Sherwood Exclusive Kemer comes with a designated area equipped with movie screening sessions, kids sleeping rooms and variety of game room. You will find pools for children and babies. Eco-friendly activities are also offered such as tree and flower planting.\nThe hotel offers ultra all-inclusive service including meals at all its restaurants and selected beverages. Guests can enjoy Turkish, Italian, Chinese or fish specialties in à la carte restaurants. The bars serve a variety of drinks and beverages throughout the day. Antalya city centre is 40 km and Antalya Airport is 45 km from Sherwood Club Kemer. This property also has one of the best-rated locations in Goynuk! Guests are happier about it compared to other properties in the area."
//        item.info_details = "•  Built in 2014, renovated in 20017-2018\n•  Area 186 000 square meters\n•  Rooms: 452\n•  4 a la carte restaurants\n•  4 bars\n•  7 swiiming pools\n•  Aquapark\n•  Miniclub\n•  Spa centre"
//        
//        return item
//        //https://tophotels.ru/hotel/al17371
//    }
//}
