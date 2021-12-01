//
//  Dictionary.swift
//  LastminClub
//
//  Created by Aleksandr Zorin on 08.11.2021.
//

import Foundation

//словарь в строку запроса
extension Dictionary {
    var queryString: String {
        var output: String = ""
        self.forEach { (key, value) in
            if let list = value as? Array<AnyObject> {
                list.forEach { output += "\(key)=\($0)&" }
            } else { output += "\(key)=\(value)&" }
        }
        output = String(output.dropLast())
        output = !output.isEmpty ? "?\(output)" : ""
        return output
    }
}
