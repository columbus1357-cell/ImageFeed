//
//  Array+Extensions.swift
//  ImageFeed
//
//  Created by Aleksandr on 29.09.2026.
//

import Foundation

extension Array {
    func withReplaced(itemAt index: Int, newValue: Element) -> [Element] {
        var array = self
        array[index] = newValue
        return array
    }
}
