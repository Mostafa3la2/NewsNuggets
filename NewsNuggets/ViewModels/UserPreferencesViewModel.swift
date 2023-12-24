//
//  UserPreferencesViewModel.swift
//  NewsNuggets
//
//  Created by Mostafa Alaa on 16/12/2023.
//

import Foundation

protocol UserPreferencesViewModelProtocol {
    var userCategories: [CategoriesModel] { get }
    var storedCategories: [CategoriesModel] { get }
    func addCategory(category: CategoriesModel)
    func deleteCategory(category: CategoriesModel)
}
