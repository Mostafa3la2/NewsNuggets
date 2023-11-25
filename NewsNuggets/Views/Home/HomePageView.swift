//
//  HomePageView.swift
//  NewsNuggets
//
//  Created by Mostafa Alaa on 24/11/2023.
//

import SwiftUI

struct HomePageView: View {
    @State var username = ""
    var body: some View {
        GeometryReader { _ in
            HomeCustomNavigationBar()
                .ignoresSafeArea(.keyboard,edges: .bottom)
            VStack {
                    Spacer()
                    TextField(
                        "User name (email address)",
                        text: $username
                    )
                    Spacer()
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
