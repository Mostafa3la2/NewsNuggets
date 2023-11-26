//
//  HomePageView.swift
//  NewsNuggets
//
//  Created by Mostafa Alaa on 24/11/2023.
//

import SwiftUI

struct HomePageView: View {
    @State var username = ""
    let articles: [ArticlePreviewViewModel] = [
        ArticlePreviewViewModel(id: "1", title: "Placeholder", category: "Placeholder"),
        ArticlePreviewViewModel(id: "2", title: "Placeholder", category: "Placeholder"),
        ArticlePreviewViewModel(id: "3", title: "Placeholder", category: "Placeholder"),
        ArticlePreviewViewModel(id: "4", title: "Placeholder", category: "Placeholder"),
        ArticlePreviewViewModel(id: "5", title: "Placeholder", category: "Placeholder"),
        ArticlePreviewViewModel(id: "6", title: "Placeholder", category: "Placeholder")
    ]
    var body: some View {
        GeometryReader { gr in
            VStack {
                HomeCustomNavigationBar()
                    .ignoresSafeArea(.keyboard,edges: .bottom)
                VStack(alignment: .leading) {
                    Spacer()
                    ScrollView(.vertical) {
                        VStack(alignment: .leading) {
                            CustomText(type: .heading, text: Text("Trending"))
                            ArticlesHorizontalListView(articles: articles)
                            HStack {
                                CustomText(type: .heading, text: Text("Just for you"))
                                Spacer()
                                Button("See more") {

                                }
                            }.padding(.top, 40)
                                .padding(.bottom, 20)
                            ArticlesHorizontalListView(articles: articles)
                            CustomText(type: .heading, text: Text("Just for you"))
                        }
                    }.scrollIndicators(.never)
                }
                .padding(.horizontal, 10)
            }
        }
    }
}

#Preview {
    HomePageView()
}

struct HomeCustomNavigationBar: View {
    var userName: String?
    var dateString: String?
    var timeOfTheDay: String?
    var weatherData: WeatherViewModel?
    var body: some View {
        HStack {
            VStack(alignment: .leading) {

                Text("Good \(timeOfTheDay ?? "Morning"), \n\(userName ?? "Username")")
                    .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                Text(dateString ?? "DD MM YYYY")
            }
            Spacer()
            WeatherView(weatherData: weatherData)
        }
        .padding(.horizontal, 20)
        .frame(height: 90)
        .background(MyColors.navigationBarColor.color)

    }
}

struct WeatherView: View {
    var weatherData: WeatherViewModel?

    var body: some View {
        HStack (spacing: 10) {
            weatherData?.image != nil ? weatherData!.image! : Image(systemName: "sun.max")
            Text(weatherData == nil ? "Sunny 32C" : weatherData!.state! + " " + weatherData!.temp!)
        }
    }
}
