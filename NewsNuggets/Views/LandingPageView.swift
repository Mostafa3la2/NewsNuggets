//
//  LandingPageView.swift
//  NewsNuggets
//
//  Created by Mostafa Alaa on 23/11/2023.
//

import SwiftUI

struct LandingPageView: View {
    var body: some View {
        GeometryReader {
            gr in
            VStack {
                Image(AssetsGroups.GeneralAssets.LandingPattern.imageName)
                    .background(LinearGradient(colors: [.teal, .blue], startPoint: .bottom, endPoint: .top))
                    .frame(width: gr.size.width, height: gr.size.height*0.5)

                BottomView(geometryReader: gr)
            }
        }
    }
}

#Preview {
    LandingPageView()
}



struct BottomView: View {
    var geometryReader: GeometryProxy
    @State private var isPresented = false

    var body: some View {
        VStack {
            VStack(spacing: 20){
                Text("LandingPageTitle")
                    .multilineTextAlignment(.center)
                    .font(.custom(Typography.medium.name, size: 32))

                Text("LandingPageSubtitle")
                    .foregroundStyle(.gray)
                    .multilineTextAlignment(.center)
                    .font(.custom(Typography.regular.name, size: 18))
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)

            Spacer()

            Button {
                isPresented = true
            } label: {
                HStack {
                    Text("Explore")
                        .foregroundStyle(.white)
                        .font(.custom(Typography.regular.name, size: 20))
                    Image(systemName: "arrow.right")
                        .foregroundColor(.white)
                }
            }
            .padding(.vertical, 10).padding(.horizontal, 15)
            .background(.teal)
            .clipShape(.capsule)
            .fullScreenCover(isPresented: $isPresented, content: {
                MainTabBarView()
            })
        }
        //.frame(width: geometryReader.size.width, height: geometryReader.size.height*0.4, alignment: .top)
        .frame(width: geometryReader.size.width, alignment: .top)
        .zIndex(1)
        .background(Color.white)
        .clipShape(
            .rect(
                topLeadingRadius: 25,
                bottomLeadingRadius: 0,
                bottomTrailingRadius: 0,
                topTrailingRadius: 25
            )
        )
        .offset(y: -10)

    }
}
