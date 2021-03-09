//
//  DetailsNewsView.swift
//  PlandayNews
//
//  Created by Macarenco Adrian on 08.03.2021.
//

import SwiftUI

struct DetailsNewsView: View {
    var article: Article
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack {
            VStack(spacing: 10) {
                SourceView(article: article)
                    .frame(height: 60)
                ScrollView {
                    VStack {
                        URLImage(url: imageURL)
                            .frame(width: UIScreen.main.bounds.width - 20, height: UIScreen.main.bounds.width * 3 / 4, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .cornerRadius(5)
                        Text(article.title ?? "")
                            .font(.SFDisplayBoldFont(with: 24))
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                        HStack(spacing: 3) {
                            Image(systemName: "clock")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 13, height: 13)
                            Text(article.publishedAt?.getTimeAgoString() ?? "")
                                .font(.SFDisplayLightFont(with: 13))
                        }
                        
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.gray)
                        Text(article.description ?? "")
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                            .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                            .font(.SFDisplayLightFont(with: 16))
                        
                        NavigationLink(
                            destination: WebViewContainer(article: article),
                            label: {
                                Group {
                                    Text("Link: ")
                                        .font(.SFDisplayRegularFont(with: 14))
                                        .foregroundColor(Color(UIColor.label))
                                        +
                                        Text(article.url ?? "")
                                        .underline()
                                        .font(.SFDisplayRegularFont(with: 14))
                                        .foregroundColor(.blue)
                                }
                                
                                .frame(maxWidth: .infinity, alignment: .leading)
                            })
                    }
                    
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .navigationBarHidden(true)
            }.padding(.horizontal, 10)
            
        }
        
        
    }
    var imageURL: URL? {
        return URL(string: article.urlToImage ?? "")
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
                Image(systemName: "chevron.backward")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(Color(UIColor.label))
                    .frame(width: 8, height: 15)
            }).padding(.top, 13)
            VStack(alignment: .leading) {
                Text(article.source?.name ?? "")
                    .font(.SFDisplayBoldFont(with: 32))
                    .padding(.leading, 10)
                Text("By " + (article.author ?? "unkown author"))
                    .font(.SFDisplayRegularFont(with: 12))
                    .foregroundColor(.gray)
                    .padding(.leading, 10)
                
                Divider()
                    .foregroundColor(.gray)
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
