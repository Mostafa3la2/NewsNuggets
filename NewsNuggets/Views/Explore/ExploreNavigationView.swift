//
//  ExploreNavigationView.swift
//  NewsNuggets
//
//  Created by Mostafa Alaa on 25/12/2023.
//

import SwiftUI

struct ExploreNavigationView: View {
    var mock = false

    var body: some View {
        NavigationStack {
            ExploreTrendingPage()
        }.toolbar(.hidden, for: .navigationBar)
    }
}

#Preview {
    ExploreNavigationView()
}
