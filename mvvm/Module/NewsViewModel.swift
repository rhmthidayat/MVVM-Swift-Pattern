//
//  NewsViewModel.swift
//  mvvm
//
//  Created by Rahmat Hidayat on 29/01/19.
//  Copyright © 2019 Rahmat. All rights reserved.
//

import Foundation

class NewsViewModel {
    
    let apiService: APIServiceProtocol
    var listNews: News!
    var articleSelected: Article!
    
    var reloadTbDataClosure: (()->())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    
    private var cellViewModel: [NewsCellViewModel] = [NewsCellViewModel]() {
        didSet {
            self.reloadTbDataClosure?()
        }
    }
    
    var numberOfCells: Int {
        return self.cellViewModel.count
    }
    
    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    
    var alertMessage: String? {
        didSet {
            self.showAlertClosure?()
        }
    }
    
    func getCellViewModel( at indexPath: IndexPath) -> NewsCellViewModel {
        return cellViewModel[indexPath.row]
    }
    
    func didSelectCell(at indexPath: IndexPath) {
        let news = self.listNews!
        self.articleSelected = news.articles![indexPath.row]
    }
    
    init(apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }
    
    func initFetch() {
        self.isLoading = true
        self.apiService.fetchNews(withParams: ["test":"params"]) { [weak self] (success, news, error) in
            self?.isLoading = false
            if let error = error {
                self?.alertMessage = error.rawValue
            }else{
                self?.showFecthedNews(news: news)
            }
        }
    }
    
    private func showFecthedNews(news: News) {
        self.listNews = news
        var vm = [NewsCellViewModel]()
        if let articles = news.articles {
            for article in articles {
                vm.append(self.createCellViewModel(article: article))
            }
        }
        self.cellViewModel = vm
    }
    
    func createCellViewModel(article: Article) -> NewsCellViewModel {        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return NewsCellViewModel(title: article.title ?? "",
                                 author: article.author ?? "",
                                 description: article.description ?? "",
                                 urlToImage: article.urlToImage ?? "",
                                 publishedAt: dateFormatter.string(from: article.publishedAt!))
    }
    
}

struct NewsCellViewModel {
    let title: String
    let author: String
    let description: String
    let urlToImage: String
    let publishedAt: String
}
