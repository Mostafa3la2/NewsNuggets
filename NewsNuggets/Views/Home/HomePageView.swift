//
//  HomePageView.swift
//  NewsNuggets
//
//  Created by Mostafa Alaa on 24/11/2023.
//

import SwiftUI
import Combine
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
                HomeCustomNavigationBar(weatherViewModel: WeatherViewModel())
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
                                .foregroundStyle(Color.teal)
                            }

                            .padding(.top, 40)
                            .padding(.bottom, 20)
                            ArticlesHorizontalListView(articles: articles)
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
    @ObservedObject var weatherViewModel: WeatherViewModel

    var userName: String?
    var dateString: String?
    var timeOfTheDay: String?
    var body: some View {
        HStack {
            VStack(alignment: .leading) {

                Text((weatherViewModel.timeOfDay ?? "Good morning"))
                    .fixedSize(horizontal: false, vertical: true)
                if userName != nil {
                    Text(userName!)
                }
                Text(weatherViewModel.calendarDate ?? "DD MM YYYY")
            }
            Spacer()
            WeatherView(weatherViewModel: weatherViewModel)
        }
        .padding(.horizontal, 20)
        .frame(height: 90)
        .background(MyColors.navigationBarColor.color)

    }
}

struct WeatherView: View {
    @ObservedObject var weatherViewModel: WeatherViewModel
    var body: some View {
        HStack (spacing: 10) {
            if weatherViewModel.iconURL != nil {
                AsyncImage(url: URL(string:weatherViewModel.iconURL!)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image.resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 50, maxHeight: 50)
                    case .failure:
                        Image(systemName: "sun.max")
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                Image(systemName: "sun.max")
                    .frame(width: 50, height: 50)
            }
            Text("\(weatherViewModel.state ?? ""), \(weatherViewModel.temp ?? "")°C")
        }
    }
}
