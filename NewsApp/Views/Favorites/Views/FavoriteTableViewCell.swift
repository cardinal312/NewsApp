//
//  FavoriteTableViewCell.swift
//  NewsApp
//
//  Created by Abdrazak Manasov on 8/10/24.
//

import UIKit

final class FavoriteTableViewCell: UITableViewCell {
    
    // MARK: - UI COMPONENTS
    private let titlesPosterImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "message"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 12
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "ERROR"
        label.numberOfLines = 0
        label.font = Font.system(ofSize: 17, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - CELL CONFIGURE
    public func update(with viewModel: Article) {
        
        guard let url = URL(string: viewModel.urlToImage ?? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRAPJP7ftvY9SJxu44j0H2kAUiNVVgvoJl2hg&s") else { return }
        
        self.titlesPosterImageView.setImage(with: url)
        self.titleLabel.text = viewModel.title
    }
    
    // MARK: - SETUP UI
    private func setupConstraints() {
        contentView.addSubview(titlesPosterImageView)
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            self.titlesPosterImageView.widthAnchor.constraint(equalToConstant: 100),
            self.titlesPosterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            self.titlesPosterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            self.titlesPosterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            self.titleLabel.leadingAnchor.constraint(equalTo: self.titlesPosterImageView.trailingAnchor, constant: 20),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
            self.titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
}
