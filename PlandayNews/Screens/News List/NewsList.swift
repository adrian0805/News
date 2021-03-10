//
//  NewsList.swift
//  PlandayNews
//
//  Created by Macarenco Adrian on 04.03.2021.
//

import SwiftUI

struct NewsList: View {
    @ObservedObject var viewModel: NewsListViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    titleView
                    SearchView(searchText: $viewModel.searchText, isSearching: $viewModel.isSearching)
                        .padding([.trailing, .leading, .bottom], 13)
                    tabsView
                    ScrollableNewsListView(articles: articles, category: viewModel.selectedTab.rawValue, checkLastCellAction: checkActionForLastCell)
                }
                .background(Color.background.edgesIgnoringSafeArea(.all))
                .navigationBarHidden(true)
                .onAppear {
                    //viewModel.getNews()
                }
                errorView
            }
            
        }
    }
    
    @ViewBuilder private var titleView: some View {
        if !viewModel.isSearching {
            TitleView(title: "news_list_news".localized)
                .frame(height: UIScreen.main.bounds.height / 11)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0)
                .padding(.horizontal, 13)
                .padding(.bottom, 0)
        }
    }
    
    @ViewBuilder private var tabsView: some View {
        if !viewModel.isSearching {
            TabsView(selected: $viewModel.selectedTab)
                .padding(.horizontal, 13)
        }
    }
    
    @ViewBuilder private var errorView: some View {
        if let error = viewModel.error {
            AlertView(title: "Oooopss, an error has occured", message: error.localizedDescription) {
                viewModel.error = nil
            }
        }
    }
    
    
    private var articles: [Article] {
        guard viewModel.searchedArticles.isEmpty || viewModel.searchText.count < 3 else { return viewModel.searchedArticles}
        return viewModel.tabsArticles[viewModel.selectedTab] ?? []
    }
    
    private func checkActionForLastCell(index: Int) {
        if index == articles.count - 1 {
            viewModel.getNextPageNews(isPaging: true)
        }
    }
}

private struct ScrollableNewsListView: View {
    var articles: [Article]
    var category: String
    var checkLastCellAction: (Int) -> Void
    var body: some View {
        ScrollView {
            ScrollViewReader { reader in
                LazyVStack(spacing: 15) {
                    ForEach(articles.indices, id: \.self) { index in
                        NavigationLink(destination: DetailsNewsView(article: articles[index], category: category)) {
                            NewsCell(article: articles[index])
                                .onAppear {
                                    checkLastCellAction(index)
                                    //checkActionForLastCell(index: index)
                                }
                        }.buttonStyle(FlatLinkStyle())
                        
                    }
                }.animation(nil)
                .padding(.horizontal, 8)
            }
        }
    }
}

private struct NewsCell: View {
    var article: Article
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                URLImage(url: imageURL)
                    .frame(width: 50, height: 50)
                    .cornerRadius(25)
                VStack(alignment: .leading) {
                    Text(article.author ?? "news_details_unknown_author".localized)
                    Text(dateString)
                        .font(.SFDisplayRegularFont(with: 12))
                        .foregroundColor(.gray)
                }
                Spacer()
            }
            .frame(maxWidth: .infinity)
            Text(title)
                .multilineTextAlignment(.leading)
            Text(description)
                .font(.SFDisplayLightFont(with: 14))
                .foregroundColor(.gray)
                .multilineTextAlignment(.leading)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
        }.padding(.all, 15)
        .background(Color.newsCellBackground)
        .cornerRadius(10)
    }
    
    var description: String {
        article.description ?? ""
    }
    
    var imageURL: URL? {
        return URL(string: article.urlToImage ?? "")
    }
    
    var dateString: String {
        guard let date = article.publishedAt else { return ""}
        return date.toString()
    }
    
    var title: String {
        article.title ?? ""
    }
}

struct TitleView: View {
    var title: String
    var body: some View {
        HStack {
            Text(title)
                .font(.SFDisplayBoldFont(with: 32))
                .padding(.bottom, 0)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
