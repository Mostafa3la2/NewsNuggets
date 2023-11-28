//
//  ArticlesHorizontalListView.swift
//  NewsNuggets
//
//  Created by Mostafa Alaa on 26/11/2023.
//

import SwiftUI

struct ArticlesHorizontalListView: View {
    var articles: [ArticlePreviewViewModel]
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 10) {
                ForEach(articles, id: \.self) { article in
                    NavigationLink(destination: ArticleDetailsView()){
                        ArticleListItemView()
                            .frame(width: 290)
                            .frame(maxHeight:400)
                    }
                    .scrollIndicators(.hidden)
                }
            }
        }.scrollIndicators(.hidden)
    }
}

#Preview {
    ArticlesHorizontalListView(articles: [
        ArticlePreviewViewModel(id: "1", title: "Placeholder", category: "Placeholder"),
        ArticlePreviewViewModel(id: "2", title: "Placeholder", category: "Placeholder"),
        ArticlePreviewViewModel(id: "3", title: "Placeholder", category: "Placeholder"),
        ArticlePreviewViewModel(id: "4", title: "Placeholder", category: "Placeholder"),
        ArticlePreviewViewModel(id: "5", title: "Placeholder", category: "Placeholder"),
        ArticlePreviewViewModel(id: "6", title: "Placeholder", category: "Placeholder")
    ])
}
