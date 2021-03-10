//
//  AlertView.swift
//  PlandayNews
//
//  Created by Macarenco Adrian on 10.03.2021.
//

import Foundation
import SwiftUI

struct AlertView: View {
    var title: String = ""
    var message: String = ""
    var okButtonTitle: String = "Ok"
    var confirmAction: () -> Void
    var body: some View {
        VStack() {
            VStack(alignment: .center) {
                Text(title)
                    .font(.SFDisplayBoldFont(with: 24))
                    .multilineTextAlignment(.center)
                Text(message)
                    .padding([.trailing, .leading], 20)
                    .multilineTextAlignment(.center)
                    .font(.SFDisplayRegularFont(with: 16))
                    .padding()
                Button(action: {
                    confirmAction()
                }, label: {
                    Text(okButtonTitle)
                })
                .padding([.trailing, .leading], 28)
                .padding(.top, 20)
            }
            .frame(width: UIScreen.main.bounds.width - 80, height: 300)
            .background(Color.background)
            .cornerRadius(8)
        }
        .frame( maxWidth: .infinity, maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .center)
        .background(Color(UIColor.label).opacity(0.3).edgesIgnoringSafeArea(.all))
    }
}
