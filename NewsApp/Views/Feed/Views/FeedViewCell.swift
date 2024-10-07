//
//  FeedViewCell.swift
//  NewsApp
//
//  Created by Abdrazak Manasov on 7/10/24.
//

import UIKit

final class FeedViewCell<T: UIView>: UICollectionViewCell {

    let containerView: T

    override init(frame: CGRect) {
        self.containerView = T(frame: .zero)
        super.init(frame: frame)
        self.contentView.addSubview(self.containerView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("unsupported")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.containerView.frame = self.contentView.frame
    }
}
