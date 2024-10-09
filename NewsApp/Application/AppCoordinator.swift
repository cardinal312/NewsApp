//
//  AppCoordinator.swift
//  NewsApp
//
//  Created by Abdrazak Manasov on 7/10/24.
//

import UIKit

final class AppCoordinator {
    
    private var window: UIWindow
    private lazy var tabBarController = UITabBarController()
    private lazy var navigationControllers = AppCoordinator.makeNavigationControllers()
    
    init(window: UIWindow) {
        self.window = window
        self.setupAppearance()
    }
    
    func start() {
        
        self.setupFeed()
        self.setupFavorites()
        
        let navigationControllers = NavControllerType.allCases.compactMap {
            self.navigationControllers[$0]
        }
        self.tabBarController.setViewControllers(navigationControllers, animated: true)
        self.window.rootViewController = self.tabBarController
        self.window.makeKeyAndVisible()
    }
}

private extension AppCoordinator {
    
    private func setupFeed() {
        guard let navController = self.navigationControllers[.feed] else { fatalError("can't find navController") }
        
        let vc = ScreenFactory.make(vc: .feed)
        vc.navigationItem.title = NavControllerType.feed.title
        navController.setViewControllers([vc], animated: false)
    }
    
    private func setupFavorites() {
        guard let navController = self.navigationControllers[.favorites] else { fatalError("can't find navController") }
    
        let vc = ScreenFactory.make(vc: .favorite)
        vc.navigationItem.title = NavControllerType.favorites.title
        navController.navigationBar.prefersLargeTitles = true
        navController.navigationItem.largeTitleDisplayMode = .always
        navController.view.backgroundColor = .white
        navController.setViewControllers([vc], animated: false)
    }
    
    private func setupAppearance() {
        UINavigationBar.appearance().barTintColor = .white
        UINavigationBar.appearance().tintColor = .black
        
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.backgroundColor = .white
            
            UINavigationBar.appearance().tintColor = .black
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().compactAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        } else {
            UINavigationBar.appearance().tintColor = .black
            UINavigationBar.appearance().barTintColor = .purple
            UINavigationBar.appearance().isTranslucent = true
        }
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        UITabBar.appearance().tintColor = .systemGreen
        UITabBar.appearance().backgroundColor = .gray.withAlphaComponent(0.1)
    }
    
    private static func makeNavigationControllers() -> [NavControllerType: UINavigationController] {
        var result: [NavControllerType: UINavigationController] = [:]
        
        NavControllerType.allCases.forEach { navControllerKey in
            let navigationController = UINavigationController()
            let tabBarItem = UITabBarItem(title: navControllerKey.title,
                                          image: navControllerKey.image,
                                          tag: navControllerKey.rawValue)
            navigationController.tabBarItem = tabBarItem
            //navigationController.navigationBar.prefersLargeTitles = true
            result[navControllerKey] = navigationController
        }
        return result
    }
}

fileprivate enum NavControllerType: Int, CaseIterable {
    case feed, favorites
    
    var title: String? {
        switch self {
        case .feed:
            return Localization.feed
        case .favorites:
            return Localization.favorites
        }
    }
    
    var image: UIImage? {
        switch self {
        case .feed:
            return Styles.TabbarItem.feed
        case .favorites:
            return Styles.TabbarItem.favorites
        }
    }
}
