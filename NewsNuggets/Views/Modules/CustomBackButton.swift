//
//  CustomBackButton.swift
//  NewsNuggets
//
//  Created by Mostafa Alaa on 28/11/2023.
//

import SwiftUI

struct CustomBackButton: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        Button(action: {
            dismiss()
        }) {
            Label("", systemImage: "chevron.backward")
        }
        .tint(Color.white)
        .padding(.leading, 20)
    }
}

#Preview {
    CustomBackButton()
        .background(Color.black)
}
