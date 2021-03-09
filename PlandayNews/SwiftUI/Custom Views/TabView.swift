//
//  TabView.swift
//  PlandayNews
//
//  Created by Macarenco Adrian on 09.03.2021.
//
import Foundation
import SwiftUI

//var tabs = ["business", "entertainment","health", "science", "sports", "technology"]

enum Tabs: String, CaseIterable{
    case general = "General"
    case business = "Business"
    case entertainment = "Entertainment"
    case health = "Health"
    case science = "Science"
    case sports = "Sports"
    case technology = "Technology"

}


struct TabsView: View {
    @Binding var selected : Tabs
    @Namespace var animation
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(Tabs.allCases, id:\.self) { tab in
                    TabButton(title: tab.rawValue, selected: $selected, animation: animation)
                    if Tabs.allCases.last != tab { Spacer(minLength: 0)}
                }
            }
        }
        .clipped()
        .cornerRadius(22)
        
    }
}

struct TabButton: View {
    var title: String
    @Binding var selected: Tabs
    var animation: Namespace.ID
    
    var body: some View {
        Button(action: {
            withAnimation(.spring()) {
                selected = Tabs(rawValue: title) ?? .general
            }
        }) {
            Text(title)
                .font(.system(size: 15))
                .fontWeight(.bold)
                .fixedSize()
                .foregroundColor(selected.rawValue == title ? .white : .deselectedTextColor)
                .padding( .vertical, 10)
                .padding( .horizontal, selected.rawValue == title ? 20 : 0)
                .background(
                    ZStack {
                        if selected.rawValue == title {
                            Color.selectedTab
                                .clipShape(Capsule())
                                .matchedGeometryEffect(id: "Tab", in: animation)
                        }
                    }
                    )
        }
        .disabled(selected.rawValue == title)
    }
}
