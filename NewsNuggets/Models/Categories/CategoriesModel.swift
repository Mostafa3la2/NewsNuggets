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
    init(name: String) {
        self.name = name
    }
}
