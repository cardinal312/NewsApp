//
//  FactoryController.swift
//  NewsApp
//
//  Created by Abdrazak Manasov on 7/10/24.
//

import UIKit

final class ScreenFactory {
    
    static func make(vc: Controllers) -> UIViewController {
        switch vc {
        case .feed:
            let articlesNetworkService = NetworkService()
            let viewModel = FeedCardViewModel(articlesNetworkService: articlesNetworkService)
            let vc = FeedViewController(viewModel: viewModel)
            return vc
        case .favorite:
            let vc = FavoritesViewController()
            vc.view.backgroundColor = .blue
            return vc
        }
    }
}

enum Controllers {
    case feed, favorite
}
