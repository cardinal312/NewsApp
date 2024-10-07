//
//  Articles.swift
//  NewsApp
//
//  Created by Abdrazak Manasov on 7/10/24.
//

import Foundation

struct Article: Decodable, Hashable {
    let identifier: String = UUID().uuidString
    let title: String?
    let description: String?
    let urlToImage: String?
    let content: String?
}
