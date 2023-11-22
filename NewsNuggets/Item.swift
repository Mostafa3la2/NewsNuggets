//
//  Item.swift
//  NewsNuggets
//
//  Created by Mostafa Alaa on 22/11/2023.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
