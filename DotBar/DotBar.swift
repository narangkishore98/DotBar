//
//  DotBar.swift
//  DotBar
//
//  Created by Kishore Narang on 2023-02-17.
//

import Foundation

public final class DotBar {
    let name = "DotBar"
    
    public func add(numbers: [Int]) -> Int {
        return numbers.reduce(0, +)
    }
}
