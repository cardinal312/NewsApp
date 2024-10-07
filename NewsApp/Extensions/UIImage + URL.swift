//
//  UIImage + URL.swift
//  NewsApp
//
//  Created by Abdrazak Manasov on 7/10/24.
//

import UIKit
import SDWebImage

extension UIImageView {
    func setImage(with url: URL?) {
        self.sd_setImage(with: url)
    }
}
