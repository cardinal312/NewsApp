//
//  FavoritesViewModel.swift
//  NewsApp
//
//  Created by Abdrazak Manasov on 8/10/24.
//

import Foundation

final class FavoritesViewModel {
    
    private(set) var articles: [Article] = [] {
        didSet {
            DispatchQueue.main.async {
                self.updateClosure?()
            }
        }
    }
    
    var updateClosure: VoidClosure?
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(getArticlesFromFeedView(notification:)), name: .favorites, object: nil)
    }
    
    @objc private func getArticlesFromFeedView(notification: Notification) {
        guard let data = notification.userInfo else { return }
        guard let article = data["data"] as? Article else { return }
        
        DispatchQueue.main.async {
            if !self.articles.contains(article) {
                self.articles.append(article)
            }
            
        }
    }
}
