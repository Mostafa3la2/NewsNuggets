//
//  ExploreArticleTileView.swift
//  NewsNuggets
//
//  Created by Mostafa Alaa on 24/02/2024.
//

import SwiftUI

struct ExploreArticleTileView: View {
    var article: Article

    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading) {
                CustomText(type: .smallTitle, text: Text(article.title ?? ""))
                    .lineLimit(2)
                HStack {
                    CustomText(type: .grayBody, text: Text(article.author?.name ?? ""))
                    CustomText(type: .grayBody, text: Text(article.publishedAt ?? ""))
                }
            }
            .padding(.leading, 8)
            if article.imageURL != nil {
                AsyncImage(url: URL(string: article.imageURL!)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 180, height: 160)
                    case .success(let image):
                        image.resizable()
                            .scaledToFill()
                            .clipped()
                            .frame(width: 180, height: 160)
                            .clipShape(.rect(
                                topLeadingRadius: 8,
                                bottomLeadingRadius: 8,
                                bottomTrailingRadius: 8,
                                topTrailingRadius: 8
                            ))
                            .padding(.all, 5)
                    case .failure:
                        Image("articlePlaceholder")
                            .resizable()
                            .scaledToFill()
                            .clipped()
                            .frame(width: 180, height: 160)
                            .clipShape(.rect(
                                topLeadingRadius: 8,
                                bottomLeadingRadius: 8,
                                bottomTrailingRadius: 8,
                                topTrailingRadius: 8
                            ))
                            .padding(.trailing, 8)
                    @unknown default:
                        EmptyView()
                    }
                }
                .padding(.trailing, 8)
            } else {
                Image("articlePlaceholder")
                    .resizable()
                    .scaledToFill()
                    .clipped()
                    .frame(width: 180, height: 160)
                    .clipShape(.rect(
                        topLeadingRadius: 8,
                        bottomLeadingRadius: 8,
                        bottomTrailingRadius: 8,
                        topTrailingRadius: 8
                    ))
                    .padding(.trailing, 8)
            }
        }
    }
}

#Preview {
    var article = Article(id: "1", title: "this is an extremely large title to test if the content is fit", source: "Test")
    article.imageURL = "https://img.youm7.com/xlarge/201909090557435743.jpg"
    return ExploreArticleTileView(article: article)
}
