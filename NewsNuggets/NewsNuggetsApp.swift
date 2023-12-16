//
//  NewsNuggetsApp.swift
//  NewsNuggets
//
//  Created by Mostafa Alaa on 22/11/2023.
//

import SwiftUI
import SwiftData

@main
struct NewsNuggetsApp: App {
    let container: ModelContainer

    var body: some Scene {
        WindowGroup {
            SplashScreenView()
        }
        .modelContainer(container)
    }
    init() {
        do {
            container = try ModelContainer(for: CategoriesModel.self)
        } catch {
            fatalError("Failed to create ModelContainer for Categories.")
        }
    }
}
