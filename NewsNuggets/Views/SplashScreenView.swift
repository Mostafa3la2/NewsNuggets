//
//  SplashScreenView.swift
//  NewsNuggets
//
//  Created by Mostafa Alaa on 22/11/2023.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    var body: some View {
        ZStack {
            if self.isActive {
                LandingPageView()
            } else {
                ZStack {
                    Image(AssetsGroups.GeneralAssets.MainIcon.imageName)
                        .resizable()
                        .ignoresSafeArea()
                        .aspectRatio(contentMode: .fill)

                        .overlay(Text("NewsNuggets")
                            .font(.custom(Typography.bold.name, size: 32)), alignment: .bottom)
                }
            }
        }
        .onAppear() {
            DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                withAnimation {
                    self.isActive = true
                }
            }
        }
    }
}

#Preview {
    SplashScreenView()
}
