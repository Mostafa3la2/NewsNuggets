//
//  CategoriesFetcher.swift
//  NewsNuggets
//
//  Created by Mostafa Alaa on 16/12/2023.
//

import Foundation
import SwiftData

protocol CategoriesManagable {
    var modelContext: ModelContext { get }
    func fetchCategories() -> [CategoriesModel]?
    func addCategoryAndRefresh(category: CategoriesModel) -> [CategoriesModel]?
    func deleteCategoryAndRefresh(category: CategoriesModel) -> [CategoriesModel]?
}

class CategoriesManager: CategoriesManagable {
    var modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    func fetchCategories() -> [CategoriesModel]? {
        do {
            let descriptor = FetchDescriptor<CategoriesModel>(sortBy: [SortDescriptor(\.name)])
            var categories = try modelContext.fetch(descriptor)
            return categories
        } catch {
            print("Fetch failed")
        }
        return nil
    }
    
    func addCategoryAndRefresh(category: CategoriesModel) -> [CategoriesModel]? {
        modelContext.insert(category)
        return fetchCategories()
    }
    
    func deleteCategoryAndRefresh(category: CategoriesModel) -> [CategoriesModel]? {
        modelContext.delete(category)
        return fetchCategories()
    }
}
