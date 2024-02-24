//
//  ExploreNavigationView.swift
//  NewsNuggets
//
//  Created by Mostafa Alaa on 25/12/2023.
//

import SwiftUI

struct ExploreNavigationView: View {
    var mock = false
    @Environment(\.modelContext) var modelContext

    func createExplorePage() -> some View {
        let collection: any Collection<any NewsFetchable> = [NewsFetcher(), GNewsFetcher()]
        let trendingPageViewModel =  TrendingPageViewModel(newsFetcher: collection, categoriesManager: CategoriesManager(modelContext: modelContext))
        return ExploreTrendingPage(exploreTrendsVM: trendingPageViewModel)
    }
    var body: some View {
        NavigationStack {
            createExplorePage()
        }.toolbar(.hidden, for: .navigationBar)
    }
}

#Preview {
    ExploreNavigationView()
}
