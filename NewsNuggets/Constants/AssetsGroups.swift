//
//  AssetsGroups.swift
//  NewsNuggets
//
//  Created by Mostafa Alaa on 22/11/2023.
//

import Foundation

protocol AssetName {
    var imageName: String { get }

}

enum Theme {
    case dark
    case light
    case defaultTheme
}

enum AssetsGroups {
    case shared
    var theme: Theme { return .defaultTheme }
    enum GeneralAssets: AssetName {

        var imageName: String {
            return "\(self)\(AssetsGroups.shared.theme == .defaultTheme ? "":"-\(AssetsGroups.shared.theme)")"
        }
        case MainIcon
        case LandingPattern
    }
}

