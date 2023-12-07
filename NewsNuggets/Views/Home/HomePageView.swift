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
    @ObservedObject var weatherViewModel: LocationRelatedDataViewModel
    @ObservedObject var newsViewModel: NewsViewModel
    var body: some View {
        GeometryReader { gr in
            VStack {
                HomeCustomNavigationBar(weatherViewModel: weatherViewModel)
                    .ignoresSafeArea(.keyboard,edges: .bottom)
                VStack(alignment: .leading) {
                    Spacer()
                    ScrollView(.vertical) {
                        VStack(alignment: .leading) {
                            CustomText(type: .heading, text: Text("Trending"))
                            ArticlesHorizontalListView(articles: newsViewModel.headlinesDataSource)
                            HStack {
                                CustomText(type: .heading, text: Text("Just for you"))
                                Spacer()
                                Button("See more") {
                                }
                                .foregroundStyle(Color.teal)
                            }

                            .padding(.top, 40)
                            .padding(.bottom, 20)
                            ArticlesHorizontalListView(articles: newsViewModel.headlinesDataSource)
                        }
                    }.scrollIndicators(.never)
                    Spacer()
                }
                .padding(.horizontal, 10)
            }
        }
    }
}

#Preview {
    let locationDataViewModel = LocationRelatedDataViewModel(weatherFetcher: WeatherFetcher())
    let newsViewModel = NewsViewModel(newsFetcher: NewsFetcher(), locationDataViewModel: locationDataViewModel)
    return HomePageView(weatherViewModel: locationDataViewModel, newsViewModel: newsViewModel)
}

struct HomeCustomNavigationBar: View {
    @ObservedObject var weatherViewModel: LocationRelatedDataViewModel

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
    @ObservedObject var weatherViewModel: LocationRelatedDataViewModel
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
            Text("\(weatherViewModel.state ?? "Hopefull nice"), \(weatherViewModel.temp ?? "Dunno ")°C")
        }
    }
}
