//
//  SearchView.swift
//  PlandayNews
//
//  Created by Macarenco Adrian on 04.03.2021.
//

import SwiftUI

struct SearchView: View {
    @Binding var searchText: String
    @Binding var isSearching: Bool
    var body: some View {
        HStack {
            HStack(spacing: 5) {
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .frame(width: 12, height: 12)
                    .foregroundColor(Color.seachColor)
                    .padding(.leading , 8)
                TextField("Search for a news", text: $searchText)
                    .accentColor(Color.seachColor)
                    .font(.system(size: 16))
                if searchText != "" {
                    Button {
                        searchText = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .frame(width: 16, height: 16)
                            .foregroundColor(Color.darkGray)
                            .background(Color.white)
                            .cornerRadius(8)
                            .padding(.trailing , 8)
                    }
                }
            }.frame(height: 35)
            .background(Color.searchBarBackground)
            .cornerRadius(8)
            .onTapGesture(perform: {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                isSearching = true
                            }            })
            if isSearching {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isSearching = false
                    }
                    searchText = ""
                    
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    
                }, label: {
                    Text("Cancel")
                })
                .transition(.bottomTrailing)
            }
        }
    }
}

