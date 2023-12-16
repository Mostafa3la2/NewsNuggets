//
//  HomePageView.swift
//  NewsNuggets
//
//  Created by Mostafa Alaa on 24/11/2023.
//

import SwiftUI
import Combine
struct HomePageView<T>: View where T: HomepageViewModelProtocol {

    @State var username = ""
    @ObservedObject var homepageViewModel: T


    var body: some View {
        GeometryReader { gr in
            VStack {
                if homepageViewModel is MockHomePageViewModel {
                    WeatherNavigationBar<MockWeatherViewModel>(weatherViewModel: MockWeatherViewModel())
                        .ignoresSafeArea(.keyboard,edges: .bottom)
                } else {
                    WeatherNavigationBar<WeatherViewModel>(weatherViewModel: WeatherViewModel(weatherFetcher: WeatherFetcher()))
                        .ignoresSafeArea(.keyboard,edges: .bottom)
                }
                VStack(alignment: .leading) {
                    Spacer()
                    ScrollView(.vertical) {
                        VStack(alignment: .leading) {
                            CustomText(type: .heading, text: Text("Trending"))
                            ArticlesHorizontalListView(articles: homepageViewModel.headlinesDataSource)
                            HStack {
                                CustomText(type: .heading, text: Text("Just for you"))
                                Spacer()
                                Button("See more") {
                                }
                                .foregroundStyle(Color.teal)
                            }
                            .padding(.top, 40)
                            .padding(.bottom, 20)
                            if homepageViewModel.userCategories.isEmpty {

                            } else {
                                ArticlesHorizontalListView(articles: homepageViewModel.headlinesDataSource)
                            }
                        }
                        .padding(.bottom, 50)

                    }.scrollIndicators(.never)
                }
                .padding(.horizontal, 10)
            }
        }        
        .environmentObject(homepageViewModel)
    }        
}

#Preview {
    return HomePageView<MockHomePageViewModel>(homepageViewModel: MockHomePageViewModel())
}


