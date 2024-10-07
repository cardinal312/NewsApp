//
//  NetworkServiceProtocol.swift
//  NewsApp
//
//  Created by Abdrazak Manasov on 7/10/24.
//

import Foundation

struct ArticlesRequestParams {
    let pageSize: Int
    let page: Int
    let search: String
}

protocol ArticlesNetworkProtocol {
    func requestArticles(params: ArticlesRequestParams, completion: @escaping (Result<ArticlesResponse, Error>) -> Void)
}

struct ArticlesResponse: Decodable {
    let articles: [Article]
}


