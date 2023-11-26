//
//  MainTabBar.swift
//  NewsNuggets
//
//  Created by Mostafa Alaa on 23/11/2023.
//

import SwiftUI

struct MainTabBarView: View {
    @State var selectedTab = 0

    var body: some View {
        GeometryReader { geometry in

            ZStack(alignment: .bottom) {
                TabView(selection: $selectedTab) {
                    HomePageNavigationView()
                        .tag(0)
                        .toolbar(.hidden, for: .tabBar)

                }
                CustomTabBar(selectedTab: selectedTab, geometry: geometry)
            }
            .ignoresSafeArea()
        }
    }
}

#Preview {
    MainTabBarView()
}

enum TabbedScreens: Int, CaseIterable {
    case home = 0
    case trending
    case bookmarks
    case profile

    var title: String{
        switch self {
        case .home:
            return "Home"
        case .trending:
            return "Trending"
        case .bookmarks:
            return "Bookmarks"
        case .profile:
            return "Profile"
        }
    }

    var iconName: String{
        switch self {
        case .home:
            return "house"
        case .trending:
            return "chart.line.uptrend.xyaxis"
        case .bookmarks:
            return "bookmark"
        case .profile:
            return "person"
        }
    }
}

struct CustomTabBar: View {
    @State var selectedTab = 0
    var geometry: GeometryProxy?
    var bottomSafeArea: CGFloat?
    init(selectedTab: Int = 0, geometry: GeometryProxy? = nil) {
        self.selectedTab = selectedTab
        self.geometry = geometry

        // why this and not geometry safearea? geometry safe area changes when keyboard expands
        self.bottomSafeArea = UIApplication
            .shared
            .connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .last?.safeAreaInsets.bottom
    }
    var body: some View {
        ZStack{
            HStack(spacing: 40){
                ForEach((TabbedScreens.allCases), id: \.self){ item in
                    Button{
                        selectedTab = item.rawValue
                    } label: {
                        CustomTabItem(imageName: item.iconName, title: item.title, isActive: (selectedTab == item.rawValue))
                    }
                }
            }
            .padding(6)
        }
        .frame(width: geometry?.size.width, height: 60+(bottomSafeArea ?? 0))
        .background(.teal.opacity(0.8))
        .clipShape(.rect(
            topLeadingRadius: 25,
            bottomLeadingRadius: 0,
            bottomTrailingRadius: 0,
            topTrailingRadius: 25
        ))
    }
}
extension CustomTabBar {
    func CustomTabItem(imageName: String, title: String, isActive: Bool) -> some View {
        HStack(spacing: 10){
            Image(systemName: imageName)
                .resizable()
                .renderingMode(.template)
                .foregroundColor(isActive ? .white : .black)
                .scaledToFit()
                .frame(width: 20, height: 20)
            if isActive{
                Text(title)
                    .font(.system(size: 14))
                    .foregroundColor(isActive ? .white : .black)
            }
        }
        .padding(12)
        .frame(width: isActive ? .infinity : 30, height: 50)
        .background(isActive ? .black.opacity(0.4) : .clear)
        .cornerRadius(25)
    }
}
