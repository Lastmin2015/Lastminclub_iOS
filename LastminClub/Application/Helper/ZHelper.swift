//
//  ZHelper.swift
//  LastminClub
//
//  Created by Zorin Aleksandr on 09.04.2021.
//

import Foundation

class ZHelper {}

// MARK: -
extension ZHelper {
    class func nextIndex(_ index: Int, _ count: Int, _ addIndex: Int = +1) -> Int? {
        guard count > 0 else { return nil }
        var nextIndex = index + addIndex
        if nextIndex < 0 { nextIndex = (count - 1) }
        else if nextIndex > (count - 1) { nextIndex = 0 }
        guard (0 <= nextIndex) && (nextIndex <= (count-1)) else { return 0 }
        return nextIndex
    }
}
