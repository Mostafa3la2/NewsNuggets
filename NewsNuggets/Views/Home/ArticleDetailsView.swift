//
//  ArticleView.swift
//  NewsNuggets
//
//  Created by Mostafa Alaa on 25/11/2023.
//

import SwiftUI

struct ArticleDetailsView: View {
    private let imageHeight: CGFloat = 300
    private let collapsedImageHeight: CGFloat = 75
    @State private var titleRect: CGRect = .zero
    @State private var headerImageRect: CGRect = .zero
    var articleDetails = ArticleDetailsViewModel(title: "Placeholder for article title", body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam varius tempus mi nec porttitor. In posuere aliquet justo, non luctus turpis tristique sed. Nulla quam sem, maximus eget quam non, pulvinar tempor mi. Nulla ultrices commodo elit at dapibus. Nunc rutrum eros eu tempor auctor. Sed vitae nisi consectetur, pretium ipsum sed, ultricies augue. Sed maximus purus neque, et dapibus nunc ornare ut. Suspendisse sed lectus laoreet, elementum mi eget, laoreet ligula. Aliquam laoreet condimentum accumsan. Sed eget varius sem. Nulla posuere cursus libero sed blandit. Nulla euismod, ex vitae rutrum finibus, lorem enim semper felis, eget efficitur tortor leo a quam. Phasellus eget semper leo. Aliquam sit amet nibh viverra, pulvinar quam nec, imperdiet tortor. In hac habitasse platea dictumst. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos.taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos", author: ArticleAuthor(name: "name placeholder"), date: "DD MM YYY", readTime: "XX min read")
    private func getHeaderTitleOffset() -> CGFloat {
        let currentYPos = titleRect.midY

        if currentYPos < headerImageRect.maxY {
            let minYValue: CGFloat = 50.0
            let maxYValue: CGFloat = collapsedImageHeight
            let currentYValue = currentYPos

            let percentage = max(-1, (currentYValue - maxYValue) / (maxYValue - minYValue))
            let finalOffset: CGFloat = -25.0
            return 20 - (percentage * finalOffset)
        }

        return .infinity
    }
    private func getScrollOffset(_ geometry: GeometryProxy) -> CGFloat {
        geometry.frame(in: .global).minY
    }

    private func getOffsetForHeaderImage(_ geometry: GeometryProxy) -> CGFloat {
        let offset = getScrollOffset(geometry)
        let sizeOffScreen = imageHeight - collapsedImageHeight // 3
        if offset < -sizeOffScreen {
            let imageOffset = abs(min(-sizeOffScreen, offset))
            return imageOffset - sizeOffScreen
        }
        // Image was pulled down
        if offset > 0 {
            return -offset
        }

        return 0
    }
    private func getHeightForHeaderImage(_ geometry: GeometryProxy) -> CGFloat {
        let offset = getScrollOffset(geometry)
        let imageHeight = geometry.size.height

        if offset > 0 {
            return imageHeight + offset
        }
        print(imageHeight)
        return imageHeight
    }
    private func getBlurRadiusForImage(_ geometry: GeometryProxy) -> CGFloat {
        let offset = geometry.frame(in: .global).maxY

        let height = geometry.size.height
        let blur = (height - max(offset, 0)) / height // (values will range from 0 - 1)
        return blur * 6 // Values will range from 0 - 6
    }
    var body: some View {

        ScrollView {
            GeometryReader { geometry in
                ZStack(alignment: .bottom) {

                    Image("articleHeaderPlaceholder")
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: self.getHeightForHeaderImage(geometry))
                        .blur(radius: self.getBlurRadiusForImage(geometry))
                        .clipped()
                        .background(GeometryGetter(rect: self.$headerImageRect))

                    CustomText(type: .title, color: Color.white,text: Text( articleDetails.title ?? ""))
                        .offset(x: 0, y: self.getHeaderTitleOffset())

                }
                .clipped()
                .offset(x: 0, y: self.getOffsetForHeaderImage(geometry))
            }
            .frame(height: imageHeight)
            .zIndex(2)

            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    if articleDetails.author?.imageURL != nil {
                        AsyncImage(url: URL(string: articleDetails.author!.imageURL!))
                            .scaledToFill()
                            .frame(width: 55, height: 55)
                            .clipShape(Circle())
                            .shadow(radius: 4)
                    } else {
                        Image(systemName: "person.circle")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 55, height: 55)
                            .clipShape(Circle())
                    }
                    VStack(alignment: .leading) {
                        CustomText(type: .body, text: Text("Article Written By"))
                            .foregroundColor(.gray)
                        CustomText(type: .body, color: Color.teal,text: Text(articleDetails.author?.name ?? ""))
                    }
                }

                CustomText(type: .grayBody, text: Text( "\(articleDetails.date ?? ""), \(articleDetails.readTime ?? "")"))
                    .foregroundColor(.gray)

                CustomText(type:.title, text: Text(articleDetails.title ?? ""))
                    .background(GeometryGetter(rect: self.$titleRect))
                    .frame(maxWidth: .infinity, alignment: .center)
                CustomText(type: .body, text: Text(articleDetails.body ?? ""))
                    .lineLimit(nil)
                
            }
            .padding(.horizontal)
            .padding(.top, 16.0) // 2
        }.edgesIgnoringSafeArea(.all) // 3
            .scrollIndicators(.hidden)            
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleDetailsView()
    }
}

#Preview {
    ArticleDetailsView()
}
// 12
struct GeometryGetter: View {
    @Binding var rect: CGRect

    var body: some View {
        GeometryReader { geometry in
            AnyView(Color.clear)
                .preference(key: RectanglePreferenceKey.self, value: geometry.frame(in: .global))
        }.onPreferenceChange(RectanglePreferenceKey.self) { (value) in
            self.rect = value
        }
    }
}

// 13
struct RectanglePreferenceKey: PreferenceKey {
    static var defaultValue: CGRect = .zero

    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}
