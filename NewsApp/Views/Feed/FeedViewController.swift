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
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(FeedViewCell<FeedCardView>.self)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .white
        cv.contentInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    private lazy var searchController: UISearchController = {
        let sc = UISearchController(searchResultsController: nil)
        sc.searchResultsUpdater = self
        sc.obscuresBackgroundDuringPresentation = false
        sc.hidesNavigationBarDuringPresentation = false
        sc.searchBar.placeholder = "Поиск.."
        sc.delegate = self
        sc.searchBar.delegate = self
        sc.searchBar.showsBookmarkButton = true
        sc.searchBar.setImage(UIImage(systemName: .searchBarIcon), for: .bookmark, state: .normal)
        return sc
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
        self.setupSearchController()
        
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
    
    private func setupSearchController() {
        self.navigationItem.searchController = searchController
        self.definesPresentationContext = false
        self.navigationItem.hidesSearchBarWhenScrolling = true
    }
}

// MARK: - COLLECTION VIEW METHODS
extension FeedViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return self.viewModel.articles.count
        let isSearchMode = self.viewModel.isSearchMode(searchController)
        return isSearchMode ? self.viewModel.filteredNews.count : self.viewModel.articles.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueCell(cellType: FeedViewCell<FeedCardView>.self, for: indexPath)
        let isSearchMode = self.viewModel.isSearchMode(searchController)
        let article = isSearchMode ? self.viewModel.filteredNews[indexPath.item] : self.viewModel.articles[indexPath.item]
        cell.containerView.update(with: article)
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
        
        let isSearchMode = self.viewModel.isSearchMode(searchController)
        let  article = isSearchMode ? self.viewModel.filteredNews[indexPath.item] : self.viewModel.articles[indexPath.item]
        let vm = DetailViewModel(article)
        let vc = DetailViewController(vm)
        //self.navigationController?.pushViewController(vc, animated: true)
        
        NotificationCenter.default.post(name: .favorites, object: nil, userInfo: ["data" : article])
    }
}

    // MARK: - Search Controller Functions
extension FeedViewController: UISearchBarDelegate, UISearchResultsUpdating, UISearchControllerDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        self.viewModel.updateSearchController(searchBarText: searchController.searchBar.text)
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        print("Search bar button called!")
    }
}
