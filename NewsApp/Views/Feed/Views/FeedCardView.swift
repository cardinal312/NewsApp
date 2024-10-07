//
//  FeedCardView.swift
//  NewsApp
//
//  Created by Abdrazak Manasov on 7/10/24.
//

import UIKit

final class FeedCardView: UIView {

    private lazy var titleLabel: UILabel = {
        $0.numberOfLines = 3
        $0.font = Font.system(ofSize: 24, weight: .bold)
        $0.textColor = .white
        return $0
    }(UILabel())
    
    private lazy var shortDescriptionLabel: UILabel = {
        $0.numberOfLines = 2
        $0.font = Font.system(ofSize: 16, weight: .regular)
        $0.textColor = UIColor.rgba(255, 0, 0)
        return $0
    }(UILabel())
    
    private lazy var imageView: UIImageView = {
        $0.contentMode = .scaleAspectFill
        return $0
    }(UIImageView())

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.imageView)
        self.addSubview(self.titleLabel)
        self.addSubview(self.shortDescriptionLabel)
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("unsupported")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let maxLabelWidth = self.frame.width - Constants.margin * 2
        let maxLabelSize = CGSize(width: maxLabelWidth, height: .greatestFiniteMagnitude)

        let shortDescriptionSize = self.shortDescriptionLabel.sizeThatFits(maxLabelSize)
        let shortDescriptionOrigin = CGPoint(x: Constants.margin,
                                             y: self.frame.height - Constants.margin - shortDescriptionSize.height)
        self.shortDescriptionLabel.frame.origin = shortDescriptionOrigin
        self.shortDescriptionLabel.frame.size = shortDescriptionSize

        let titleLabelSize = self.titleLabel.sizeThatFits(maxLabelSize)
        let titleLabelOrigin = CGPoint(x: Constants.margin,
                                       y: self.shortDescriptionLabel.frame.minY - Constants.titleMarginBottom - titleLabelSize.height)
        self.titleLabel.frame.origin = titleLabelOrigin
        self.titleLabel.frame.size = titleLabelSize

        self.imageView.frame = self.frame
    }

    func update(with viewModel: Article) {
        self.titleLabel.text = viewModel.title
        self.shortDescriptionLabel.text = viewModel.description
        self.imageView.setImage(with: URL(string: viewModel.urlToImage ?? ""))
        self.setNeedsLayout()
    }
}

private struct Constants {
    static let margin: CGFloat = 24
    static let titleMarginBottom: CGFloat = 8
}
