//
//  FavoritesViewModel.swift
//  NewsApp
//
//  Created by Abdrazak Manasov on 8/10/24.
//

import Foundation
import UIKit

final class FavoritesViewModel {
    
    // MARK: - VARIABLES
    private let storageManager: StorageManagerProtocol
    var updateClosure: VoidClosure?
    
    private(set) var articles: [Article] = [] {
        didSet {
            DispatchQueue.main.async {
                self.updateClosure?()
            }
        }
    }
    
    // MARK: - LIFE CYCLE
    init(storageManager: StorageManagerProtocol) {
        self.storageManager = storageManager
        self.fetchLocalStorageFromDownload()
        NotificationCenter.default.addObserver(self, selector: #selector(getArticlesFromFeedView(notification:)), name: .favorites, object: nil)
    }
    
    @objc private func getArticlesFromFeedView(notification: Notification) {
        DispatchQueue.main.async {
            self.fetchLocalStorageFromDownload()
        }
    }
    
    private func fetchLocalStorageFromDownload() {
        self.storageManager.fetchArticles { [weak self] results in
            guard let self else { return }
            switch results {
            case .success(let articless):
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    self.articles = articless
                    self.updateClosure?()
                }
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
        // MARK: - CALLED IN VC TABLE VIEW METHOD
    func deleteItem(tableView: UITableView, article: Article, indexPath: IndexPath) {
        let articleItem = ArticleItem()
        articleItem.title = article.title
        articleItem.descript = article.description
        articleItem.urlToImage = article.urlToImage
        articleItem.content = article.content
        
        storageManager.deleteWith(model: articleItem) { [weak self] results in
            guard let self else { return }
            switch results {
            case .success(let success):
                print("Successfully deleted data from db", success)
            case .failure(let failure):
                print("Fail delete data from db", failure)
            }
        }
        
        self.articles.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        self.fetchLocalStorageFromDownload()
        self.updateClosure?()
    }
}
