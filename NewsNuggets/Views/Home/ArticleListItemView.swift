//
//  ArticleListItemView.swift
//  NewsNuggets
//
//  Created by Mostafa Alaa on 26/11/2023.
//

import SwiftUI

struct ArticleListItemView: View {
    var articlePreviewViewModel: ArticlePreviewViewModel
    var body: some View {
        VStack(alignment: .leading) {
            if articlePreviewViewModel.imageURL != nil {
                AsyncImage(url: URL(string: articlePreviewViewModel.imageURL!)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image.resizable()
                            .scaledToFill()
                            .clipped()
                            .frame(width:270, height: 270)
                            .clipShape(.rect(
                                topLeadingRadius: 8,
                                bottomLeadingRadius: 8,
                                bottomTrailingRadius: 8,
                                topTrailingRadius: 8
                            ))
                            .padding(.all, 5)
                    case .failure:
                        Image("articlePlaceholder")
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                Image("articlePlaceholder")
                    .resizable()
                    .scaledToFill()
                    .clipped()
                    .frame(width:270, height: 270)
                    .clipShape(.rect(
                        topLeadingRadius: 8,
                        bottomLeadingRadius: 8,
                        bottomTrailingRadius: 8,
                        topTrailingRadius: 8
                    ))
                    .padding(.all, 5)
            }


            VStack(alignment: .leading, spacing: 10) {
                CustomText(type: .title, text: Text(articlePreviewViewModel.title ?? ""))
                    .lineLimit(2)
                CustomText(type: .grayBody, text: Text(articlePreviewViewModel.category ?? ""))
                    .lineLimit(1)
            }
            .padding(.leading, 10)
        }
    }
}

#Preview {
    ArticleListItemView(articlePreviewViewModel: ArticlePreviewViewModel(id: "1",title: "test", category: "Test"))
}
