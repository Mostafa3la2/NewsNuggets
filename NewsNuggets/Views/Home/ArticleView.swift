//
//  ArticleView.swift
//  NewsNuggets
//
//  Created by Mostafa Alaa on 25/11/2023.
//

import SwiftUI

struct ArticleView: View {
    var body: some View {
            ZStack(alignment: .top) {
                VStack {
                    // This view will fill the remaining space
                    SecondView()
                }

                // This view will be pinned to the top
                PinnedView()
            }
        }
    }

    struct PinnedView: View {
        var body: some View {
            Text("Pinned View")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
        }
    }

    struct SecondView: View {
        var body: some View {
            // Example content that fills the space
            ScrollView {
                ForEach(0..<50, id: \.self) { index in
                    Text("Item \(index)")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                }
            }
        }
    }

    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ArticleView()
        }
    }

#Preview {
    ArticleView()
}
