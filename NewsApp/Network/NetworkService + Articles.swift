//
//  NetworkService + Articles.swift
//  NewsApp
//
//  Created by Abdrazak Manasov on 7/10/24.
//

import Foundation

extension NetworkService: ArticlesNetworkProtocol {
    
    func requestArticles(params: ArticlesRequestParams, completion: @escaping (Result<ArticlesResponse, Error>) -> Void) {
        let url = URLFactory.articles(params: params)
        self.baseRequest(url: url, completion: completion)
    }
}
