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
    @Published var selectedTab = Tabs.general
    var searchPage: Int = 1
    var hasMoreNews = true
    var cancellables = Set<AnyCancellable>()
    var downloadedIndexes = Set<Int>()
    var tabsPageNumber = [Tabs:(Int, Bool)]()
    @Published var tabsArticles = [Tabs : [Article]] ()
    @Published var scrollTop = false

    
    init() {
        setTabsPageNumber()
        subscribeToSearchText()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.scrollTop = true
        }
    }
    
    func setTabsPageNumber() {
        for tab in Tabs.allCases {
            tabsPageNumber[tab] = (1, true)
            tabsArticles[tab] = []
        }
    }

    func getNews() {
        guard let page = tabsPageNumber[selectedTab]?.0 else { return}
         
        NewsAPI.topHeadlines(page: page, category: selectedTab.rawValue)
            .receive(on: DispatchQueue.main)
            .sink { (completion) in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error)
                }
            } receiveValue: { [unowned self] news in
                self.tabsArticles[selectedTab]?.append(contentsOf: news.articles)
                self.checkNextPageData(articles: news.articles)
            }
            .store(in: &cancellables)
    }
    
    func getNextPageNews(isPaging: Bool) {
        if isPaging {
            if isSearching, !searchText.isEmpty {
                searchPage += 1
            } else {
                tabsPageNumber[selectedTab]?.0 += 1
                //page += 1
            }
        }
        guard let hasMoreNews = tabsPageNumber[selectedTab]?.1,
              hasMoreNews else { return}
        isSearching && !searchText.isEmpty ? searchNews(isPaging: isPaging) : getNews()
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
        
        $selectedTab
            .sink {selectedTab in
                print(selectedTab)
                self.getNews(selectedTab: selectedTab)
        }
        .store(in: &cancellables)
    }
    
    private func getNews(selectedTab: Tabs) {
        guard let tabIndex = Tabs.allCases.firstIndex(of: selectedTab)
        else {
            return
        }
        for index in [ tabIndex, tabIndex + 1 , tabIndex + 2] {
            if index < Tabs.allCases.count,
               index >= 0,
               !downloadedIndexes.contains(index) {
                print("Donwloaded for index: \(index)")
                let category = Tabs.allCases[index]
                getNewsForTab(selectedTab: category, category: category.rawValue, index: index)
            }
        }

    }
    
    private func getNewsForTab(selectedTab: Tabs, category: String, index: Int) {
        guard let page = tabsPageNumber[selectedTab]?.0 else { return}

        NewsAPI.topHeadlines(country: "us", page: page, category: category)
            .sink { (completion) in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error)
                }
            } receiveValue: {[unowned self] tabNews in
                self.tabsArticles[selectedTab] = tabNews.articles
                self.downloadedIndexes.insert(index)
            }
            .store(in: &cancellables)
    }
    
    
    private func checkNextPageData(articles: [Article]) {
        if articles.count < 20 {
            if  isSearching && !searchText.isEmpty {
                hasMoreNews = false
                return
            }
            tabsPageNumber[selectedTab]?.1 = false
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
