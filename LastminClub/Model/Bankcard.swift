//
//  Bankcard.swift
//  LastminClub
//
//  Created by Zorin Aleksandr on 26.04.2021.
//

import Foundation

public class Bankcard: Codable {
    var id: String = ""
    var payMethod: PayMethod = .bankcard
    var number: String = ""
    var holder: String = ""
    var expiry: String = ""
    var cvv: String = ""
    var postcode: String = ""
    //var isMain: Bool = false
    //var cryptoPacket = ""
    
    //Extra
    //var expDate: String { return "\(month)/\(year)" } //Срок действия в формате MM/yy
    
    init() {}
//    init(id: String, number: String, holder: String, date: String, cvv: String) {
//        self.id = id
//        self.payMethod = .bankcard
//        self.number = number
//        self.holder = holder
//        //self.month = Bankcard.getMYstrByDate(date).0
//        //self.year = Bankcard.getMYstrByDate(date).1
//        self.cvv = cvv
//    }
//    
//    init(payMethod: PayMethod) {
//        self.payMethod = payMethod
//    }
}

// MARK: - HelpersFuncs
extension Bankcard {
//    static func typeCardImageByNumber(_ number: String) -> UIImage? {
//        guard let type = CreditCardValidator().type(from: number) else { return nil }
//        switch type.name {
//        case "Visa": return UIImage(named: "bc_visa")
//        case "MasterCard": return UIImage(named: "bc_maestro")
//        default: return nil
//        }
//    }
//    func typeCardImage() -> UIImage? { return Bankcard.typeCardImageByNumber(number) }
    func securityNumber() -> String {
        //guard let number = number else { return "" }
        let last4 = String("\(number)".suffix(4))
        return "••••  \(last4)"
    }
////    func dateExpire() -> String {
////        guard let dM = dateMonth, let dY = dateYear else { return "" }
////        return "\(String(format: "%02d", dM))/\(String(format: "%02d", dY))"
////    }
//    static func getMYstrByDate(_ dateStr: String) -> (String, String) {
//        let strList = dateStr.components(separatedBy: "/")
//        guard strList.count == 2 else { return ("", "") }
//        return (strList[0], strList[1])
//    }
//    func identifier() -> String {
//        var res = ""
//        res += "\(id)"
//        res += "\(number)"
//        res += "\(holder)"
//        res += "\(month)\(year)"
//        return res
//    }
//    func setMain() {
//        appService.bankcardList.forEach { $0.isMain = false }
//        self.isMain = true
//        Bankcard.save()
//    }
//    static func getMain() -> Bankcard? {
//        return Bankcard.list().first(where: { $0.isMain })
//    }
//    func isValid() -> String? {
//        var textError: String = ""
//        if !Card.isCardNumberValid(number) {
//            textError = textError.addPart("Введите корректный номер карты", "\n")
//        }
//        if !Card.isExpDateValid(expDate) {
//            textError = textError.addPart("Введите дату окончания действия карты в формате MM/YY", "\n")
//        }
//        if !(cvv.count == 3) {
//            textError = textError.addPart("Введите CVV код", "\n")
//        }
//        if holder.isEmpty {
//            textError = textError.addPart("Введите имя владельца карты", "\n")
//        }
//
//        return textError.isEmpty ? nil : textError
//    }
//    func cardCryptogramPacket() -> String? {
//        // Создаем объект Card
//        let card = Card()
//        // Создаем криптограмму карточных данных
//        let cardCryptogramPacket = card.makeCryptogramPacket(number, andExpDate: expDate, andCVV: cvv, andMerchantPublicID: AppSettings.merchantPulicId)
//        guard let packet = cardCryptogramPacket else {
//            print("Ошибка при создании крипто-пакета")
//            return nil
//        }
//        print("cardCryptogramPacket: \(packet)")
//        return packet
//    }
}

//// MARK: - Save/Load Locally
//extension Bankcard {
//    // MARK: CodableList
//    func getDict() -> [String: Any]? { return self.values }
//    static func getDictOfList(_ list: [Bankcard]) -> [[String: Any]] {
//        var dictList: [[String: Any]] = []
//        list.forEach { if let dict = $0.getDict() { dictList.append(dict) } }
//        return dictList
//    }
//    static func listFromDictList(_ dictList: [[String: Any]]) -> [Bankcard] {
//        return parseDict<Bankcard>().getList(dictList)
//    }
//    // MARK: - Locally
//    func add() {
//        appService.bankcardList = appService.bankcardList.filter({$0.identifier() != self.identifier()})
//        appService.bankcardList.append(self)
//        Bankcard.save()
//    }
//    static func save() { LocallyData.save_kbankcardList(appService.bankcardList) }
//    static func load() { appService.bankcardList = LocallyData.load_kbankcardList() }
//    func remove() {
//        appService.bankcardList = appService.bankcardList.filter { $0.identifier() != self.identifier() }
//        Bankcard.save()
//    }
//    static func list() -> [Bankcard] { return appService.bankcardList }
//}
