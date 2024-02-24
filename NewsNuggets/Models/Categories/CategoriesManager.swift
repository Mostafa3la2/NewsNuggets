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
    func getAllCategories() -> [CategoriesModel]?
}

class CategoriesManager: CategoriesManagable {
    var modelContext: ModelContext
    var allCategories: [CategoriesModel] = []
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    func fetchCategories() -> [CategoriesModel]? {
        do {
            let descriptor = FetchDescriptor<CategoriesModel>(sortBy: [SortDescriptor(\.name)])
            self.allCategories = try modelContext.fetch(descriptor)
            return allCategories.filter{$0.id == 0}
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
    
    func getAllCategories() -> [CategoriesModel]? {
        if allCategories.filter({$0.id != 0}).isEmpty {
            print("no categories found")
            let storedCategories = [CategoriesModel(name: "technology", id: 1), CategoriesModel(name: "business", id: 2), CategoriesModel(name: "entertainment", id: 3), CategoriesModel(name: "general", id: 4), CategoriesModel(name: "health", id: 5), CategoriesModel(name: "science", id: 6), CategoriesModel(name: "sports", id: 7)]
            for i in storedCategories {
                modelContext.insert(i)
            }
            return storedCategories
        } else {
            return allCategories.filter{$0.id != 0}
        }
    }
}
