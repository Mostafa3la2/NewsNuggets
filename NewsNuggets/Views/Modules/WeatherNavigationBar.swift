//
//  WeatherNavigationBar.swift
//  NewsNuggets
//
//  Created by Mostafa Alaa on 16/12/2023.
//

import SwiftUI
import Combine

struct WeatherNavigationBar<T>: View where T: WeatherViewModelProtocol {
    @ObservedObject var weatherViewModel: T

    var userName: String?
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
            WeatherViewTwo<T>()
        }
        .padding(.horizontal, 20)
        .frame(height: 90)
        .background(MyColors.navigationBarColor.color)
        .environmentObject(weatherViewModel)

    }
}

struct WeatherViewTwo<T>: View where T: WeatherViewModelProtocol {
    @EnvironmentObject var weatherViewModel: T

    var body: some View {
        HStack (spacing: 10) {
            if weatherViewModel.iconURL != nil {
                AsyncImage(url: URL(string: weatherViewModel.iconURL!)) { phase in
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
