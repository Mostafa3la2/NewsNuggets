//
//  CustomText.swift
//  NewsNuggets
//
//  Created by Mostafa Alaa on 26/11/2023.
//

import SwiftUI


enum TextTypes {
    case heading
    case title
    case navigationTitle
    case smallTitle
    case body
    case grayBody
}
struct CustomText: View {
    var type: TextTypes
    var color: Color?
    var text: Text
    var body: some View {
        text
            .foregroundStyle(color != nil ? color! : (type == .grayBody ? .gray : .black))
            .font(assignFont())
            .truncationMode(.tail)
    }

    private func assignFont() -> Font{
        switch type {
        case .heading:
            return .custom(Typography.bold.name, size: 32)
        case .title:
            return .custom(Typography.medium.name, size: 24)
        case .navigationTitle:
            return .custom(Typography.medium.name, size: 22)
        case .smallTitle:
            return .custom(Typography.medium.name, size: 18)
        case .body:
            return .custom(Typography.regular.name, size: 16)
        case .grayBody:
            return .custom(Typography.regular.name, size: 16)
        }
    }
}

#Preview {
    CustomText(type: .title, text: Text("placeholder"))
}

