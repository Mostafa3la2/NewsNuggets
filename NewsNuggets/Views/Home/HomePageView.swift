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
                HomeCustomNavigationBar<T>()
                    .ignoresSafeArea(.keyboard,edges: .bottom)
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

struct HomeCustomNavigationBar<T>: View where T: HomepageViewModelProtocol {
    @EnvironmentObject var homepageViewModel: T

    var userName: String?
    var body: some View {
        HStack {
            VStack(alignment: .leading) {

                Text((homepageViewModel.timeOfDay ?? "Good morning"))
                    .fixedSize(horizontal: false, vertical: true)
                if userName != nil {
                    Text(userName!)
                }
                Text(homepageViewModel.calendarDate ?? "DD MM YYYY")
            }
            Spacer()
            WeatherView<T>()
        }
        .padding(.horizontal, 20)
        .frame(height: 90)
        .background(MyColors.navigationBarColor.color)

    }
}

struct WeatherView<T>: View where T: HomepageViewModelProtocol {
    @EnvironmentObject var homepageViewModel: T

    var body: some View {
        HStack (spacing: 10) {
            if homepageViewModel.iconURL != nil {
                AsyncImage(url: URL(string:homepageViewModel.iconURL!)) { phase in
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
            Text("\(homepageViewModel.state ?? "Hopefull nice"), \(homepageViewModel.temp ?? "Dunno ")°C")
        }
    }
}
