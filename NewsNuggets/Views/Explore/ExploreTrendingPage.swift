//
//  ExploreTrendingPage.swift
//  NewsNuggets
//
//  Created by Mostafa Alaa on 25/12/2023.
//

import SwiftUI
import Combine
import SwiftData

struct ExploreTrendingPage: View {

    @ObservedObject var exploreTrendsVM: TrendingPageViewModel

    var gridItems: [GridItem] = [GridItem(.adaptive(minimum: 100, maximum: .infinity), spacing: 8)]
    var body: some View {
            VStack {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(exploreTrendsVM.categoriesDataSource, id: \.self) { category in
                            TrendingCategoriesGrid(category: category)
                                .onTapGesture {
                                    self.exploreTrendsVM.selectCategory(categoryIndex: exploreTrendsVM.categoriesDataSource.firstIndex{$0.name == category.name} ?? -1)
                                }
                        }
                        .padding(.all, 8)
                    }
                }
                ScrollView(.vertical) {
                VStack(alignment: .center) {
                    if !exploreTrendsVM.tailoredNewsDataSource.isEmpty {
                        ExploreMainArticle(article: exploreTrendsVM.tailoredNewsDataSource.first!)
                    }
                    ForEach(exploreTrendsVM.getRemainingArticles(), id: \.self) { article in
                        ExploreArticleTileView(article: article)
                    }
                }
            }
        }
    }
    func toggleCellState(@Binding state: Bool) {
        state.toggle()
    }
}

//#Preview {
//    let config = ModelConfiguration(isStoredInMemoryOnly: true)
//    let container = try! ModelContainer(for: CategoriesModel.self, configurations: config)
//    let storedCategories: [CategoriesModel] = [CategoriesModel(name: "technology", id: 1), CategoriesModel(name: "business", id: 2), CategoriesModel(name: "entertainment", id: 3), CategoriesModel(name: "general", id: 4), CategoriesModel(name: "health", id: 5), CategoriesModel(name: "science", id: 6), CategoriesModel(name: "sports", id: 7)]
//    
//    for i in storedCategories {
//        container.mainContext.insert(i)
//    }
//    try! container.mainContext.save()
//    return ExploreTrendingPage(exploreTrendsVM: TrendingPageViewModel(newsFetcher: [NewsFetcher()], categoriesManager: CategoriesManager(modelContext: container.mainContext)))
//        .modelContainer(container)
//}


struct TrendingCategoriesGrid: View {
    var category: CategoryDataSource

    init(category: CategoryDataSource) {
        self.category = category
    }

    var body: some View {
        CustomText(type: .body, color: (self.category.selected == true) ? .indigo : .black, text: Text("\(category.name ?? "")"))
        .foregroundStyle(.black)
        .padding(.all, 8)
        .background((self.category.selected == true)  ? MyColors.BabyBlue.color: .white)
        .clipShape(.rect(
            topLeadingRadius: 12,
            bottomLeadingRadius: 12,
            bottomTrailingRadius: 12,
            topTrailingRadius: 12
        ))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(.gray, lineWidth: 1)
        )
    }
}
struct ExploreMainArticle: View {
    var article: Article
    let screenWidth = UIScreen.main.bounds.width
    var body: some View {
            VStack(alignment: .leading) {
                if article.imageURL != nil {
                    AsyncImage(url: URL(string: article.imageURL!)) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(height: 160)
                        case .success(let image):
                            image.resizable()
                                .scaledToFill()
                                .clipped()
                                .frame(height: 160)
                                .clipShape(.rect(
                                    topLeadingRadius: 8,
                                    bottomLeadingRadius: 8,
                                    bottomTrailingRadius: 8,
                                    topTrailingRadius: 8
                                ))
                                .padding(.all, 5)
                        case .failure:
                            Image("articlePlaceholder")
                        @unknown default:
                            EmptyView()
                        }
                    }
                } else {
                    Image("articlePlaceholder")
                        .resizable()
                        .scaledToFill()
                        .clipped()
                        .frame(height: 160)
                        .clipShape(.rect(
                            topLeadingRadius: 8,
                            bottomLeadingRadius: 8,
                            bottomTrailingRadius: 8,
                            topTrailingRadius: 8
                        ))
                        .padding(.all, 5)
                }
                CustomText(type: .title, text: Text(article.title ?? ""))
                    .lineLimit(2)
                HStack {
                    CustomText(type: .grayBody, text: Text(article.author?.name ?? article.source ?? ""))
                    CustomText(type: .grayBody, text: Text(" · "))
                    CustomText(type: .grayBody, text: Text(article.publishedAt ?? ""))
                }
        }
            .frame(width: screenWidth*0.8)
    }
}

#Preview {
    ExploreMainArticle(article: Article(id: "123", title: "Test very large title to see how it wraps when it is larger", source: "Test"))
}
