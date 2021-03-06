//
//  NewsTableViewController.swift
//  NewApp
//
//  Created by Artsiom Habruseu on 5.03.21.
//

import UIKit

class NewsTableViewController: UITableViewController, AlertDisplayer {
    
    // MARK: - Properties
    
    
    lazy private var searchController: UISearchController = {
        let searchController = UISearchController()
        searchController.searchBar.placeholder = "Search Article"
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        return searchController
    }()
    
    private var viewModel: NewsViewModel!
    private var expandedCell: ArticleCell?
    private var expandedIndexSet: IndexSet = []
    
    
    // MARK: - Computed properties
    
    
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    
    private var isFiltering: Bool {
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!searchBarIsEmpty || searchBarScopeIsFiltering)
    }
    
    
    // MARK: - Overrides
    

    override func viewDidLoad() {
        super.viewDidLoad()
        registerNewsCell()
        configureTable()
        configureTableBackground()
        configureRefreshControll()
        viewModel = NewsViewModel(delegate: self)
        viewModel.fetchNews()
        navigationItem.searchController = searchController
    }


    // MARK: - Setup
    
    
    private func registerNewsCell() {
        tableView.register(UINib(nibName: "ArticleCell", bundle: nil), forCellReuseIdentifier: ArticleCell.cellIdentifier)
    }
    
    
    private func configureTable() {
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    
    private func configureTableBackground() {
        let backgroundView = UIView(frame: tableView.frame)
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.systemBackground.cgColor, UIColor.blue.withAlphaComponent(0.5).cgColor]
        gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradient.frame = backgroundView.frame
        backgroundView.layer.addSublayer(gradient)
        tableView.backgroundView = backgroundView
    }
    
    
    private func configureRefreshControll() {
        let refreshControl = UIRefreshControl()
        self.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(pulledToRefresh), for: .valueChanged)
    }
    
    
    // MARK: - Actions
    
    
    @objc private func pulledToRefresh() {
        viewModel.reloadData()
        refreshControl?.endRefreshing()
    }
    
}


// MARK: - Table DataSource


extension NewsTableViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return viewModel.filteredCount
        }
        return viewModel.currentCount
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let articleCell = tableView.dequeueReusableCell(withIdentifier: ArticleCell.cellIdentifier, for: indexPath) as! ArticleCell
        
        let article: Article
        if isFiltering {
            article = viewModel.filteredArticles[indexPath.row]
        } else {
            article = viewModel.articles[indexPath.row]
        }
        
        articleCell.setArticle(article)
        articleCell.delegate = self
        
        if expandedIndexSet.contains(indexPath.row) {
            articleCell.updateToExpanded(true)
        } else {
            articleCell.updateToExpanded(false)
        }
        
        return articleCell
    }
}


// MARK: - Table Delegate


extension NewsTableViewController {
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.layoutSubviews()
        if indexPath.row == (viewModel.currentCount - 1) {
            viewModel.fetchNews()
        }
    }
}


// MARK: - ViewModel Delegate


extension NewsTableViewController: NewsViewModelDelegate {
    
    func onFetchCompleted() {
        tableView.reloadData()
    }
    
    func onFetchFailed(with reason: String) {
        let action = UIAlertAction(title: "OK", style: .default)
        displayAlert(with: "Warning", message: reason, actions: [action])
    }
    
    func onSearchComplited() {
        tableView.reloadData()
    }
}


// MARK: - ArticleCell Delegate


extension NewsTableViewController: ArticleCellDelegate {
    
    func showMoreButtonDidTap(_ cell: ArticleCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            
            if expandedIndexSet.contains(indexPath.row) {
                expandedIndexSet.remove(indexPath.row)
            } else {
                expandedIndexSet.insert(indexPath.row)
            }
            
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
}


// MARK: - Search results updating


extension NewsTableViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        viewModel.search(text)
    }
}
