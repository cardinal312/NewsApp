//
//  Styles.swift
//  News App
//
//  Created by Abdrazak Manasov on 7/10/24.
//

import UIKit

public enum Styles {
    
    enum TabbarItem {
        static let feed = UIImage(named: "feed")
        static let favorites = UIImage(named: "favorites")
    }
    
    enum TabbarSelectedItem {
        static let feed = UIImage(systemName: "book.fill")
        static let favorites = UIImage(systemName: "star.fill")
    }
}
