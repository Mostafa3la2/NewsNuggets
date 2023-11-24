//
//  HomePageView.swift
//  NewsNuggets
//
//  Created by Mostafa Alaa on 24/11/2023.
//

import SwiftUI

struct HomePageView: View {
    var body: some View {
        VStack {
            HomeCustomNavigationBar()
                .frame(height: 90)
                .background(MyColors.navigationBarColor.color)
            Spacer()
            Text("Hello")
            Spacer()
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
        .frame(width: .infinity, alignment: .center)
        .padding(.horizontal, 20)

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
