//
//  ViewController.swift
//  News App
//
//  Created by Abdrazak Manasov on 7/10/24.
//

import UIKit

final class FeedViewController: UIViewController {

    // MARK: - VARIABLES
    private var viewModel: FeedCardViewModel
    
    // MARK: - UI COMPONENTS
    private lazy var feedCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(FeedViewCell<FeedCardView>.self)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .white
        collection.contentInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        collection.delegate = self
        collection.dataSource = self
        return collection
    }()
    
    // MARK: - LIFE CYCLE
    init(viewModel: FeedCardViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupCollectionView()
        self.setupNavigationToolBar()
        
        self.viewModel.updateClosure = { [weak self] in
            DispatchQueue.main.async {
                self?.feedCollectionView.reloadData()
            }
        }
    }
    
    // MARK: - SETUP UI AND CONSTRAINTS
    private func setupCollectionView() {
        view.addSubview(feedCollectionView)
        NSLayoutConstraint.activate([
            self.feedCollectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.feedCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.feedCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.feedCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
    }
    
    private func setupNavigationToolBar() {
        self.navigationItem.rightBarButtonItem = BlockBarButtonItem.item(title: Localization.settings, style: .plain, handler: { [weak self] in
            print("Login button tapped")
        })
    }
}

    // MARK: - COLLECTION VIEW METHODS
extension FeedViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.articles.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = self.viewModel.articles[indexPath.item]
        let cell = collectionView.dequeueCell(cellType: FeedViewCell<FeedCardView>.self, for: indexPath)
        cell.containerView.update(with: model)
        return cell
    }
}

extension FeedViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let ratio: CGFloat = 1.2
        let width = collectionView.frame.width - collectionView.contentInset.left - collectionView.contentInset.right
        let height = width * ratio
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        print(indexPath.item)
        
        let article = viewModel.articles[indexPath.item]
        let vm = DetailViewModel(article)
        let vc = DetailViewController(vm)
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
