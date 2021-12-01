//
//  String.swift
//  LastminClub
//
//  Created by Zorin Aleksandr on 31.03.2021.
//

import Foundation

// MARK: -
extension String {
    func clearSpace() -> String { return self.replacingOccurrences(of: " ", with: "") }
    func addPart(_ part: String?, _ separator: String) -> String {
        guard let part = part else { return self }
        return self.isEmpty ? part : "\(self)\(separator)\(part)"
    }
}

// MARK: - Decoder url
extension String {
    var encodeUrl : String {
        return self.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
    }
    var decodeUrl : String { return self.removingPercentEncoding! }
}
