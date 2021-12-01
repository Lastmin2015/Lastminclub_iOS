//
//  Number.swift
//  LastminClub
//
//  Created by Zorin Aleksandr on 26.04.2021.
//

import Foundation

extension Double {
    func round(to places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension Float {
    func round(to places: Int) -> Float {
        let divisor = powf(10.0, Float(places))
        return (self * divisor).rounded() / divisor
    }
}

extension Double {
//    func toMoney() -> String {
//        //return String(format: "%.2f", self) + (isShowValuta ? " ₽" : "")
//        let formatter = NumberFormatter()
//        formatter.locale = Locale.current
//        formatter.numberStyle = .currency
////        formatter.groupingSeparator = " "
////        formatter.decimalSeparator = "."
////        formatter.minimumFractionDigits = 0//fractionDigits
////        formatter.maximumFractionDigits = 2
////        return formatter.string(from: NSNumber(value: self))! + (isShowValuta ? " €" : "")
//        return formatter.string(from: self as NSNumber) ?? "\(self)"
//    }
    func toMoney(_ isShowValuta: Bool = true, _ fractionDigits: Int = 2) -> String {
        //return String(format: "%.2f", self) + (isShowValuta ? " ₽" : "")
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        formatter.decimalSeparator = "."
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = fractionDigits
        let nfStr = formatter.string(from: self as NSNumber) ?? "\(self)"
        return "€\(nfStr)"
    }
}
