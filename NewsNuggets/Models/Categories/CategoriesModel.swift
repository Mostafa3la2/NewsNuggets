//
//  Categories.swift
//  NewsNuggets
//
//  Created by Mostafa Alaa on 16/12/2023.
//

import Foundation
import SwiftData
@Model class CategoriesModel: Equatable {
    var name: String
    var id: Int
    init(name :String, id: Int = 0) {
        self.name = name
        self.id = id
    }
}
