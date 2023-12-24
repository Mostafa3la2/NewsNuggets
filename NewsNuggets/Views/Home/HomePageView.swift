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
    @State private var showCategoriesPopup = false

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
                                .padding(.leading, 10)

                            ArticlesHorizontalListView(articles: homepageViewModel.headlinesDataSource)
                            HStack {
                                CustomText(type: .heading, text: Text("Just for you"))

                                Spacer()
                                Button("See more") {
                                }
                                
                                .foregroundStyle(Color.teal)
                            }
                            .padding(.vertical, 20)
                            .padding(.horizontal, 10)
                            if homepageViewModel.userCategories.isEmpty {
                                VStack(alignment: .leading, spacing: 16) {
                                    HStack(alignment: .center) {
                                        CustomText(type: .grayBody, text: Text("You don't have preferred categories yet, you can select from below list"))
                                        Button(action: {
                                            showCategoriesPopup = true
                                        }, label: {
                                            Image(systemName: "info.circle")
                                                .tint(.black)
                                        })
                                        .popover(isPresented: $showCategoriesPopup, content: {
                                            CategoriesInfoPopup()
                                                .presentationCompactAdaptation(.popover)
                                        })
                                    }
                                    .padding(.all, 8)
                                    .background(MyColors.BackgroundGray.color)
                                    .clipShape(.rect(
                                        topLeadingRadius: 8,
                                        bottomLeadingRadius: 8,
                                        bottomTrailingRadius: 8,
                                        topTrailingRadius: 8
                                    ))
                                    .padding(.leading, 10)
                                    CategoriesPicker(categories: homepageViewModel.storedCategories)
                                }
                            } else {
                                ArticlesHorizontalListView(articles: homepageViewModel.tailoredNewsDataSource)
                            }

                        }
                        .padding(.bottom, 50)

                    }.scrollIndicators(.never)
                }
            }
        }        
        .environmentObject(homepageViewModel)
    }        
}

#Preview {
    return HomePageView<MockHomePageViewModel>(homepageViewModel: MockHomePageViewModel())
}
struct CategoriesPicker: View {
    var categories: [CategoriesModel]
    var gridItems: [GridItem] = [GridItem(.adaptive(minimum: 100, maximum: .infinity), spacing: 8), GridItem(.adaptive(minimum: 100, maximum: .infinity), spacing: 8)]

    var body: some View {
        ScrollView(.horizontal) {
            LazyHGrid(rows: gridItems) {
                ForEach((categories), id: \.self) { category in
                    CategoryGridItem(category: category)
                }
            }
        }
    }
}

struct CategoryGridItem: View {
    @EnvironmentObject var homepageViewmodel: HomepageViewModel

    var category: CategoriesModel
    
    var body: some View {
        Button("\(category.name)") {
            if !homepageViewmodel.userCategories.contains(category) {
                homepageViewmodel.addCategory(category: category)
            } else {
                homepageViewmodel.deleteCategory(category: category)
            }
        }
        .foregroundStyle(.black)
        .padding(.all, 8)
        .frame(width: .infinity)
        .background(MyColors.BabyBlue.color)
        .clipShape(.rect(
            topLeadingRadius: 8,
            bottomLeadingRadius: 8,
            bottomTrailingRadius: 8,
            topTrailingRadius: 8
        ))
    }
}

struct CategoriesInfoPopup: View {
    var body: some View {
        HStack {
            CustomText(type: .grayBody, text: Text("No need to worry, you can change it at any time from your profile"))
                .padding(.all, 8)
        }
    }
}
