//
//  HomePageView.swift
//  NewsNuggets
//
//  Created by Mostafa Alaa on 23/11/2023.
//

import SwiftUI

struct HomePageNavigationView: View {
    @Environment(\.modelContext) var modelContext
    
    var mock = false
    func createHomePage()-> some View {
        let collection: any Collection<any NewsFetchable> = [NewsFetcher(), GNewsFetcher()]
        let homepageViewModel = HomepageViewModel(newsFetcher: collection, weatherFetcher: WeatherFetcher(), modelContext: modelContext)
        return HomePageView(homepageViewModel: homepageViewModel)

    }
    func createMockHomePage() -> some View {
        return HomePageView(homepageViewModel: MockHomePageViewModel())

    }
    var body: some View {
        NavigationStack {
            if mock {
                createMockHomePage()
            } else {
                createHomePage()
            }
        }.toolbar(.hidden, for: .navigationBar)
    }
}

#Preview {
    HomePageNavigationView(mock: true)
}
