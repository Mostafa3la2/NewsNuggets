//
//  HomePageView.swift
//  NewsNuggets
//
//  Created by Mostafa Alaa on 23/11/2023.
//

import SwiftUI

struct HomePageNavigationView: View {
    var body: some View {
        NavigationStack {
            HomePageView()
        }.toolbar(.hidden, for: .navigationBar)
    }
}

#Preview {
    HomePageNavigationView()
}
