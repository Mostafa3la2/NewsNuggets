//
//  ArticlesHorizontalListView.swift
//  NewsNuggets
//
//  Created by Mostafa Alaa on 26/11/2023.
//

import SwiftUI

struct ArticlesHorizontalListView: View {
    var articles: [Article]
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 10) {
                ForEach(articles, id: \.self) { article in
                    NavigationLink(destination: ArticleDetailsView(articleDetails: article)){
                        ArticleListItemView(articlePreviewViewModel: article)
                            .frame(width: 290)
                            .frame(height: 400)
                            .multilineTextAlignment(.leading)
                    }
                    .scrollIndicators(.hidden)
                }
            }
        }.scrollIndicators(.hidden)
    }
}

#Preview {
    ArticlesHorizontalListView(articles: [
        Article(id: "1", title: "Placeholder", source: "Placeholder"),
        Article(id: "2", title: "Placeholder", source: "Placeholder"),
        Article(id: "3", title: "Placeholder", source: "Placeholder"),
        Article(id: "4", title: "Placeholder", source: "Placeholder"),
        Article(id: "5", title: "Placeholder", source: "Placeholder"),
        Article(id: "6", title: "Placeholder", source: "Placeholder")
    ])
}
