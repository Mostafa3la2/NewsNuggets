//
//  HomePageView.swift
//  NewsNuggets
//
//  Created by Mostafa Alaa on 23/11/2023.
//

import SwiftUI

struct HomePageNavigationView: View {
    
    func createHomePage()-> some View {

        let collection: any Collection<any NewsFetchable> = [NewsFetcher(), GNewsFetcher()]
        let locationDataViewModel = LocationRelatedDataViewModel(weatherFetcher: WeatherFetcher())
        let newsViewModel = NewsViewModel(newsFetcher: collection, locationDataViewModel: locationDataViewModel)
        return HomePageView(weatherViewModel: locationDataViewModel, newsViewModel: newsViewModel)
    }
    var body: some View {
        NavigationStack {
            createHomePage()
        }.toolbar(.hidden, for: .navigationBar)
    }
}

#Preview {
    HomePageNavigationView()
}
