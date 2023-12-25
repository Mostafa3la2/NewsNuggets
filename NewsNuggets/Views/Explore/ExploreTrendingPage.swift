//
//  ExploreTrendingPage.swift
//  NewsNuggets
//
//  Created by Mostafa Alaa on 25/12/2023.
//

import SwiftUI
import SwiftData

struct ExploreTrendingPage: View {

    @Query(filter: #Predicate<CategoriesModel> { category in
        category.id != 0
    }) var categories: [CategoriesModel]

    var gridItems: [GridItem] = [GridItem(.adaptive(minimum: 100, maximum: .infinity), spacing: 8)]
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach((categories), id: \.self) { category in
                    TrendingCategoriesGrid(category: category)

                }
            }
            Spacer()
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: CategoriesModel.self, configurations: config)
    let storedCategories: [CategoriesModel] = [CategoriesModel(name: "technology", id: 1), CategoriesModel(name: "business", id: 2), CategoriesModel(name: "entertainment", id: 3), CategoriesModel(name: "general", id: 4), CategoriesModel(name: "health", id: 5), CategoriesModel(name: "science", id: 6), CategoriesModel(name: "sports", id: 7)]
    
    for i in storedCategories {
        container.mainContext.insert(i)
    }
    return ExploreTrendingPage()
        .modelContainer(container)
}


struct TrendingCategoriesGrid: View {
    var category: CategoriesModel
    init(category: CategoriesModel) {
        self.category = category
    }
    @State var selected = false

    var body: some View {
        Button("\(category.name)") {
            selected.toggle()
        }
        .foregroundStyle(.black)
        .padding(.all, 8)
        .frame(width: .infinity)
        .background((selected == true)  ? MyColors.BabyBlue.color: .gray)
        .clipShape(.rect(
            topLeadingRadius: 8,
            bottomLeadingRadius: 8,
            bottomTrailingRadius: 8,
            topTrailingRadius: 8
        ))

    }
}
