//
//  ParseService.swift
//  LastminClub
//
//  Created by Zorin Aleksandr on 26.03.2021.
//

import Foundation

class parseDict<T: Decodable> {
    func getObject(_ objectDict: [String: Any]) -> T? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: objectDict, options: [])
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .secondsSince1970
            let object = try decoder.decode(T.self, from: jsonData)
            //print("parseDict \(type(of: T.self)): \(object)")
            return object
        } catch {
            print("Error: Couldn't decode data into \(type(of: T.self))")
            print(error.localizedDescription)
        }
        return nil
    }
    func getList(_ objectDict: [[String: Any]]) -> [T] {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: objectDict, options: [])
            let decoder = JSONDecoder()
            //decoder.dateDecodingStrategy = .secondsSince1970
            let objectList = try decoder.decode([T].self, from: jsonData)
            //print("parseDict \(type(of: T.self)): \(objectList)")
            return objectList
        } catch {
            print("Error: Couldn't decode data into \(type(of: T.self))")
            print(error.localizedDescription)
        }
        return []
    }
}
