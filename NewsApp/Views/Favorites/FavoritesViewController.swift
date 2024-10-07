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
        self.setupUI()
        
        viewModel.updateClosure = { [weak self] in
            DispatchQueue.main.async {
                self?.favoritesTableView.reloadData()
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.favoritesTableView.frame = view.bounds
    }
    
    // MARK: - SETUP UI
    private func setupUI() {
        self.view.addSubview(favoritesTableView)
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
        cell.update(with: article)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    // TODO: DELETE ROWS
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //
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

