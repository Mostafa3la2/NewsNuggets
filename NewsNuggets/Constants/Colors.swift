//
//  Colors.swift
//  NewsNuggets
//
//  Created by Mostafa Alaa on 24/11/2023.
//

import Foundation
import SwiftUI
protocol ColorsDesignSystem: RawRepresentable<String> {
    var defaultColor: Color { get }
    var color: Color { get }
}
extension ColorsDesignSystem {
    var defaultColor: Color {
        return .white
    }
    var color: Color {
        return Color(self.rawValue)
    }
}
enum MyColors: String, ColorsDesignSystem {

    

    case black
}
