//
//  DetailViewController.swift
//  NewsApp
//
//  Created by Abdrazak Manasov on 7/10/24.
//

import UIKit
import SDWebImage

final class DetailViewController: UIViewController {
    
    // MARK: - VARIABLES
    let viewModel: DetailViewModel
    
    // MARK: - UI COMPONENTS
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let articleLogo: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(systemName: "questionmark")
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.tintColor = .label
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = Font.system(ofSize: 20, weight: .bold)
        label.text = "Error"
        label.numberOfLines = 0
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = Font.system(ofSize: 18, weight: .medium)
        label.text = "Error"
        label.numberOfLines = 0
        return label
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = Font.system(ofSize: 18, weight: .regular)
        label.text = "Error"
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var verticalLabelsStack: UIStackView = {
        let vStack = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel, contentLabel])
        vStack.translatesAutoresizingMaskIntoConstraints = false
        vStack.axis = .vertical
        vStack.spacing = 20
        vStack.distribution = .fillProportionally
        vStack.alignment = .center
        return vStack
    }()
    
    // MARK: - LIFE CYCLE
    init(_ viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        
        self.view.backgroundColor = .systemBackground
        self.navigationItem.title = Localization.details
        self.titleLabel.text = self.viewModel.article.title
        self.descriptionLabel.text = self.viewModel.article.description
        self.contentLabel.text = self.viewModel.article.content
        self.articleLogo.setImage(with: URL(string: self.viewModel.image_url))
    }
    
    // MARK: - SETUP UI
    private func setupUI() {
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(contentView)
        self.contentView.addSubview(articleLogo)
        self.contentView.addSubview(verticalLabelsStack)
        
        let height = contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        height.priority = UILayoutPriority(1)
        height.isActive = true
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            scrollView.heightAnchor.constraint(equalTo: view.layoutMarginsGuide.heightAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            articleLogo.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            articleLogo.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 20),
            articleLogo.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            articleLogo.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            articleLogo.heightAnchor.constraint(equalToConstant: 200),
            
            verticalLabelsStack.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            verticalLabelsStack.topAnchor.constraint(equalTo: articleLogo.bottomAnchor, constant: 60),
            verticalLabelsStack.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            verticalLabelsStack.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            verticalLabelsStack.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
        ])
    }
}

