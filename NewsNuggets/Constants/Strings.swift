//
//  Strings.swift
//  NewsNuggets
//
//  Created by Mostafa Alaa on 16/12/2023.
//

import Foundation


enum URLConstants: String {
    case WEATHER_ICON_BASE_URL = "https://openweathermap.org/img/wn/{0}@2x.png"
    var value: String {
        return self.rawValue
    }
}
