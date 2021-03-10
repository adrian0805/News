//
//  NewsListViewModel.swift
//  PlandayNews
//
//  Created by Macarenco Adrian on 04.03.2021.
//

import Foundation
import Combine

class NewsListViewModel: ObservableObject {
    @Published var searchedArticles = [Article]()
    @Published var tabsArticles = [Tabs : [Article]] ()
    @Published var isSearching = false
    @Published var searchText = ""
    @Published var selectedTab = Tabs.general
    @Published var error: Error?

    var searchPage: Int = 1
    var hasMoreNews = true
    var cancellables = Set<AnyCancellable>()
    var downloadedIndexes = Set<Int>()
    var tabsPageNumber = [Tabs:(Int, Bool)]()
    
    
    init() {
        setTabsPageNumber()
        createSubscriptions()
    }
    
    func setTabsPageNumber() {
        for tab in Tabs.allCases {
            tabsPageNumber[tab] = (1, true)
            tabsArticles[tab] = []
        }
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
              hasMoreNews,
              let selectedIndex = Tabs.allCases.firstIndex(of: selectedTab) else { return}
        isSearching && !searchText.isEmpty ? searchNews(isPaging: isPaging) :
        getNewsForTab(selectedTab: selectedTab, index: selectedIndex)

    }
    
    private func createSubscriptions() {
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
                getNewsForTab(selectedTab: category, index: index)
            }
        }

    }
    
    private func getNewsForTab(selectedTab: Tabs, index: Int) {
        guard let page = tabsPageNumber[selectedTab]?.0 else { return}

        NewsAPI.topHeadlines(country: "us", page: page, category: selectedTab.rawValue)
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] (completion) in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error)
                    self.error = error
                }
            } receiveValue: {[unowned self] tabNews in
                self.addNews(selectedTab: selectedTab, tabNews: tabNews, index: index)
            }
            .store(in: &cancellables)
    }
    
    private func addNews(selectedTab:Tabs, tabNews: News, index: Int) {
        guard let isSelectedCategoryEmpty = self.tabsArticles[selectedTab]?.isEmpty else { return }
        if isSelectedCategoryEmpty {
            self.tabsArticles[selectedTab] = tabNews.articles
        } else {
            self.tabsArticles[selectedTab]?.append(contentsOf: tabNews.articles)
        }
        if !self.downloadedIndexes.contains(index) {
            self.downloadedIndexes.insert(index)
        }
        self.checkNextPageData(articles: tabNews.articles)
    }
    
    
    func checkNextPageData(articles: [Article]) {
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
            .receive(on: DispatchQueue.main)
            .sink { (completion) in
                switch completion {
                case .finished:
                    break
                case .failure(_):
                    break
                }
            } receiveValue: { [unowned self] (news) in
                    if isPaging {
                        self.searchedArticles.append(contentsOf: news.articles)
                    } else {
                        self.searchedArticles = news.articles
                    }
                self.checkNextPageData(articles: news.articles)
            }.store(in: &cancellables)
    }
}
