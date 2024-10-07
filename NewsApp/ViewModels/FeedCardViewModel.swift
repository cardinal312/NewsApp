//
//  FeedCardViewModel.swift
//  NewsApp
//
//  Created by Abdrazak Manasov on 7/10/24.
//

import Foundation

final class FeedCardViewModel {
    
     private(set) var articles: [Article] = [] {
        didSet {
            DispatchQueue.main.async {
                self.updateClosure?()
            }
        }
    }
    
    var updateClosure: VoidClosure?
    
    private let articlesNetworkService: ArticlesNetworkProtocol
    private var page: Int = Constants.initialPage
    
    init(articlesNetworkService: ArticlesNetworkProtocol) {
        self.articlesNetworkService = articlesNetworkService
        loadData()
    }
    
    func loadData() {
        let params = ArticlesRequestParams(pageSize: 20, page: self.page, search: "nature")
        self.articlesNetworkService.requestArticles(params: params) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.articles = response.articles
                //self.page += 1
            case .failure(let error):
                print("CAN'T GOT ARTICLES WITH ERROR -->> \(error.localizedDescription) <<--")
            }
        }
    }
    
    // TODO: - FOR PAGING IN THE FUTURE
    func reload() {
        self.page = Constants.initialPage
        self.loadData()
    }
    
    func loadNext() {
        self.loadData()
    }
}

private enum Constants {
    static let initialPage = 1
}
