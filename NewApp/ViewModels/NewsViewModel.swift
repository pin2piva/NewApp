//
//  NewsViewModel.swift
//  NewApp
//
//  Created by Artsiom Habruseu on 5.03.21.
//

import Foundation


protocol NewsViewModelDelegate: class {
    func onFetchCompleted()
    func onFetchFailed(with reason: String)
    func onSearchComplited()
}


class NewsViewModel {
    
    // MARK: - Delegate
    
    
    private weak var delegate: NewsViewModelDelegate?
    
    
    // MARK: - Stored Properties
    
    
    var articles: [Article] = []
    
    var filteredArticles: [Article] = []
    
    private let downloader = Downloader()
    
    private var currentPage = 0
        
    private var toDate = Date()
    
    private var isFetchInProgress = false
    
    private let dayDuration = 60.0 * 60.0 * 24.0
    
    
    // MARK: - Computed Properties
    
    
    private var fromDate: Date {
        Date(timeInterval: -dayDuration, since: toDate)
    }
    
    var currentCount: Int {
        articles.count
    }
    
    
    var filteredCount: Int {
        filteredArticles.count
    }
    
    
    // MARK: - Init
    
    
    init(delegate: NewsViewModelDelegate) {
        self.delegate = delegate
    }
    
    
    // MARK: - Methods
    
    
    func fetchNews() {
        guard !isFetchInProgress, currentPage < 7 else { return }
        
        isFetchInProgress = true
        
        downloader.fetchNews(fromDate: fromDate.toString,
                             toDate: toDate.toString)
        { (result) in
            switch result {
            
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isFetchInProgress = false
                    self.delegate?.onFetchFailed(with: error.description)
                }
                
            case .success(let response):
                DispatchQueue.main.async {
                    if self.currentPage == 0 {
                        self.articles = []
                    }
                    self.currentPage += 1
                    self.updateToDateForCurrentPage()
                    self.isFetchInProgress = false
                    
                    self.articles.append(contentsOf: response.articles)
                    
                    self.delegate?.onFetchCompleted()
                }
            }
        }
    }
    
    
    func reloadData() {
        currentPage = 0
        updateToDateForCurrentPage()
        fetchNews()
    }
    
    
    func search(_ text: String) {
        filteredArticles = articles.filter { $0.title.lowercased().contains(text.lowercased()) }
        delegate?.onSearchComplited()
    }
    
    
    // MARK: - Private
    
    
    private func updateToDateForCurrentPage() {
        toDate = Date(timeIntervalSinceNow: -(dayDuration) * Double(currentPage))
    }
    
}
