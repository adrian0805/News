//
//  NewsListViewModel.swift
//  PlandayNews
//
//  Created by Macarenco Adrian on 04.03.2021.
//

import Foundation
import Combine

class NewsListViewModel: ObservableObject {
    @Published var news: News?
    @Published var articles = [Article]()
    @Published var searchedArticles = [Article]()
    @Published var searchText = ""
    @Published var isSearching = false
    var page: Int = 1
    var searchPage: Int = 1
    var hasMoreNews = true
    var cancellables = Set<AnyCancellable>()
    
    init() {
        self.subscribeToSearchText()
    }

    func getNews(isPaging: Bool = false) {
        
        NewsAPI.topHeadlines(country: "us", page: page)
            .receive(on: DispatchQueue.main)
            .sink { (completion) in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error)
                }
            } receiveValue: { [unowned self] news in
                self.articles.append(contentsOf: news.articles)
                self.checkNextPageData(articles: news.articles)
            }
            .store(in: &cancellables)
    }
    
    func getNextPageNews(isPaging: Bool) {
        if isPaging {
            if isSearching, !searchText.isEmpty {
                searchPage += 1
            } else {
                page += 1
            }
        }
        guard hasMoreNews else {
            return
        }
        isSearching && !searchText.isEmpty ? searchNews(isPaging: isPaging) : getNews(isPaging: isPaging)
    }
    
    private func subscribeToSearchText() {
        $searchText
            .removeDuplicates()
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .filter{ $0.count >= 3}
            .sink { [unowned self] searchText in
                if searchText.isEmpty {
                    searchedArticles.removeAll()
                    return
                }
                self.hasMoreNews = true
                self.searchNews()
        }
        .store(in: &cancellables)
        
        $isSearching
            .dropFirst()
            .sink { [unowned self] isSearchingBool in
                if !isSearchingBool {
                    self.searchedArticles.removeAll()
                }
                self.hasMoreNews = true
        }
        .store(in: &cancellables)
    }
    
    private func checkNextPageData(articles: [Article]) {
        if articles.count < 20 {
            hasMoreNews = false
        }
    }
    
    func searchNews(isPaging: Bool = false) {
        NewsAPI.searchNews(searchString: searchText, page: searchPage)
            .sink { (completion) in
                switch completion {
                case .finished:
                    break
                case .failure(_):
                    break
                }
            } receiveValue: { (news) in
                print(news)
                DispatchQueue.main.async {
                    if isPaging {
                        self.searchedArticles.append(contentsOf: news.articles)
                    } else {
                        self.searchedArticles = news.articles
                    }
                    
                }
                self.checkNextPageData(articles: news.articles)

            }.store(in: &cancellables)
    }
}
