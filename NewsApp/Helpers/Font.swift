//
//  Font.swift
//  News App
//
//  Created by Abdrazak Manasov on 7/10/24.
//

import UIKit

enum Font {
    enum Weight {
        case regular, medium, bold
    }

    static func system(ofSize size: CGFloat, weight: Weight) -> UIFont {
        switch weight {
        case .regular:
            return UIFont.systemFont(ofSize: size, weight: .regular)
        case .medium:
            return UIFont.systemFont(ofSize: size, weight: .medium)
        case .bold:
            return UIFont.systemFont(ofSize: size, weight: .bold)
        }
    }
}
