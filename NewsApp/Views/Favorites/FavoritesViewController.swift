//
//  FavoritesViewController.swift
//  News App
//
//  Created by Abdrazak Manasov on 7/10/24.
//

import UIKit

final class FavoritesViewController: UIViewController {
    
    // MARK: - VARIABLES
    private var viewModel: FavoritesViewModel
    
    // MARK: - UI COMPONENTS
    private lazy var favoritesTableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.register(FavoriteTableViewCell.self)
        tv.showsVerticalScrollIndicator = false
        tv.backgroundColor = .white
        tv.delegate = self
        tv.dataSource = self
        return tv
    }()
    
    // MARK: LIFE CYCLE
    init(viewModel: FavoritesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.updateClosure = { [weak self] in
            DispatchQueue.main.async {
                self?.favoritesTableView.reloadData()
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.setupUI()
    }
    
    // MARK: - SETUP UI
    private func setupUI() {
        self.view.addSubview(favoritesTableView)
        self.favoritesTableView.frame = view.bounds
    }
}

extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UITABLE VIEW METHODS
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueCell(cellType: FavoriteTableViewCell.self, for: indexPath) as? FavoriteTableViewCell else { return UITableViewCell() }
        let article = viewModel.articles[indexPath.row]
        //let article = Article(title: "sfsdfsdf", description: "fsdfdsfds", urlToImage: "https://avatars.mds.yandex.net/i?id=0c2561f992a88f7ac75d3ff6d9664fbb_l-4944748-images-thumbs&n=13", content: "dsgdgsfgfdg")
        cell.update(with: article)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    // TODO: DELETE ROWS
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            
            // MARK: - DELETION DATA FROM LOCAL STORAGE
            let article = viewModel.articles[indexPath.row]
            viewModel.deleteItem(tableView: tableView, article: article, indexPath: indexPath)
        default: break
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let article = viewModel.articles[indexPath.row]
        DispatchQueue.main.async { [weak self] in
            let vm = DetailViewModel(article)
            let vc = DetailViewController(vm)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

