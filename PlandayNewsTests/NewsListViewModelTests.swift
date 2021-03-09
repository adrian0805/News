//
//  NewsListViewModelTests.swift
//  PlandayNewsTests
//
//  Created by Macarenco Adrian on 09.03.2021.
//

import XCTest
@testable import PlandayNews

class NewsListViewModelTests: XCTestCase {
    var viewModel: NewsListViewModel!

    override func setUp() {
        viewModel = NewsListViewModel()
        let news = Mock.getMockObject(jsonName: "NewsMock", of: News.self)
        guard let articles = news?.articles else { return}
        viewModel.tabsArticles[Tabs.general] = articles
        viewModel.selectedTab = .general
    }
    
    override func tearDown() {
        viewModel = nil
    }
    
    func testGetGeneralArticles() {
        let generalArticlesNr = viewModel.tabsArticles[.general]?.count
        XCTAssertEqual(generalArticlesNr, 19)
    }
    
    func testHasNextPage() {
        guard let articles = viewModel.tabsArticles[.general] else { return}
        viewModel.checkNextPageData(articles: articles)
        let hasMoreNews = viewModel.tabsPageNumber[viewModel.selectedTab]?.1
        XCTAssertEqual( hasMoreNews, false)
    }

}
