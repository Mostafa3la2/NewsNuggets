//
//  Typography.swift
//  NewsNuggets
//
//  Created by Mostafa Alaa on 23/11/2023.
//

import Foundation



enum Typography: String {
    case black = "Black"
    case bold = "Bold"
    case extraBold = "ExtraBold"
    case extraLight = "ExtraLight"
    case light = "Light"
    case medium = "Medium"
    case regular = "Regular"
    case semiBold = "SemiBold"
    case thin = "Thin"


    private var englishFontFamily: String {
        return "HelveticaNeue"
    }

    var FamilyName: String {
        return englishFontFamily
    }

    var name: String {
        return "\(FamilyName)-\(self.rawValue)"
    }
}
