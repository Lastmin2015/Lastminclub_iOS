//
//  BankEnum.swift
//  LastminClub
//
//  Created by Zorin Aleksandr on 26.03.2021.
//

import Foundation

typealias Tokens = (tokenAccess: String, tokenRefresh: String)
typealias Period = (date0: Date?, date1: Date?)
typealias JSON = [String: Any]

// MARK: - TypeAuth
public enum TypeAuth: String, Codable {
    case email
    case facebook
    case google
    case apple
    
    var id: String { return self.rawValue }
}

// MARK: - PayMethod
public enum PayMethod: String, Codable {
    case bankcard
    case applePay
}

// MARK: - TypeCell
public enum TypeCell {
    case select
    case open
}
