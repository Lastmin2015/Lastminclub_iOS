//
//  Language.swift
//  LastminClub
//
//  Created by Aleksandr Zorin on 08.11.2021.
//

import Foundation

// MARK: Language
public enum Language: String, Codable, CaseIterable {
    case english = "en-US"
    case russian = "ru-Ru"
}

// MARK: - Variables
extension Language {
    var id: String { return self.rawValue }
    var name: String {
        switch self {
        case .english: return "English"
        case .russian: return "Русский"
        }
    }
    var iosId: String {
        switch self {
        case .english: return "en"
        case .russian: return "ru"
        }
    }
    var tag: Int {
        switch self {
        case .english: return 2
        case .russian: return 1
        }
    }
    // static Property
    static let main: Language = .english // default language
    static var list: [Language] { return Language.allCases }
    static var current: Language { return ldService.language } // текущий язык
}

// MARK: - Functions
extension Language {
    static func getById(_ id: String) -> Language? { return Language(rawValue: id) }
    static func getByIosId(_ iosId: String) -> Language? {
        return Language.list.first(where: { $0.iosId == iosId })
    }
    static func getByTag(_ tag: Int) -> Language? {
        switch tag {
        case Language.english.tag: return .english
        case Language.russian.tag: return .russian
        default: return nil
        }
    }
}

//// MARK: - Save/Load
//extension Language {
//    static func checkLanguageApp() {
//        guard !ldService.isExistLanguage else { return }
//
//        let deviceLngId = Locale.preferredLanguageCode
//        let deviceLngIdList = Locale.preferredLanguageCodes
//        if let item = Language.getByIosId(deviceLngId) {
//            ldService.language = item
//        } else if let item = Language.list.first(where: { deviceLngIdList.contains($0.iosId) }) {
//            ldService.language = item
//        } else { ldService.language = Language.main }
//    }
//}
