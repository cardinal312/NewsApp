//
//  DetailViewModel.swift
//  NewsApp
//
//  Created by Abdrazak Manasov on 7/10/24.
//

import Foundation

final class DetailViewModel {
   
    // MARK: - VARIABLES
    let article: Article
    
    // MARK: - LIFE CYCLE
    init(_ article: Article) {
        self.article = article
    }
    
    // MARK: - COMPUTED PROPERTIES
    var title: String {
        return "Title: \(self.article.title ?? "")"
    }
    
    var description: String {
        return "Description: \(self.article.description ?? "")"
    }
    
    var image_url: String {
        if let image_url = article.urlToImage {
            return image_url
        } else {
            return "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRAPJP7ftvY9SJxu44j0H2kAUiNVVgvoJl2hg&s"
        }
    }
    
    var content: String {
        if let content = article.content {
            return content
        } else {
            return ""
        }
    }
}


