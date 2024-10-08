//
//  FeedCardViewModel.swift
//  NewsApp
//
//  Created by Abdrazak Manasov on 7/10/24.
//

import Foundation
import UIKit

final class FeedCardViewModel {
    
    private let articlesNetworkService: ArticlesNetworkProtocol
    private var page: Int = Constants.initialPage
    var updateClosure: VoidClosure?
    
    private(set) var filteredNews: [Article] = []
    private(set) var articles: [Article] = [] {
        didSet {
            DispatchQueue.main.async {
                self.updateClosure?()
            }
        }
    }

    init(articlesNetworkService: ArticlesNetworkProtocol) {
        self.articlesNetworkService = articlesNetworkService
        loadData()
    }
    
    func loadData() {
            let params = ArticlesRequestParams(pageSize: 20, page: self.page, search: "world")
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
    
    // MARK: SEARCH
    func isSearchMode(_ searchController: UISearchController) -> Bool {
        let isActive = searchController.isActive
        let searchText = searchController.searchBar.text ?? ""
        return isActive && !searchText.isEmpty
    }
    
    func updateSearchController(searchBarText: String?) {
            self.filteredNews = articles

            if let searchText = searchBarText?.lowercased() {
                guard !searchText.isEmpty else { self.updateClosure?(); return }
                
                self.filteredNews = self.filteredNews.filter({ ($0.title ?? "").lowercased().contains(searchText) })
            }
            
            self.updateClosure?()
        }
}

private enum Constants {
    static let initialPage = 1
}
