//
//  URLFactory.swift
//  NewsApp
//
//  Created by Abdrazak Manasov on 7/10/24.
//

import Foundation

enum URLFactory {
    //private static let apiKey = "7ba646457e7a40b29f317b2e43b5081f" //unlimited plane
    //private static let apiKey = "035e0c73bd8348ef8834316029bdd255" // bibi
    //private static let apiKey = "dabf757d67984f9db7ac7cf358a2b45c" // mainthred
    //private static let apiKey = "e61880c19e814a3d80a600195ae37eb2" // man7777
    private static let apiKey = "bf39810795944cadb096675be91c03fd" // kelly
    
    private static var baseUrl: URL {
        return baseUrlComponents.url!
    }
    private static let baseUrlComponents: URLComponents = {
        let url = URL(string: "https://newsapi.org/v2/")!
        let queryItem = URLQueryItem(name: "apiKey", value: URLFactory.apiKey)
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        urlComponents.queryItems = [queryItem]
        return urlComponents
    }()

    static func articles(params: ArticlesRequestParams) -> String {
        let params = [URLQueryItem(name: "pageSize", value: "\(params.pageSize)"),
                      URLQueryItem(name: "page", value: "\(params.page)"),
                      URLQueryItem(name: "q", value: params.search)]
        var urlComponents = baseUrlComponents
        urlComponents.queryItems?.append(contentsOf: params)
        return urlComponents.url!.appendingPathComponent("everything").absoluteString
    }
}
