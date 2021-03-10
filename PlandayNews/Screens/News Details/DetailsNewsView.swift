//
//  DetailsNewsView.swift
//  PlandayNews
//
//  Created by Macarenco Adrian on 08.03.2021.
//

import SwiftUI

struct DetailsNewsView: View {
    var article: Article
    var category: String
    
    var body: some View {
        VStack {
            VStack(spacing: 10) {
                SourceView(article: article)
                    .frame(height: 60)
                    .padding([.top, .horizontal], 10)
                Divider()
                    .foregroundColor(.gray)
                ScrollableDetailsView(article: article, category: category)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    .padding(.horizontal, 10)
                .navigationBarHidden(true)
            }
            
        }
    }
}

private struct ScrollableDetailsView: View {
    var article: Article
    var category: String

    var body: some View {
        ScrollView(/*@START_MENU_TOKEN@*/.vertical/*@END_MENU_TOKEN@*/, showsIndicators: false) {
            VStack {
                URLImage(url: imageURL)
                    .frame(width: UIScreen.main.bounds.width - 20, height: UIScreen.main.bounds.width * 3 / 4, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .cornerRadius(5)
                Text(articleTitle)
                    .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                    .font(.SFDisplayBoldFont(with: 24))
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                timeCategoryView
                .frame(maxWidth: .infinity)
                .foregroundColor(.gray)
                Text(articleDescription)
                    .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                    .font(.SFDisplayLightFont(with: 16))
                    .lineLimit(nil)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                urlView
                    .padding(.top, 20)
            }
        }
    }
    
    @ViewBuilder var timeCategoryView: some View {
        HStack(spacing: 3) {
            Images.clock.getImage()
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 13, height: 13)
            Text(timeString)
                .font(.SFDisplayLightFont(with: 13))
            Spacer()
            Text(category)
                .font(.SFDisplayRegularFont(with: 15))
                .foregroundColor(.blue)
        }
    }
    
    @ViewBuilder var urlView : some View {
        NavigationLink(
            destination: WebViewContainer(article: article),
            label: {
                Group {
                    Text("news_details_link".localized + " ")
                        .font(.SFDisplayRegularFont(with: 15))
                        .foregroundColor(Color(UIColor.label))
                        +
                        Text(articleUrl)
                        .underline()
                        .font(.SFDisplayRegularFont(with: 15))
                        .foregroundColor(.blue)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            })
    }
    
    private var articleDescription: String {
        article.description ?? ""
    }
    
    private var articleTitle: String {
        article.title ?? ""
    }
    
    private var articleUrl: String {
        article.url ?? ""
    }
    
    private var imageURL: URL? {
        return URL(string: article.urlToImage ?? "")
    }
    
    private var timeString: String {
        article.publishedAt?.getTimeAgoString() ?? ""
    }
}

struct SourceView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var article: Article
    
    var body: some View {
        HStack( alignment: .top) {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Images.backImage.getImage()
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(Color(UIColor.label))
                    .frame(width: 8, height: 15)
            }).padding(.top, 13)
            VStack(alignment: .leading) {
                Text(sourceName)
                    .font(.SFDisplayBoldFont(with: 32))
                    .padding(.leading, 10)
                Text(authorTitle)
                    .font(.SFDisplayRegularFont(with: 12))
                    .foregroundColor(.gray)
                    .padding(.leading, 10)
            }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        }
    }
    
    private var authorTitle: String {
        "news_details_by".localized + " " + (article.author ?? "news_details_unknown_author".localized.lowercased())
    }
    
    private var sourceName: String {
        article.source?.name ?? ""
    }
}
