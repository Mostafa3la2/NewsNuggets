//
//  ArticleListItemView.swift
//  NewsNuggets
//
//  Created by Mostafa Alaa on 26/11/2023.
//

import SwiftUI

struct ArticleListItemView: View {
    var body: some View {
        VStack(alignment: .leading) {
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

            VStack(alignment: .leading, spacing: 10) {
                CustomText(type: .title, text: Text("Placeholder that should wrap to two lines"))
                    .lineLimit(2)
                CustomText(type: .grayBody, text: Text("Placeholder "))
                    .lineLimit(1)
            }
            .padding(.leading, 10)
        }
    }
}

#Preview {
    ArticleListItemView()
}
