//
//  MainTabBar.swift
//  NewsNuggets
//
//  Created by Mostafa Alaa on 23/11/2023.
//

import SwiftUI

struct MainTabBar: View {
    @State var selectedTab = 0

    var body: some View {
        GeometryReader { geometry in

            ZStack(alignment: .bottom) {
                TabView(selection: $selectedTab) {
                    HomePageView()
                        .tag(0)
                }
            }
            .overlay(alignment: .bottom) {
                CustomTabBar(selectedTab: selectedTab, geometry: geometry, tabView: self)

            }
            .ignoresSafeArea()
        }
    }
}

#Preview {
    MainTabBar()
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

extension MainTabBar {
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

struct CustomTabBar: View {
    @State var selectedTab = 0
    var geometry: GeometryProxy?
    var tabView: MainTabBar?
    var body: some View {
        ZStack{
            HStack(spacing: 50){
                ForEach((TabbedScreens.allCases), id: \.self){ item in
                    Button{
                        selectedTab = item.rawValue
                    } label: {
                        tabView?.CustomTabItem(imageName: item.iconName, title: item.title, isActive: (selectedTab == item.rawValue))
                    }
                }
            }
            .padding(6)
        }
        .frame(width: geometry?.size.width, height: 60+(geometry?.safeAreaInsets.bottom ?? 0))
        .background(.teal.opacity(0.8))
        .cornerRadius(24)
    }
}
