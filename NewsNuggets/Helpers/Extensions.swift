//
//  Extensions.swift
//  NewsNuggets
//
//  Created by Mostafa Alaa on 06/12/2023.
//

import Foundation

extension String {
    func formatted(with args: [String]?) -> String {
        guard let args = args, args.count > 0 else {
            return self
        }

        var data = self
        for i in 0...args.count - 1 {
            data =  data.replacingOccurrences(of: "{\(i)}", with: args[i])
        }
        return data
    }
}
