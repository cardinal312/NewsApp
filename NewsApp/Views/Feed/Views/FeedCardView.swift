//
//  FeedCardView.swift
//  NewsApp
//
//  Created by Abdrazak Manasov on 7/10/24.
//

import UIKit

final class FeedCardView: UIView {
    
    // MARK: - VARIABLES
    private let storageManager: StorageManagerProtocol = CoreDataManager()
    private var closure: VoidClosure?
    private var toogle: Bool = true
    
    private lazy var titleLabel: UILabel = {
        $0.numberOfLines = 0
        $0.font = Font.system(ofSize: 24, weight: .bold)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .white
        return $0
    }(UILabel())
    
    private lazy var shortDescriptionLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.numberOfLines = 2
        $0.font = Font.system(ofSize: 16, weight: .regular)
        $0.textColor = UIColor.rgba(255, 0, 0)
        return $0
    }(UILabel())
    
    private lazy var posterImageView: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFill
        return $0
    }(UIImageView())
    
    private lazy var heartImageView: UIImageView = {
        $0.image = UIImage(systemName: "heart")
        $0.image?.withRenderingMode(.alwaysOriginal)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFit
        $0.isUserInteractionEnabled = true
        $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(heartImageViewTapped(sender:))))
        return $0
    }(UIImageView())
    
    // MARK: - LIFE CYCLE
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.posterImageView)
        self.addSubview(self.heartImageView)
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
        
        NSLayoutConstraint.activate([
            self.posterImageView.topAnchor.constraint(equalTo: self.topAnchor),
            self.posterImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.posterImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.posterImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            self.heartImageView.widthAnchor.constraint(equalToConstant: 40),
            self.heartImageView.heightAnchor.constraint(equalToConstant: 40),
            self.heartImageView.topAnchor.constraint(equalTo: self.posterImageView.topAnchor, constant: 15),
            self.heartImageView.trailingAnchor.constraint(equalTo: self.posterImageView.trailingAnchor, constant: -15),
            
            self.titleLabel.bottomAnchor.constraint(equalTo: self.posterImageView.bottomAnchor, constant: -80),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.posterImageView.leadingAnchor, constant: 20),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.posterImageView.trailingAnchor, constant: -20),
            
            self.shortDescriptionLabel.bottomAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 50),
            self.shortDescriptionLabel.leadingAnchor.constraint(equalTo: self.posterImageView.leadingAnchor, constant: 20),
            self.shortDescriptionLabel.trailingAnchor.constraint(equalTo: self.posterImageView.trailingAnchor, constant: -20),
        ])
    }
    
    // MARK: - CELL FUNCTIONS
    @objc private func heartImageViewTapped(sender: UITapGestureRecognizer) {
        if sender.isEnabled {
            if toogle {
                    //self.heartImageView.image = UIImage(systemName: "heart")
                heartImageView.tintColor = .secondarySystemFill
                    print("GOT WHITE HEART")
            
            } else {
                UIView.animate(withDuration: 1, delay: 1, usingSpringWithDamping: 5, initialSpringVelocity: 5) {
                    self.heartImageView.tintColor = .red
                        self.heartImageView.image = UIImage(systemName: "heart.fill")
                        // TODO: - SAVE TO STORAGE
                        print("GOT RED HEART")
                    self.closure?()
                }
            }
            self.toogle.toggle()
        }
    }
    
    public func update(with viewModel: Article) {
        
        self.titleLabel.text = viewModel.title
        self.shortDescriptionLabel.text = viewModel.description
        self.posterImageView.setImage(with: URL(string: viewModel.urlToImage ?? ""))
        self.setNeedsLayout()
        
        self.closure = {
            self.storageManager.saveAllAricle(model: viewModel) { [weak self] results in
                switch results {
                case .success(let success):
                    print("Successfully saved data", success)
                case .failure(let failure):
                    print("Fail save data", failure)
                }
            }
            NotificationCenter.default.post(name: .favorites, object: nil)
        }
    }
}


