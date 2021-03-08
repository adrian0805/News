//
//  NewsList.swift
//  PlandayNews
//
//  Created by Macarenco Adrian on 04.03.2021.
//

import SwiftUI

struct NewsList: View {
    @ObservedObject var viewModel: NewsListViewModel
    @State var isDetailsViewShown = false
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {
                    if !viewModel.isSearching {
                        TitleView(title: "News")
                            .frame(height: geometry.size.height / 11)
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0)
                            .padding(.horizontal, 13)
                            .padding(.bottom, 0)
                    }
                    SearchView(searchText: $viewModel.searchText, isSearching: $viewModel.isSearching)
                        .padding([.trailing, .leading, .bottom], 13)
                    ScrollView {
                        LazyVStack(spacing: 15) {
                            ForEach(articles.indices, id: \.self) { index in
                                NavigationLink(destination: DetailsNewsView(article: articles[index])) {
                                    NewsCell(article: articles[index])
                                        .onAppear {
                                            checkActionForLastCell(index: index)
                                        }
                                }.buttonStyle(FlatLinkStyle())
                                
                            }
                        }
                        .padding(.horizontal, 8)
                    }
                }
                .background(Color.background.edgesIgnoringSafeArea(.all))
                .navigationBarHidden(true)
                .onAppear {
                    viewModel.getNews()
                }
            }
        }
    }
    
    var articles: [Article] {
        guard viewModel.searchedArticles.isEmpty || viewModel.searchText.count < 3 else { return viewModel.searchedArticles}
        return viewModel.articles
    }
    
    func checkActionForLastCell(index: Int) {
        if index == articles.count - 1, viewModel.hasMoreNews {
            viewModel.getNextPageNews(isPaging: true)
        }
    }
}

struct NewsCell: View {
    var article: Article
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                URLImage(url: imageURL)
                    .frame(width: 50, height: 50)
                    .cornerRadius(25)
                VStack(alignment: .leading) {
                    Text(article.author ?? "Unknown author")
                    Text(dateString)
                        .font(.SFDisplayRegularFont(with: 12))
                        .foregroundColor(.gray)
                }
                Spacer()
                Image(systemName: "bookmark")
                    .resizable()
                    .frame(width: 11, height: 15, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .foregroundColor(.blue)
            }
            .frame(maxWidth: .infinity)
            Text(article.title ?? "")
                .multilineTextAlignment(.leading)
            Text(article.description ?? "")
                .font(.SFDisplayLightFont(with: 14))
                .foregroundColor(.gray)
                .multilineTextAlignment(.leading)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
        }.padding(.all, 15)
        .background(Color.newsCellBackground)
        .cornerRadius(10)
        
    }
    
    var imageURL: URL? {
        return URL(string: article.urlToImage ?? "")
    }
    
    var dateString: String {
        guard let date = article.publishedAt else { return ""}
        return date.toString()
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
struct FlatLinkStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
}
