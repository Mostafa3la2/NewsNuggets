//
//  WeatherViewModel.swift
//  NewsNuggets
//
//  Created by Mostafa Alaa on 24/11/2023.
//

import Combine
import SwiftUI
import CoreLocation

protocol WeatherViewModelProtocol {
    var state: String? { get }
    var temp: String? { get }
    var countryCode: String? { get }
    var iconURL: String? { get }
    var timeOfDay: String? { get }
    var calendarDate: String? { get }
}

